From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Add support for reporting LSO
 capabilities
Date: Wed, 27 Apr 2016 20:35:42 +0300
Message-ID: <20160427173542.GB11554@leon.nu>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <20160427164230.GB11617@obsidianresearch.com>
 <20160427170903.GA11554@leon.nu>
 <20160427171451.GA17172@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160427171451.GA17172-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2016 at 11:14:51AM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 27, 2016 at 08:09:03PM +0300, Leon Romanovsky wrote:
> > On Wed, Apr 27, 2016 at 10:42:30AM -0600, Jason Gunthorpe wrote:
> > > On Wed, Apr 27, 2016 at 05:04:50PM +0300, Matan Barak wrote:
> > >=20
> > > > This patch series enables hardware to report Large Segment Offload(=
LSO)
> > > > capabilities from kernel to user space. LSO enabled NIC will accept=
 big chuck of
> > > > data with size greater than MTU. The LSO engine will split them into
> > > > separate packets and insert the headers automatically. With LSO, CP=
U is
> > > > offloaded from dealing with much less throughput of data.
> > >=20
> > > I also feel like we should stop changing the current uAPI until we get
> > > the new one in place.
> >=20
> > This functionality doesn't relate to ABI change and don't change
> > current/future interfaces.
>=20
> What do you mean it doesn't change current interfaces? That is all
> this patch does.

It uses the same old write/read mechanism. The patch doesn't change it.

>=20
> > There is no need to stop changes like this.
>=20
> Why do we need to keep churning the uAPI now that we are committed to
> deprecating it?

We are committed to change write/read interface.

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIPhtAAoJEORje4g2clinADwQAKxU/OcOlTMRHK9ThC7BMTHf
CtqC6TPp2/9zkmvS8rpPw8S4Mjkb2YIsz7glySmmFO2bc1JM3ubdMY7xBiSuI+kM
mbRi6Yx7K88GDaTFhCqbQGoA97xMOm9Px/290B2tr+1/6ja5dT1RHnLovspjBdUV
rX5BXPqAfp92d28z5bvP3eSmfpI9EFsPlXjKN7LnNTJJLm/HmopYYaw6zQ3bhohf
wR3s75kXmCa5HmsaC4+jEvf0wTu6cXPuqVsXwiJnnh4isfA83zdO5pGLANqCx/7x
lLGVRcOT9vEE6M4JeRqhYUiSNitGojVYo1ILwhsAlkCv0432QNgofxL8QPXPuMiT
6Pr/9zKZgCKktxvXTn88MowPCJuqNKoC3W/Hdg6q/F43uj6RYfisTp/tmhdTJEjh
ADsGgKKN0NjEileYbOin8Qg8VXuD6406yTlHB/2IbV5l+k2AANJ4pKf8zlmZkggq
RwhGtqqjYKsYn5lSSEfQfcOS7ZhU0EbkviRb1d5AMnQ0L1VpICG76P9ZXMZcvzHQ
IFXaHSHnAe3zg7MdXVW8+w7Ql5fIyrlSJRtXJVClX9h2skyIqsfZLd2MZBOicWcl
D+9i/qv8/VN55H2mX8BzWQbOtFY7aQX3ZJsJnLzg64XL7L67gCY4muON/MXhFq0Q
MgEsekXiBt3TKzoZ45DV
=19vG
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
