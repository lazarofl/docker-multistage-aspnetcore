# Restaura e copia os arquivos do projeto
FROM microsoft/aspnetcore-build:2.0 AS base-env
COPY . .
RUN dotnet restore

# Roda os testes de unidade
FROM microsoft/aspnetcore-build:2.0 AS test-env
WORKDIR /tests
COPY --from=base-env ./tests .
RUN dotnet test tests.csproj

# Publica o projeto web
FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app
COPY --from=base-env ./web .
RUN dotnet publish web.csproj -c Release -o out

# Copia a pasta do projeto web publicado e roda a aplicação web
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "web.dll"]