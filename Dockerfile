﻿# Giai đoạn build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy file csproj và restore
COPY *.csproj ./
RUN dotnet restore

# Copy toàn bộ source
COPY . ./
RUN dotnet publish -c Release -o /out

# Giai đoạn runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Cài compiler và python
RUN apt-get update && apt-get install -y \
    g++ gcc python3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /out ./

# Mở cổng web (nếu dùng mặc định)
EXPOSE 5024

ENV ASPNETCORE_URLS=http://+:5024

ENTRYPOINT ["dotnet", "OnlineJudgeAPI.dll"]
