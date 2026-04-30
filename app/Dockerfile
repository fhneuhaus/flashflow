# Use the official Node.js LTS image as the base.
# Node 22 is the current LTS as of late 2025; appropriate for production.
FROM node:22-slim

# Set the working directory inside the container.
# All subsequent commands run from here.
WORKDIR /app

# Copy package files first, before the rest of the source.
# This is a Docker layer-caching optimisation: dependencies only
# re-install if package.json or package-lock.json change, not on every
# code edit.
COPY package.json package-lock.json ./

# Install all dependencies including devDependencies.
# We need TypeScript (a devDependency) for the build step that follows.
RUN npm install

# Copy the rest of the application source.
COPY . .

# Compile TypeScript to JavaScript.
RUN npm run build

# Tell Fly which port the app listens on.
EXPOSE 3000

# The command to run when the container starts.
CMD ["npm", "start"]