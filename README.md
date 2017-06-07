# Tealium Library for Roku

This library leverages the power of Tealium's [AudienceStream™](http://tealium.com/products/audiencestream/) making it natively available to Roku applications. Please contact your Account Manager first to verify your agreement(s) for licensed products.

### What is Audience Stream ?

Tealium AudienceStream™ is the leading omnichannel customer segmentation and action engine, combining robust audience management and profile enrichment capabilities with the ability to take immediate, relevant action.

AudienceStream™ allows you to create a unified view of your customers, correlating data across every customer touchpoint, and then leverage that comprehensive customer profile across your entire digital marketing stack.

## How To Get Started

* Check out the [Getting Started](https://community.tealiumiq.com/t5/Mobile-Libraries/Mobile-150-Getting-Started-with-Roku/ta-p/14595) guide for a step by step walkthough of adding Tealium to an extisting project.  
* The public API can viewed online [here](https://community.tealiumiq.com/t5/Mobile-Libraries/Tealium-Roku-APIs/ta-p/14717), it is also provided in the Documentation directory
> NOTE:
>
> Tealium objects are now constructed using a builder pattern, where account, profile, and logLevel are required and environment and datasource are optional
>
> E.g. without environment and datasource: `tealium = TealiumBuilder("account", "profile", 3).Build()`
>
> E.g. with environment and datasource: `tealium = TealiumBuilder("account", "profile", 3).SetEnvironment("environment").SetDatasource("datasource").Build()`
>
> Account, profile, environment, and datasource are all strings, while logLevel is an integer from 0 to 3

* There are many other useful articles on our [community site](https://community.tealiumiq.com).

## Contact Us

* If you have **code questions** or have experienced **errors** please post an issue in the [issues page](../../issues)
* If you have **general questions** or want to network with other users please visit the [Tealium Learning Community](https://community.tealiumiq.com)
* If you have **account specific questions** please contact your Tealium account manager

## Change Log

- 1.2.0 Add Datasource
    - New variable added:
		- tealium_datasource
    - Implemented Builder pattern / old constructor deprecated
- 1.1.0 API Update
	- Update trackEvent takes an additional String type arg with one of the following values:
		- activity
		- conversion
		- derived
		- interaction
		- view
	- Additional Tealium variable:
		- tealium_event_type
- 1.0.0 Initial Release
	- Multiple instance support
	- TrackEvent Support


## License

Use of this software is subject to the terms and conditions of the license agreement contained in the file titled "LICENSE.txt".  Please read the license before downloading or using any of the files contained in this repository. By downloading or using any of these files, you are agreeing to be bound by and comply with the license agreement.


---
Copyright (C) 2012-2017, Tealium Inc.
