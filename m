From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] ibverbs: Add support for packet pacing
Date: Tue, 10 Jan 2017 10:18:22 +0200
Message-ID: <20170110081822.GI7218@mtr-leonro.local>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
 <1483893148-8211-3-git-send-email-yishaih@mellanox.com>
 <20170109153856.GA29687@obsidianresearch.com>
 <b9cca64f-0d67-6174-74e5-291f93b48c1c@dev.mellanox.co.il>
 <20170109170200.GB13960@obsidianresearch.com>
 <c50008b5-f0f2-a1a4-94e7-2354ea2b0123@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c50008b5-f0f2-a1a4-94e7-2354ea2b0123-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2017 at 11:44:55PM +0200, Yishai Hadas wrote:
> On 1/9/2017 7:02 PM, Jason Gunthorpe wrote:
> > On Mon, Jan 09, 2017 at 06:46:33PM +0200, Yishai Hadas wrote:
> >
> > > In case we want to do it in this layer I would vote on using memset at the
> > > beginning of that function to prevent repeating this for any new field. Your
> > > last patch in that area could do it as well.
> >
> > Sounds like you should clean this all up and use = {} consistently in
> > the providers and drop the explicit = 0.
>
> We can add some pre-patch to the series to make the
> ibv_cmd_modify/ibv_cmd_modify_ex behaves similarly by cleaning up the
> explicit = 0 and use = {} in all the providers.

Yes, please do it and send that patch as standalone cleanup before
series, so we will be able to apply it without waiting till packet
pacing is accepted.

Thanks

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh0mM4ACgkQ5GN7iDZy
WKd9dA/9FxQanJllidxQXoH21/e1JoxTRd1kDrdxCFZ38U7eSwLi8R00WpBcsT3S
GtVbZHlYnzEfvmK6ddp8KgObLOA39GKAxf+RTK6M+o2k8ea1zHMFjttMICWpPNuZ
aFTKK2i4g7K/8XK/rC1EaL6JAA1nzkxfBnpFJYEx3wYtUsDtQVCGjiKgEN8yOpYS
bRf2/dgLdVNzC6NUL3x3NxHGJNodnRcABE6UETdNYOVPNNLhIz8mhsBo4TUX5zc/
Y4COkYyZkE301XwHSYBBNHGAKGU0myGwMOOIdQyEVkh3n+SNQDLEpt1X0jYop65v
Vo9qHRat7e1S2b9r9LfOcyye+iRJhqoC9yKWLWB/H+mioqyXaUbXTm0wIFTnIfW+
7SfKkou8uislUElqWgZTeECD+IZIxJfm6Mxt/snIC61bOWMW/yZUzb+T7YGwrBDF
txKwCGHdeA4wLyb2z/zndDSZvTGJ5EmWv1xj0Ya5+JBsNdsJIMbFd2SvIrvSXpoH
5IBwwILDpHubJrAHoBpMdGhBXTLnZ9gHsQPxhim0841cRjMwdlRTAQNExz/5rCgh
AOa96dgiLKV9f2JrA1yG7BzDMkx0M+BW82EDZ/RhLa4BibR/vp7b1DI8LFST6gyo
fNEs3MBnxfcq5/EG2bDeL3PQSWlIR/6wwqLn/XAA5hKfXqnLA/A=
=6q2y
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
