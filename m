From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cxgb4/i40iw interoperability fixes
Date: Mon, 22 Aug 2016 14:44:52 -0400
Message-ID: <89ddfbec-33e9-b259-f3ea-dcc468f58b99@redhat.com>
References: <cover.1471617103.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xR933KH5NvpCAMaXhgSOXT2IpbkefOFCP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1471617103.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xR933KH5NvpCAMaXhgSOXT2IpbkefOFCP
Content-Type: multipart/mixed; boundary="Ja8uCQsXGstQK4p7Djm1IJkLb7TQt2mxP"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Message-ID: <89ddfbec-33e9-b259-f3ea-dcc468f58b99-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cxgb4/i40iw interoperability fixes
References: <cover.1471617103.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
In-Reply-To: <cover.1471617103.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--Ja8uCQsXGstQK4p7Djm1IJkLb7TQt2mxP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/19/2016 10:31 AM, Steve Wise wrote:
> Doug, these would be good for 4.8-rc.  They fix some interoperability
> problems between Intel and Chelsio iWARP devices.
>=20
> Changes since v1:
>=20
> - cleaned up commit comments.
>=20
> Steve Wise (2):
>   iw_cxgb4: limit IRD/ORD advertised to ULP by device max.
>   iw_cxgb4: use the MPA initiator's IRD if < our ORD
>=20
>  drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Ja8uCQsXGstQK4p7Djm1IJkLb7TQt2mxP--

--xR933KH5NvpCAMaXhgSOXT2IpbkefOFCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0gkAAoJELgmozMOVy/d9DYP/2qUfgwseFnbaBqWprl39DbB
JYJUxuZ6BqRUy0aweEYks3kT1cHbwE0JS/yRrqBw5bDRF4VBr5iixJEQmXoeOAPH
ZUmsY4EvREUynsy7qNiUAv2ukVD9cBDpEwsfX5lrpJGuvSXeScBLWzZPRvD68yWG
luJvadULiSzcpbof3NMYkGnv9Z8HubISlKCb2/RAM904qLQNFBD0XLSZOKvy56MG
QQ6ihS2nccAL1EbTlbyRegAC9oyr/5PxNhTT1PywlogaCQJKLo0CGKoiCZXhA5ki
0Vym94brad9E2RN/VISpjJwBE6PlQv3JFAW+euVnh3CWnOIdem5nR099rMRUfbpD
dKwoyVQqdXAB0WPpk/wBQcSXIIPCRHWjp1+lA/sxB+XRaDQL4DcynlnUY/kXlx+H
f20WYgZQNJc7zhwAIa+MHkTwHKyAsrLuiaqVk3+L91OkqYL0NiCaf/y12fY4NSC3
chIAxMzs1fyEslZLFhSXWSVkERFzdHd4UXs4SF+V8RRve/aCONtufWQSAhPqc1n6
2aBx0U8uBmM+6gI4CKUyEyQhI0y+N9/w+VIgXIzdUMkVzqyr6ELl0jAKH5BQ5482
N9WrTZNLmb4FPfDpdziHP/BHu/9nVeKMU2wctNKj6NZhtQ/EzhuVFoILBvgvacPs
rjEuv/+ncadX3lbdTOK9
=GH1a
-----END PGP SIGNATURE-----

--xR933KH5NvpCAMaXhgSOXT2IpbkefOFCP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
