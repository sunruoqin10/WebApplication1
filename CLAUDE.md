# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an ASP.NET Web Forms application targeting .NET Framework 4.7.2. It uses the classic Web Forms programming model with server-side controls and event-driven page lifecycle.

## Build Commands

- **Build**: `msbuild WebApplication1.slnx` or build from Visual Studio
- **Run**: Open in Visual Studio and press F5 (uses IIS Express on port 44354)
- **Restore NuGet packages**: `nuget restore WebApplication1.slnx`

## Architecture

### Page Structure
- **Site.Master** - Main master page with navbar and layout (located in root)
- **Content pages** (Default.aspx, About.aspx, Contact.aspx) - Use Site.Master with `ContentPlaceHolderID="MainContent"`
- **Code-behind files** (`.aspx.cs`) - Page logic with `CodeBehind` attribute in project file
- **Designer files** (`.aspx.designer.cs`) - Auto-generated control declarations

### Key Configuration
- **App_Start/BundleConfig.cs** - Registers script bundles (jQuery, WebForms.js, modernizr) and CSS
- **App_Start/RouteConfig.cs** - Enables FriendlyUrls with permanent redirect mode for clean URLs
- **Web.config** - Application configuration including compilation settings and authentication modes
- **packages.config** - NuGet package references

### Client Dependencies (via NuGet)
- Bootstrap 5.2.3 (CSS/JS)
- jQuery 3.7.0
- Modernizr 2.8.3
- Newtonsoft.Json 13.0.3
- Microsoft.AspNet.FriendlyUrls 1.0.2

### Application Lifecycle
- `Global.asax.cs` - Application_Start registers routes and bundles at startup
- `RouteConfig.RegisterRoutes` enables clean URLs (e.g., `/About` instead of `/About.aspx`)

## File Naming Conventions

- ASPX pages: `PageName.aspx` with `PageName.aspx.cs` code-behind and `PageName.aspx.designer.cs`
- Master pages: `Site.Master` with `Site.Master.cs` and `Site.Master.designer.cs`
- User controls: `ViewSwitcher.ascx` with code-behind and designer files
