FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run build

FROM nginx:latest AS release
WORKDIR /usr/src/app
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the port your app runs on
EXPOSE 80/tcp

CMD ["nginx", "-g", "daemon off;"]
