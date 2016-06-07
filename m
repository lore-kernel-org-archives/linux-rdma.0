From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Tue, 7 Jun 2016 10:16:21 +0300
Message-ID: <20160607071621.GB3663@leon.nu>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <85e56121-5911-37f4-2ac3-a1af561d5a7a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2016 at 07:53:43PM -0400, Doug Ledford wrote:
> On 6/4/2016 8:15 AM, Leon Romanovsky wrote:
> > From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > In a attribute group struct, attrs should point to a NULL
> > terminated list. Which means we need to allocate one more
> > slot in the array.
>=20
> This patch is both right and wrong.  You're right with the intent (that
> there should be a total of 2 extra entries in the array size, one for
> the NULL termination and one for the lifespan entry), but wrong with the
> mechanics (unless I've missed something).  We already have two extra
> entries because sizeof(*hsag) includes our first counter, so just
> num_counters is actually enough to NULL terminate the list, and + 1
> gives us lifespan plus a NULL terminate spot.  The comment could be
> cleaned up to make this more clear though, so I'll do that.

Thanks Doug.

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVnTFAAoJEORje4g2clinBvoP/ieEmcHF12nV/Om8Vc1ikyPH
xpXk+vSId1uzeKDgfvtfm328T/UVaSri6ltDIbbKGWh1Vjdl17dD2Xdob532CuI7
QDRH7EQRg+snSxSUlixHK5Ky0p251CFOvWbobQExel3TFcPD8IFbp+2M/oRFxaFU
yP2gHBnK8TydAZ5EUNa1zlLejDk4HBRUY2OEvyCojOVX4foNTNkZUfWTsCzEfyUR
qeIG5jUzfiZhqxbDR9k9DM9jgwT3gl7AFFO7Zw3MmV08bFOeBBEBpV9GRQml01u/
zG7/Ui+osrrnC1K/JMc/v6lQ0x/luWfPIXLLQQuCkhM1G5ux2+taFcwl1dFkyjAe
2eJaoWRatdDIbO13NT2ucQPUxZjvAm81zbYeW+WZ0pqp0H7rcSnU0mQ+kC6V/KoQ
fu/QlTkfexy7Ggcl2FIl7+siNTWm3Gliphoa7irsokX9X0zuFKB7JiKTK8FBd8El
1wwYypY9vMtonVqh7fRsB9gI9W446c7bm+wxIUkBCPEQ7o8LlxhvxwaHbiFG6hnw
wUQEJcJFyrnAJ3VcyLfVONkqEMGGTbI4I5Kjgjjr+at2ex5fAUn8ch/mNdOpSLHM
XevoBcZidfnjr3Afw+Su0adicCSrarkwMv8hoCRYsY0XxY2goRgdp4UBK0xWVDqz
r0co7QqG3rko7BPHKKrB
=lXQ3
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
