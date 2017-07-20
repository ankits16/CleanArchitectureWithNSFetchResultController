# CleanArchitectureWithNSFetchResultController
This repository show case clean architecture implementation of a simple Use case along with NSFetchResultController


This project has two targets :

1) TMDB : Main App Target
2) TMDB Tests : Test target

Architecture:
Movie List : I have used clean architecture by Bob Martin to implement this. Main components are 
    a) View Controller
    b) Interactor : Businness Logic
    c) Presenter : Presntation Logic
    d) Worker : All the api fetch, CRUD Operations and image fetches


Movie Detail : Its been coded using Apple MVC

Used core data for data handling.
