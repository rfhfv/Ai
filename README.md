# Building an iOS App with AI Chat and Video Generation

The project was built with the following:

* UIKit for building the user interface
* MVP (Model-View-Presenter) architecture for clean separation of concerns
* URLSession
* ApphudSDK for subscription management
* Modular architecture for scalability and maintainability

## Features

* **AI Chat Assistant**: Interactive chat interface for communicating with AI and getting help
* **Video Generation**: Create unique videos from text prompts using AI
* **Image Upload**: Upload custom images as a base for video generation
* **Modern UI**: Adaptive design with gradients and custom components
* **Paywall Module**: Full subscription management integrated with Apphud
* **Navigation**: Screen flow management via Coordinator pattern

## Main & Paywall

<p float="left">
  <img width="370" height="800" alt="Image" src="https://github.com/user-attachments/assets/9d1b0788-d1b9-4ad8-b9ba-95cea9f9f09f" />
  &nbsp; &nbsp; &nbsp;
  <img width="370" height="800" alt="Image" src="https://github.com/user-attachments/assets/674396a0-4cc5-4c4f-8402-93ea7387c158" />
</p>

## Chat and History
  
<img width="370" height="800" alt="Image" src="https://github.com/user-attachments/assets/92ea8003-1ee0-4e48-9623-690fdfbd0d78" />

## Video Generation
  
<p float="left">
  <img width="370" height="800" alt="Image" src="https://github.com/user-attachments/assets/98c5ae4b-e53b-4b1e-9572-bd471419b5ea" />
  &nbsp; &nbsp; &nbsp;
  <img width="370" height="800" alt="Image" src="https://github.com/user-attachments/assets/4b1910a6-c2ff-4af7-8acc-a80a14391175" />
</p>

## Result (share, download, refresh generation)
  
<img width="370" height="800" alt="Image" src="https://github.com/user-attachments/assets/64f868c3-0a21-45ee-a5fe-8f71bfe82a27" />

## Technical Stack

### Architecture
The project follows the **MVP (Model-View-Presenter)** pattern, ensuring clear separation of responsibilities:
* **Model**: Contains business logic and data structures (e.g., `VideoGenerationModel`)
* **View**: Responsible for displaying UI and forwarding user actions (e.g., `VideoView`, `PaywallView`)
* **Presenter**: Contains presentation logic, handles user actions, and updates the View (e.g., `VideoResultPresenter`)

### Key Components
* **UIKit**: For building flexible and performant interfaces
* **ApphudSDK**: Integrated for subscription and in-app purchase management
* **URLSession**: For performing network requests
* **Async/await**: For writing asynchronous code
* **GCD**: For multithreading management
* **StoreKit**: For handling purchases through Apphud
* **SFSymbols**: For using system icons
