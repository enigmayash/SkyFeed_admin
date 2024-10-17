**SkyFeed** - Video Streaming Platform

SkyFeed is a video streaming platform designed to provide a seamless video-watching experience, similar to Netflix and Amazon Prime Video. This application allows users to sign up, log in, upload their own videos, and stream content from various categories. It leverages Flutter for the frontend and AWS services for cloud-based video storage, streaming, and processing.

**Features**
User Authentication: Users can sign up and log in using AWS Cognito, ensuring secure access.

Video Upload & Storage: Users can upload videos from their devices, which are stored securely in AWS S3.

Cloud-Based Video Streaming: Videos are streamed efficiently using AWS CloudFront, offering smooth playback across various devices and networks.

Video Transcoding: Videos are transcoded using AWS MediaConvert into multiple formats for optimized playback on different devices.

Categorized Content: Videos are categorized by genres for easier content discovery.

Real-Time Analytics: Track views, comments, and user activity with AWS CloudWatch and AWS Pinpoint.

**Tech Stack**

Frontend: Flutter

Backend: AWS (S3, Cognito, Lambda, MediaConvert, CloudFront)

Database: DynamoDB / Firestore (for storing video metadata)

Video Processing: AWS Lambda and MediaConvert for transcoding videos

Real-Time Analytics: AWS CloudWatch and Firebase for tracking user activities

**Installation**

Prerequisites

Flutter: Make sure Flutter is installed on your machine. You can download it here.

AWS Account: You will need an AWS account to configure the cloud services. Set up AWS Amplify and Cognito for user authentication.
