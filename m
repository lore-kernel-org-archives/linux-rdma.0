From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB core sysfs: Add port_xmit_wait_counter V2
Date: Fri, 8 Jul 2016 17:58:59 +0300
Message-ID: <20160708145859.GA24660@leon.nu>
References: <alpine.DEB.2.20.1607071231550.20276@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607071231550.20276-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2016 at 12:36:00PM -0500, Christoph Lameter wrote:
>=20
> V1->V2
> - Tested. Found that we missed modifying one table.
>=20
>=20
> Add the missing port_xmit_wait counter. This counter is displayed through
> some tools like perfquery but is not available via sysfs.
>=20
> For the PORT_PMA_ATTR macro the _counter field is set to zero
> allowing us to specify the offset directly like with PORT_PMA_ATTR_EXT
>=20
> See also the earlier work in 2008 by Vladimir Skolovsky
>=20
> https://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg20313.html
>=20
> Tested-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Hi Christoph,
Do you mind to improve the commit message a little bit?
1. Put versioning in [PATCH] section - {PATCH v3]. It will give clean
subject line in git history.
2. Put changelog after "---" line at the end of commit message.
3. Add Vlad's SOB (Signed-off-by: Vlad Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>).
4. Remove your Tested-by line, it goes without saying.
5. Change title to format used in this subsystem - IB/core: Add ....

Thanks

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXf7+zAAoJEORje4g2clinci4QAJ02E22fW1zraC6zJvVL5Xto
NV0RtNcCr79Dxc47v8UwHXiLE6ZDvRQVWLNOBzJfZBih0QeWTbegPgmk4umjZLSf
Mtth7vsGnRlXjOWSxIRZILJZwV84OglB+BKU/KUY1/eb1z133F2QMCA6IoaJZ9Ai
zBI3s77scpB9CqGhuaQWFmVYpAK7WxA0kcyhZ708iT1bWlX1pmkSVmP6PcwKmJdG
ABk2lJQHrquWiFgPHRhiXJoBDv6uzTR0lW3ihdITnvMsBgT9zUxBMtpqhfuTetyN
zQK46wg0XMFIJj4yyZv0iHHflKGcDsQPzTl+XCVNu/XtZvg/fPq+FsYa7AL+0adI
HobhFYm5swZY0EQdRT/iTC8STd9tSkfQS5CZJTeWLFMp8qojaRabAjhMxcQ9NMl6
wkk9vr3R8tFsh+dBx7lhQ9J+AmQrwsFaCofcKv6MvejxacWzbh8cJmjvePXKl7GR
1LwydJYj1Xh06gNNwsgg+Xbgl3z2SjybcYrrzGn7Bx6Gr2vCM0Ji21+ohvRQroUL
9a9D+ibSNfyFu8E35KA2QWu9baMqZ8EJuT+Pq0vNIVvCBNbcjdUQ3aXFNVOq1eXK
V33elLnzOlQv32BcI1viyXkv0PRwR5yFbVnFfnMv4jo1/FClI1ZiPgUNYdZx8krd
ULgBLO3WctyD63UAjqmu
=9zja
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
