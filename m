From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Upcoming libibverbs release
Date: Thu, 23 Jun 2016 12:51:47 -0400
Message-ID: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BvcNjBX5QTOIvhHCLhS7LQmlsNCSqu6GE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BvcNjBX5QTOIvhHCLhS7LQmlsNCSqu6GE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I'm preparing to make an official release of libibverbs soonish
(thinking by the end of next week).  Even though I took the timestamp v5
patchset, I know there were still comments from Jason on the v4 set that
weren't addressed in v5.  Those can be addressed (and should be) with
incremental patches prior to the official release.  Yishai, can we
please prioritize getting that done?

Here's the git changelog from the official 1.2.0 release to the current
HEAD:

7f272c00424b Update .gitignore
20e2daec4578 Fail compiles if no platform specific memory barriers exist
0de26fb8b62d libibverbs: add ARM64 memory barrier macros
d0e4e455b96e Add basic man page entry for ibv_xsrq_pingpong
8f59a5c28654 Merge remote-tracking branch 'yishaih/fcs'
2928832d0649 Add timestamp support in rc_pingpong
f4e6a85248fa Add a verb that queries real time values from the HCA
169a6efad9e5 Create a single threaded CQ
c2e36f6797f4 Add completion timestamp to poll_cq
1c8a921d0227 Add timestamp_mask and hca_core_clock to ibv_query_device_ex=

10f97b68181a Add member functions to poll an extended CQ
4ace2118493b Add support for extended creating CQ verb
5852b93d3bcd Add SCATTER_FCS QP create flag
86d774420968 Add extended device capability flags
215736f7cdb1 Extend devinfo verbosity mode
102b4a1544d4 Add GID support to ibv_xsrq_pingpong example
d1a785654046 Fix exchange message size in ibv_xsrq_pinpong example
46cdea5373de Add an example to ibv_create_flow man page
69042c660f06 Add man page for flow steering verbs
c6eebd5adae5 Add support for don't trap steering rule
00b93fd20b28 Add MR re-registeration
8d97353b7857 Change rereg_mr API between libibverbs and the provider's
library
85061a41fb58 Extend man pages to describe Memory Window usage
398abfded7ea Expose device capabilities for Memory Window type two
568c67c878c2 Add bind/unbind support for Memory Window type two
6148efe68f5f Expose device capability for Memory Window type one
e437deed93c2 Add bind/unbind support for Memory Window type one
518fcbd42a29 Add alloc/dealloc Memory Window verbs
e29e171145b0 Update ibv_post_send manual page
5085d749c6bd Add QP creation flags, support blocking self multicast loopb=
ack
b5eac7cbfb0a Allow use of huge pages in multiple calls to ibv_fork_init
027dd68002ae libibverbs: Modify ibv_asyncwatch to accept the monitored
device
515a067586e0 Roll 1.2.0 release
89cb59ef7fd9 libibverbs.spec.in: Use config.h substitution
678f7fa7dde8 Makefile.am: Don't allow strict aliasing by default
70d200860584 Makefile.am: Fix "make distcheck"
700d098ed190 Add GID support to ibv_xsrq_pingpong example
fa87a514d257 Fix exchange message size in ibv_xsrq_pinpong example
21b0a974ed7c Add an example to ibv_create_flow man page
1755d907c523 Add man page for flow steering verbs
fa6574cfa3a2 Add support for don't trap steering rule
ba9b4ae0a9a3 Add MR re-registeration
ffb784b9514e Change rereg_mr API between libibverbs and the provider's
library
f224da05def5 Extend man pages to describe Memory Window usage
18f011121c70 Expose device capabilities for Memory Window type two
e45a827d01ec Add bind/unbind support for Memory Window type two
1f8c7f3c1f9d Expose device capability for Memory Window type one
6033c6986f12 Add bind/unbind support for Memory Window type one
fbf5740a75fb Add alloc/dealloc Memory Window verbs
f3e38c1d10c6 Update ibv_post_send manual page
0e60aab43bfb Add QP creation flags, support blocking self multicast loopb=
ack
2f9f51529f07 Allow use of huge pages in multiple calls to ibv_fork_init
786f5edc841f libibverbs: Modify ibv_asyncwatch to accept the monitored
device

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BvcNjBX5QTOIvhHCLhS7LQmlsNCSqu6GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbBOjAAoJELgmozMOVy/dG/8P/RuKDvRiqxnuIp/AgYXnLjwH
PuV17OC0gmEFRBjQ6QQvvinh83M18LeuaxtGTgLt89QhAlBZlK9FXhrTSV17WqRx
AWuisGIeqwtLx2ET3NmNZe857x76Fnlm5KHm1a39QG7xqAY9qZXahLLBFvpzXOq7
sjHgn311CJKoRBsiU4toEoYGeCA9jUcBrAALFs18SW5wKWlwIGu9LkyiJOpYaV2E
PYUCtL9AWDKcVqWT1SNhEJG4fnr4NwFbT7NHtBVTw3+kFfa2IxyXjM5eYd/GMKiG
tccZVfQJimeZrp75UxsC5i+opmn9cfHkS8Mie7QhSCjRSYYEjXQdUcOHn2L5R8Rm
7+Vya5xTSheV/dI1mBQlev7IYpph7jjwFZsIIFspaYnwKR+Ugj+6Dw95WGRqhTil
Aop9Vk3hm7uE8ADhQ5KQxUHrTxW8nvWP1YyLjug74FUUNSQXURzFDLZNEKlXRmn2
YI9McJrbK6D1iNBL9FXH1whVvKBJq85upz+594c96MPyy8K9Bpe/nvxhUXyu97MC
xs5cekuzy5YmXjaSSWUM25ZKMlewvFWeS2nvs3hw4oZPjl2asaE3nTJmsGcTKOZB
O/XfHP/vEeNpIgcG5GlyhYjuWP6iKaifn9qy1pY/CP10nyR5chY4oNek3h/9s8Tl
FM4SjjUkXhqUZ55Erecf
=5qG4
-----END PGP SIGNATURE-----

--BvcNjBX5QTOIvhHCLhS7LQmlsNCSqu6GE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
