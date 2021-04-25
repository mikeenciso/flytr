# flytr
[![GPL Licence](https://badges.frapsoft.com/os/gpl/gpl.svg?v=103)](https://opensource.org/licenses/GPL-3.0/)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Flytr is a free and open-source flight-tracking Android & iOS mobile application developed using Flutter.
It connects to OpenSky-Network's Live REST API for flight information.

## Contributors
- **Mike Enciso** - lead developer: [GitHub](https://github.com/mikeenciso), [Web](https://blackopscode.com).
 
## Built with
- [Flutter](https://flutter.dev/) - Beautiful native apps for Android and iOS.
- [OpenSky-Network](https://opensky-network.org/) - a non-profit association based in Switzerland. It aims at improving the security, reliability and efficiency of the air space usage by providing open access of real-world air traffic control data to the public.
- [Android Studio](https://developer.android.com/studio/index.html/) - Tools for building apps on every type of Android device.
- [Visual Studio Code](https://code.visualstudio.com/) - Code editing. Redefined.
- [Google Maps Platform](https://cloud.google.com/maps-platform/) - Maps.

## Contributing
Thank you for considering and taking the time to contribute to this project!

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we have a code of conduct, please follow it in all your interactions with the project.

### Code of Conduct
Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

- The use of sexualized language or imagery and unwelcome sexual attention or advances
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information, such as a physical or electronic address, without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting

### Developer Setup
- Fork this repository, and cd into it.
```bash
git clone https://github.com/mikeenciso/flytr.git
cd flytr/
```
- In AndroidManifest.xml, replace GOOGLE_MAP_API_KEY with your Google Map API Key
```
<meta-data android:name="com.google.android.geo.API_KEY"
               android:value="GOOGLE_MAP_API_KEY"/>
```

Then, download either Android Studio or Visual Studio Code, with their respective [Flutter editor plugins](https://flutter.io/get-started/editor/). For more information about Flutter installation procedure, check the [official install guide](https://flutter.io/get-started/install/) .

Install dependencies from pubspec.yaml by running ```flutter packages get``` from the project root (see using [packages documentation](https://flutter.io/using-packages/#adding-a-package-dependency-to-an-app) for details and how to do this in the editor).

There you go, you can now open & edit the project. Enjoy!

### How to Report Bugs and Request Feature
Please open [a new issue in the GitHub repository](https://github.com/mikeenciso/flytr/issues/new/choose) with steps to reproduce the problem you're experiencing.

Be sure to include as much information including screenshots, text output, and both your expected and actual results.

### Branches
- dev - pr this for your changes.
- prod - please don't touch this.

## Requirements
- Create Splash Screen (Apr 18, 2021 - App launching Splash Screen added in local. Image should be updated, currently using Flutter logo)
- Should display live airplane locations and orientation
- Replace Google Maps with an offline OpenStreetMap tile via flutter leaflet implementation
- Prevent users from rotating the map
- Prevent users to zoom to a certain extent
- Update Airplane image
- Add Airports
- Display other relevant flight information
- Use different Airplane image if plane is currently on the ground
- When clicked, airplane may show option to track the specific plane, plot track from latest grounded status.

## License
This project is licensed under the GNU GPL v3 License - see the [LICENSE.md](LICENSE.md) file for details.
