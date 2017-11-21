From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 18:48:02 +0200
Message-ID: <20171121164802.GY18825@mtr-leonro.local>
References: <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
 <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
 <20171121160442.GB18272@ziepe.ca>
 <20171121163454.GW18825@mtr-leonro.local>
 <20171121163648.GC18272@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q+qpHfi2NROeSQHU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121163648.GC18272-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--q+qpHfi2NROeSQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 09:36:48AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 21, 2017 at 06:34:54PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 21, 2017 at 09:04:42AM -0700, Jason Gunthorpe wrote:
> > > On Tue, Nov 21, 2017 at 09:37:27AM -0600, Daniel Jurgens wrote:
> > >
> > > > The only warning that would make sense is if the mixed ports aren't
> > > > all IB or RoCE. As you note, CX-3 can mix those two, we don't want to
> > > > see warnings about that.
> > >
> > > I would really like to see cx3 be changed to not do that, then we
> > > could finalize this issue upstream: All device ports must be the same
> > > protocol.
> >
> > I don't see the point of such artificial limitation, the users who
> > brought CX-3 have option to work in mixed mode and IMHO it is not right
> > to deprecate such ability just because it is hard for us to code for it.
>
> I don't really think it is really too user visible.. Only the device
> and port number change, but only if running in mixed mode.

Ahh, correct me if I'm wrong, you are proposing to split mlx4_ib devices
to two devices once it is configured in mixed mode, so everyone will
have one port only. Did I understand you correctly?

>
> It is not just 'hard for us' it is impossible to reconcile the
> differences between ports when enforcing device level things.
>
> This keeps coming up again and again..
>
> Jason

--q+qpHfi2NROeSQHU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloUWMIACgkQ5GN7iDZy
WKe/nBAAldjqIxoKELFY4il5Lk/3fsRrT4LZByj9CFgDZAggDoFszwuoAy46DsXc
UBtOvUSQrHu7RGaTToU2lszTplwQF87CfzsxHPNJJn1BdUn5XQkYSonA/UQPEiU1
cAC+6GaDcoYiEwu0ZrP5i5Uivvwjw182wdjTMTKmX9RnHe8rJFn/EL9ACXsMX73J
Zj6v/dX4rCOuPDk1rPAdHtOtSVUwyBNpIA/5L+JM3M2miG/nCkWpBN0LU7leIxCB
sWSuhP+pfEWb1RIWvx9zukUYLavenNwwYdmP0mQ+mE/CMUdnbFOjhqhVc8356YJ/
hYTRqgvj8mlH3dEEiNMr1NUyeOLikCOvC7ZYquMvHjb9tm44iFDnTbqeFFyaxHXv
vUQSVfsQK9KcDoXYM+ADOhOQBlu6zzfSQbmAKEJrOwORbNuCE/+3fRm47OVZVBDs
rkbHbIamp3Q7O0Bb0xkyKxp/3smHv756zywgu14yXCqC5raAqSF9J85349J2oz/z
r2B5M2ZQpWxBaQj6/zgOpl+6ynvZ/9iSn4iZFCLi3/D10MYQJaUSGq8CqASM7c01
3WmunLSumllv5/sOXVwcTBT/9ITO9Rtjdo3Hwn1vZsbdIlI2KZ50OY95Ess4GOj7
StRywyYlwgXboejNcLwYTIHVYyebZga/0SqnFo6NGORBbG3rPnA=
=ACBL
-----END PGP SIGNATURE-----

--q+qpHfi2NROeSQHU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
