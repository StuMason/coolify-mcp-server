# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Use a Node.js image as the base
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --ignore-scripts

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# Create a release image with only necessary files
FROM node:18-alpine AS release

# Set the working directory
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/build /app/build
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

# Install production dependencies only
RUN npm ci --ignore-scripts --omit=dev

# Set environment variables (example values)
ENV COOLIFY_ACCESS_TOKEN=your_access_token
ENV COOLIFY_BASE_URL=https://your-coolify-url.co.uk

# Command to run the application
ENTRYPOINT ["node", "build/index.js"]
