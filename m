From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/5] Trivial fixes for 4.7
Date: Fri, 13 May 2016 15:22:26 -0400
Message-ID: <f6c6e2c3-517f-409f-ff08-928e9604c945@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mR4i21jb0ah7hrNAXvfMp89xcOxBTh5SN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462563928-29164-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mR4i21jb0ah7hrNAXvfMp89xcOxBTh5SN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/06/2016 03:45 PM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> I'm sending to you small collection of trivial fixes to core code.
>=20
> It fixes forgotten skb release call, potential overrun in CMA/SA, integ=
ration of
> ib_addr.ko into ib_core.ko and one code simplifications which doesn't i=
ntroduce
> any code change behavior.
>=20
> Available in the "topic/fix-core" topic branch of this git repo:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/fix-core
>=20
> Changes since v2:
>  * Removed iwcm_nl_cb_table size initialization
>=20
> Changes since v1:
>  * Added Reviewed-by tags
>  * Revisited titles
>  * Removed RDMA_NL_RDMA_CM_NUM_OPS and RDMA_NL_LS_NUM_OPS
>  * Removed useless enumeration value
>  * Converted ib_addr module to be integral part of ib_core module
>=20
> Leon Romanovsky (1):
>   IB/core: Integrate IB address resolution module into core
>=20
> Mark Bloch (4):
>   IB/IWPM: Fix a potential skb leak
>   IB/core: Remove unnecessary check in ibnl_rcv_msg
>   IB/core: Fix a potential array overrun in CMA and SA agent
>   IB/SA: Use correct free function
>=20
>  drivers/infiniband/core/Makefile    |  6 ++----
>  drivers/infiniband/core/addr.c      | 11 ++---------
>  drivers/infiniband/core/cma.c       |  3 ++-
>  drivers/infiniband/core/device.c    | 11 ++++++++++-
>  drivers/infiniband/core/iwcm.c      |  2 +-
>  drivers/infiniband/core/iwpm_util.c |  1 +
>  drivers/infiniband/core/netlink.c   |  5 ++---
>  drivers/infiniband/core/sa_query.c  |  4 ++--
>  include/rdma/ib_addr.h              |  3 +++
>  9 files changed, 25 insertions(+), 21 deletions(-)
>=20

I've taken the first four of these.  I'll respond to the fifth separately=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--mR4i21jb0ah7hrNAXvfMp89xcOxBTh5SN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNilyAAoJELgmozMOVy/dO4cP/05/LLlfqKyRZHXBhVjfHbRQ
B7Bd/Dpk5zhD4ahtp8EhPeyPIKb/2YSBtZXPbQinG51DcvCA7uc8I+0pvsAtAZew
j3zIfiwsnnC1T9+EJyjM/nGOwqfENn1IiPsur7eSNgrcc/md0T12leWT5GDNb+3X
wDpyWiqgapCkRARUgK7UJ6vXqOOrGCBfdIB0kGr872OoU53x9fEOg4r+0/4EKNVl
+uDZIcgkTcZo6p4V/8VlLQz+eZrz6ZJDsITM1Oy595ddjLnEZF0SLgfAbZePMX+w
pVbwd8QZiT3pnbialaEvRv12QsMCr2sveoZ1fWE6zuwRibwwzfbJX3DTl9tOIa0H
oI0cmo+xj3fpvsYh5WJ/uaa5JthPIJZvt5YvaXjVX/dJg0tt+D596CsJgqAbNIFV
x6STr+kE+aKJjE+eDugIqEAG3782wRWH+WibDXw7ODeBAH+M8Iuwiaw3Sa922nkN
oJIPtjTIdAqZyn4BiTa4Mn+7Ay5jsRGUasHFi7jn+C7bTWTwghdcPW9DnbPrcEaA
GZi9E+O+j/RzpSlfrPeWMsIo0IvJ9n4UTX4I9XYXYcWkhxeZpOJQfso/qgfkXnfd
3OHjrMqc7SLsqyR87pzTojK8r8j8vD8ZXOWxqawuaFLC+kDKYJyr3N50CxDO71yO
j9tgvalFLUw2PdWXxfHx
=fM0r
-----END PGP SIGNATURE-----

--mR4i21jb0ah7hrNAXvfMp89xcOxBTh5SN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
