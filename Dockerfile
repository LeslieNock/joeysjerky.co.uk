FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g @angular/cli
# copy csproj and restore as distinct layers
COPY *.sln .
COPY ["joeysjerky.co.uk/joeysjerky.co.uk.csproj", "joeysjerky.co.uk/"]
RUN dotnet restore "joeysjerky.co.uk/joeysjerky.co.uk.csproj"
# copy everything else and build app
COPY . ./
WORKDIR "/app/joeysjerky.co.uk"
RUN dotnet publish -c Release -o out /p:PublishWithAspNetCoreTargetManifest="false"
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/joeysjerky.co.uk/out ./
ENV ASPNETCORE_URLS http://*:5000
EXPOSE 5000
ENTRYPOINT ["dotnet", "joeysjerky.co.uk.dll"]