From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] Bug Fixes and Code Improvement in HNS driver
Date: Wed, 28 Sep 2016 10:57:07 -0400
Message-ID: <57EBDA43.3010708@redhat.com>
References: <20160910040930.25988-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4AEoGKI3F6350wQiDT8Hq0haakDc6aQKx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160910040930.25988-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4AEoGKI3F6350wQiDT8Hq0haakDc6aQKx
Content-Type: multipart/mixed; boundary="wju4WsmooMkfHttlCT0HHOCsJJoGsRQTQ";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 "oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 "yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Message-ID: <57EBDA43.3010708-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] Bug Fixes and Code Improvement in HNS driver
References: <20160910040930.25988-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20160910040930.25988-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--wju4WsmooMkfHttlCT0HHOCsJJoGsRQTQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/10/16 12:09 AM, Salil Mehta wrote:
> This patch-set introduces fix to some Bugs, potential problems
> and code improvements identified during internal review and
> testing of Hisilicon Network Subsystem driver.
>=20
> Hi Doug,
> These are few HNS patches which are not related to HNS RoCE driver but
> are being sent through your repository hns-roce (as requested) to mitig=
ate
> any conflicts with HNS RoCE driver for the 4.9 merge window. In future
> i.e. after 4.9 we will go by more formal git-pull request method once
> HNS RoCE base driver becomes part of 4.9.

Hi Salil,

I've chatted with Dave Miller about this series.  Here's where we stand.

First, the review feedback from Dave:

---

In patch #7, their comments are mis-formatted and these
hns guys do this a lot.

	/*fix hardware broadcast/multicast packets queue loopback */

They seem to have a hard time putting an initial space in the comment,
and properly capitalizing and punctuating their sentences.

Also in that new function, they need to order local variables from
longest to shortest line (reverse christmas tree format).

Patch #6 has the local variable ordering issue as well as does patch
#3.

---

Please address those issues and resubmit.

As for the method of resubmission, please send the set to netdev@ and
also linux-rdma@, make note that, as a one off thing, these will need to
go through my tree to avoid conflicts with patches already in my tree,
and that future submissions will follow the Mellanox model of submitting
shared code to both mine and David's tree that is needed to avoid
conflicts for that merge window's submissions.  After the netdev people
have reviewed it, and Dave acks it, either he can pick it up and sort
the conflicts out, or I can pick it up.

>=20
> Daode Huang (6):
>   net: hns: bug fix about setting coalsecs-usecs to 0
>   net: hns: add fini_process for v2 napi process
>   net: hns: delete repeat read fbd num after while
>   net: hns: fix the bug of forwarding table
>   net: hns: bug fix about broadcast/multicast packets
>   net: hns: delete redundant broadcast packet filter process
>=20
> Kejian Yan (1):
>   net: hns: fix port not available after testing loopback
>=20
> lipeng (1):
>   net: hns: fix port unavailable after hnae_reserve_buffer_map fail
>=20
>  drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |  11 ++-
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |  13 ++-
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |   2 +
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  10 --
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h |   1 -
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |  16 ++++
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_reg.h  |   4 +
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c      | 106 +++++++++++++=
+-------
>  drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   7 ++
>  9 files changed, 117 insertions(+), 53 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--wju4WsmooMkfHttlCT0HHOCsJJoGsRQTQ--

--4AEoGKI3F6350wQiDT8Hq0haakDc6aQKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX69pDAAoJELgmozMOVy/dTjIP/RF/Wpn1+VAKCaGKYJewKlH/
Zchi0jFK16cAzrKo7p1oDMzTGT/XOMjU9uIM7kwrrJKP7FPQkjezmsaYcOol6F0X
axM2k8ZYZOZ/z7uHU0ZnNLws54aBAxMABhpiyJ35iNbH83vEmQPPdogh+9JaZI+Q
cGzq4CaK/ZCJOo64+I5UJ+TafVqzcyC6QynYctZja4BtUJ54dZAkyRxv/YUTLpEm
axOgyAzdcDnGGyVKCIRIl+nuMLGQ7ucGQQYW6TDPdsNzhS5lwKh4mSm3p1LeOt1K
hoKCWcb3zBVG3z1WRWc8L1mBQxEUSq/kVNFXQO8LEtEK+OwzqmbZB/usmBhIEw4U
FWXFrDqNW+2IGXUv+uli+FcjJ60YC22KEkhSlerKRHRsGWcaTreW0pXq4sJ6b+Lw
Smap6Za4oIS1yRf6ajvwr829X/YngRryh+tjbX1oREle101X9qTR7rZIwmDiIOMW
ID3PE4CFok5XLLPB3/obQapJx7lj48ETxJ6WiVM+Ci6aykdkXDTQJX5+eh7VxYdk
Uqo2FokGJtF5eAphDw441cZssavfwJOa950kGhBHQuKzBYcmysEsh+RGARXe6pEI
B9U/kkcfU7b6TwtE0I2xBTd+bZiaY9TsXASLc4EvJN10ey6AxTmVhRgwcRIukq9D
BXlS90uVDT3TwAMstBiM
=lb5S
-----END PGP SIGNATURE-----

--4AEoGKI3F6350wQiDT8Hq0haakDc6aQKx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
