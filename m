From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15.3 and 16.2 has been tagged/released
Date: Thu, 1 Feb 2018 15:25:51 +0100
Message-ID: <71e81500-0d0a-d280-db3e-92467807899d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here's the information from the tags:
tag v15.3
Tagger: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Date:   Thu Feb 1 09:43:31 2018 +0100

rdma-core-15.3:

Updates from version 15.2:
  * Backport fixes:
    * iwpmd: fix double mutex unlock
    * libbnxt_re: Fix lat test failure in event mode
    * libbnxt_re: Update and sort device pci-id table
    * cbuild: Support distros that only ship python3
    * libbnxt_re: Display FW version using ibv_devinfo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJactNQAAoJEIAb3bglmI9k+IUH/An5KayMXGChyFI4X+QXlRpe
JD2SxeP5MTGBkfLMKgPJq/vdkWVNCy1HWf3/nnNTiV1rn0r0PzLJJc0g9u38168Y
1KwV9bEo4k0irSeB9ozynZoM8u7EI0W7Frg4RVrUN/BskG/F32NjEZN2azf7cnX2
vCE7E0AYlrLMne4gQHDk7LT90JlcpbJAsS3yXliZ1t/y3u5gGMenXUmlwby0Hpih
akz4Onwao16spJByZgaslYaTABnsfLinkuAx1r48PFnWq1HGRUOyrkKqoYxdsrV7
bz/jasrB2T4Mt4kuhv8uGDlM81fFtGRFC8OLKsZjWoU7Q0hbeI36JwxZK+CeBAI=
=N01y
-----END PGP SIGNATURE-----

tag v16.2
Tagger: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Date:   Thu Feb 1 09:38:53 2018 +0100

rdma-core-16.2:

Updates from version 16.1:
  * Backport fixes:
    * iwpmd: fix double mutex unlock
    * libbnxt_re: Fix lat test failure in event mode
    * libbnxt_re: Update and sort device pci-id table
    * cbuild: Support distros that only ship python3
    * libbnxt_re: Display FW version using ibv_devinfo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJactLSAAoJEIAb3bglmI9kns0IAJeBQTuUhyTu2TdUc1sl2JOe
lQL8y6vNYuFEl1vj4yYI0GKd8qzYTosNdEz6AhglmSqu/X5wF5arfli/JYnfjITf
sPR0dNeG8LJ9srh3oNbfxGAdkIWmIqIA7AVVxAbg9vsARKOZarHrgpoGHRo5hvwZ
senzOfhBc9io5SV3eAW3sbbRUEvNfVIEfKKd/9nXFNurvAz3X84gXu1saUcOpgAN
UA6JqELNA+xl0mdKaCzNAPWEB8Q04glDxSTxCRhttOTuEgxwVCu2vTbadsU0Z3ij
eWyqV0Y/yLElAcmqRg4ChRiD/JZTQ5sK9NEUU3pbYXHDpfVH+DI2kuzGWZuT/TI=
=X/fd
-----END PGP SIGNATURE-----


It's available at the normal places:

git://github.com/linux-rdma/rdma-core
https://github.com/linux-rdma/rdma-core/releases

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
