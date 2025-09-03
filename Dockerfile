#FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
#WORKDIR /App

#COPY . ./
#ARG TARGETARCH
#RUN dotnet restore CarCareTracker/CarCareTracker.csproj
#RUN dotnet publish -c Release -o out CarCareTracker/CarCareTracker.csproj
# Use the official .NET SDK image as a build environment
# Use the official .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /src

# Copy the solution and project files
COPY LubeLogger.sln .
COPY LubeLogger/LubeLogger.csproj ./LubeLogger/

# Restore dependencies for the solution
RUN dotnet restore

# Copy the rest of the application's source code
COPY . .

# Publish the application
WORKDIR /src/LubeLogger
RUN dotnet publish -c Release -o /app/publish

# ---

# Build the final image from the ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/publish .
ENTRYPOINT ["dotnet", "LubeLogger.dll"]




FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .
EXPOSE 8080
CMD ["./CarCareTracker"]
