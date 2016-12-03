From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Remove workaround for pre-production errata
Date: Sat, 03 Dec 2016 15:59:08 -0500
Message-ID: <1480798748.15032.79.camel@redhat.com>
References: <20161019203332.7972-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qmcSYHEQKXujmM1tFWvf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161019203332.7972-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-qmcSYHEQKXujmM1tFWvf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-10-19 at 15:33 -0500, Henry Orosco wrote:
> Pre-production silicon incorrectly truncates 4 bytes of the MPA
> packet in UDP loopback case. Remove the workaround as it is no
> longer necessary.
>=20
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied. =C2=A0And, in order to save time, I also applied these
other patches:

[PATCH] i40iw: Set MAX IRD, MAX ORD size to max supported value
[PATCH] i40iw: Fix for LAN handler removal
[PATCH] i40iw: Optimize inline data copy
[PATCH] i40iw: Query device accounts for internal rsrc
[PATCH] i40iw: Remove checks for more than 48 bytes inline data
[PATCH] i40iw: Remove NULL check for cm_node->iwdev
[PATCH] i40iw: Use actual page size
[PATCH] i40iw: Use runtime check for IS_ENABLED(CONFIG_IPV6)
[PATCH] i40iw: Use vector when creating CQs
[PATCH] i40iw: Remove check on return from device_init_pestat()
=C2=A0 This one had some patch issues I fixed up, you might want to
=C2=A0 double check it
[PATCH] i40iw: Remove variable flush_code and check to set qp->sq_flush
[PATCH] i40iw: Correct values for max_recv_sge, max_send_sge
[PATCH V2] i40iw: Convert page_size to encoded value
[PATCH] i40iw: Fix incorrect assignment of SQ head
[PATCH] i40iw: Utilize physically mapped memory regions
[PATCH] i40iw: Add 2MB page support
[PATCH] i40iw: Add missing cleanup on device close
[PATCH] i40iw: Add IP addr handling on netdev events
[PATCH] i40iw: Replace list_for_each_entry macro with safe version
[PATCH] i40iw: Add NULL check for ibqp event handler
[PATCH] i40iw: Fill in IRD value when on connect request
[PATCH] i40iw: Correctly fail loopback connection if no listener
[PATCH] i40iw: Code cleanup, remove check of PBLE pages
[PATCH] i40iw: Add request for reset on CQP timeout
[PATCH] i40iw: Set TOS field in IP header

For future release, please batch your patches up and send them as a
series. =C2=A0Tracking down and dealing with singleton patches when you hav=
e
an entire truckload that needs processed greatly increases the
processing time required.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-qmcSYHEQKXujmM1tFWvf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYQzIcAAoJELgmozMOVy/d/YgP/AiYI6OtAZZJ2Zke81rdRYfl
CJWnA8qGg6GC6FIEcdjXlpY0kGBYI9OXVVoyviEE/9CNed49qHPccGLFHGYzEW8V
2M18kqx1QQSxenKerwuUs7vgZISXky8wfy/VYwxQW1uCGDDkgRtWJ1vFkDwTSnfI
oMP17R/JDMfIsAFy9qDLypRT4J2+XqkJoiukCMBRf4HhmFVoxMko42mNDeEKr+cs
guWMPlXnolYEhTOyUG9xYkLYQecB0yLNOLnYUHyGC3/nzuFaOhPLdCdgVCdcEMil
d9FgwnLFAn4S7lxpLISvXN7SCey9oqNSaAHXiWxSCZyc5o0W50FB3hUgQXntVqyd
/CupphV47Ng50f0LV7I79iNpt++2LI+x5sWA18xzDrnKGz/J+G1zhw8sZBclVTm4
5tziljc3uWfQ74pZ4SueXeG88l2JBQPZQ+GR5WzAEDNFQzuczjq4w0mmrhxsu03H
yXgTVOs8SfN72KU76+VVc6xAgnnIVJMBqeVol0tR0Wyd2gFM/ToSD3y7Pe7aJEEp
q1EI1Yp9p+KDMqnoj+plR6aowtgwpHSRK18gJF4x8nTKYqSdpQ7Au8sLCzKK2guR
o5k2leO4T+KU1DS8Z3QrN8jsQovaBlTUaEDGNjqcx/fWOqno0OnSUn8y6jmxF7hr
RkQozMamTKSIunSNIYIU
=PyuY
-----END PGP SIGNATURE-----

--=-qmcSYHEQKXujmM1tFWvf--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
