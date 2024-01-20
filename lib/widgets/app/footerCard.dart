import 'package:augmntx/components/web_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FooterPage extends StatefulWidget {
  const FooterPage({super.key});

  @override
  State<FooterPage> createState() => _FooterPageState();
}

class _FooterPageState extends State<FooterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      // alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(40),
          Image.network(
            "https://augmntx.com/assets/img/augmntxlogo.png",
            width: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.contain,
          ),
          const Gap(20),
          /* ------------------------------ infoprmation ------------------------------ */
          const Text(
            "Information",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/about-us";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "About Us",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/corporate-information";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Corporate Information",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/press";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Press",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/careers";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Careers",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://blog.augmntx.com/";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Blog",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/contact-us";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(20),
          /* --------------------------------- AugmntX --------------------------------- */
          const Text(
            "AugmntX",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/profiles";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "View Profiles",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/discover";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Discover",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/on-demand-talent";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "On Demand Talent",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/pricing";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Pricing",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(20),
          /* --------------------------------- Vendor --------------------------------- */
          const Text(
            "Vendor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/join";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Apply as Vendor",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/admin/auth/login";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Vendor Login",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/post-job";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Post Jobs",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/remote-jobs";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Remote Jobs",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              const url = "https://augmntx.com/home/resources";
              Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": url,
                },
              );
            },
            child: const Text(
              "Resources",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffd3d3d3),
              ),
            ),
          ),
          const Gap(50),
          /* --------------------------------- divider -------------------------------- */
          const Divider(
            color: Colors.white,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                const Text(
                  "© 2022-2023",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const Gap(8),
                const Text(
                  "AugmntX",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Labor Omnia Vincit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffd3d3d3),
                    ),
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "⚡ by",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffd3d3d3),
                    ),
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: () {
                    const url = "https://superlabs.co/";
                    Navigator.of(context).pushNamed(
                      WebViewScreen.routeName,
                      arguments: {
                        "url": url,
                      },
                    );
                  },
                  child: const Text(
                    "SuperLabs",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff0000ff),
                    ),
                  ),
                ),
                const Gap(15),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Terms of Use",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffd3d3d3),
                    ),
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffd3d3d3),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
