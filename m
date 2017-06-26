From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: your mail
Date: Mon, 26 Jun 2017 08:38:41 +0300
Message-ID: <20170626053841.GZ1248@mtr-leonro.local>
References: <20170626052117.GX1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p+/4B2pcxE3X6xU6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170626052117.GX1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--p+/4B2pcxE3X6xU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 26, 2017 at 08:21:17AM +0300, Leon Romanovsky wrote:
> David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Bcc:
> Subject: Re: Proposal for the 2nd RDMA microconference (LPC 2017)
> Reply-To:
> In-Reply-To: <786f10f7-6253-c95b-49e2-a89010a43781-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> On Sun, Jun 25, 2017 at 11:43:35AM +0300, Marcel Apfelbaum wrote:
> > Hi Leon,
> >
> > Here is our proposal for the coming conference.
>
> Thanks Marcel for sending proposal, I'm looking forward to see you and
> Yuval there.
>
> In the meantime, I'm adding David who is our LPC POC and would like to
> ask some questions.
>
> >
> > Abstract
> > --------
> > QEMU's limited RDMA support leaves it behind other modern hypervisors.
> > Marcel and/or Yuval will present the implementation of an emulated RDMA
> > device, analyze its performance and usability, and finally talk about future
> > plans for a possible virtio-rdma device.
>
> How are you implementing different fabrics? Does it completely SW
> implementation and/or it requires HW beneath like prvdma? Namespaces,
> migration?
>
> What are the expectations from the community?
>
> >
> > Audience
> > --------
> > The audience is developers interested in device emulation / RDMA.
> > They can expect an interesting discussion on what are the difficulties to
> > work with RDMA in Virtual Machines and they will be welcomed to share their
> > ideas.
> >
> > Benefits to the Ecosystem
> > -------------------------
> > Knowing how to tackle RDMA on virtualization may give developers an easier
> > start on adding RDMA support to QEMU, which in turn will leverage the modern
> > RDMA cards on virtualized environments.
> >
> >
> > Thanks,
> > Marcel & Yuval



--p+/4B2pcxE3X6xU6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllQneEACgkQ5GN7iDZy
WKe3qg/9FFmwYOE7EZnJRkYJ656fs8h4gvawWWVgkwDLljwOHSaVVzCbjcCeYh+c
BrCk1B8ktLpl3sD6SEXK2NrtAT4/oMQ3jBK0nsFCDAxpsjKjr7m4Gs9i3HWo2lb3
1GdVVzSvuAz5XeqRO7OK1MAWpyYOMjhW5eL2tHKGw83ERJFvFrx7Td0fxF2hMrEx
tBJoua5k5Ond1wCcvijajrwvbXwi76uB6R855JDys6tSV+xNMxhPp2fmBOJOyKCV
e0tU37wKwX+lI4RN8sCs9ylvvOKpjEs0ygqFeqziesE2dClkIepE6e07x4ydnDdZ
EWptwcEj7yREDK4tRIB7sDBo5hygvIY5f2pz4NGbrV2lCD1xUm445PFhUlmWok9g
NGqPz88AyJ6qcK5a9jc31jN+t2y/Z6kESv+qaQo675bS//X+aA3/ZB+dOmhQ1Y8o
7GEDucW82VAyk3Ff+NOZwANpXwREsiM8oyTcw3pPP51/b6ccMWMuyGI7QiXP0hrD
8Szx/dbfxgA1uI+7FRkBrWdGbarvY5pzR4RnY06YGSBFRqNe08ZA8zZxFZQmU0U/
pyBYuUEBDV90cQ1YGT00sdL5zLgdqi5Xq2+m098B869hT7Fvnz70sZHZNd3pfY2X
cjLcrm1bF95j3oyN9OKItA9+t85bCEC8TZsXXjiO+xs5ov4z9BQ=
=f5wn
-----END PGP SIGNATURE-----

--p+/4B2pcxE3X6xU6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
