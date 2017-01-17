From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Tue, 17 Jan 2017 21:31:57 +0200
Message-ID: <20170117193157.GO32481@mtr-leonro.local>
References: <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
 <20170112201622.GA14584@obsidianresearch.com>
 <20170113150824.GQ20392@mtr-leonro.local>
 <20170113171234.GA30551@obsidianresearch.com>
 <20170113203127.GT20392@mtr-leonro.local>
 <20170113212721.GB1463@obsidianresearch.com>
 <20170115083543.GA20392@mtr-leonro.local>
 <20170116201218.GA7890@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JlJsEFsx9RQyiX4C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170116201218.GA7890-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 16, 2017 at 01:12:18PM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 15, 2017 at 10:35:43AM +0200, Leon Romanovsky wrote:
> > On Fri, Jan 13, 2017 at 02:27:21PM -0700, Jason Gunthorpe wrote:
> > > On Fri, Jan 13, 2017 at 10:31:27PM +0200, Leon Romanovsky wrote:
> > >
> > > > > This is about what happens if the multicast MTU < unicast MTU - which
> > > > > is *exactly* the same case on RC and UD.
> > > > >
> > > > > IPoIB cannot send a 64k multicast MTU on RC either.
> > > >
> > > > Multicast is sent in datagram despite being in connected mode and for
> > > > datagram the MTU is limited by IB
> > >
> > > I am aware of that. Read you patch again:
> > >
> > > > +	if (priv->mcast_mtu < priv->admin_mtu)
> > > > +		ipoib_warn(priv, "MTU must be smaller than mcast_mtu (%u)\n",
> > >
> > > This check is fails in RC mode as well.
> > >
> > > And we already check if the requested MTU is beyond the port
> > > capability:
> > >
> > > +        if (new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
> > > +                return -EINVAL;
> > >
> > > So I have *no idea* why you'd want to check it against the multicast
> > > group too..
> > >
> >
> > Port MTU capability can be higher than link MTU. In this flow, the user
> > can try to set manually MTU which will be higher than SM provided.
> >
> > Immediately after that print, we have a following piece of code:
> >  236         dev->mtu = min(priv->mcast_mtu, priv->admin_mtu);
>
> Maybe the better fix is to take that min out than generate a
> warning.

It looks like that I need more time to grasp it.
Sorry about that.

>
> Jason

--JlJsEFsx9RQyiX4C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh+cS0ACgkQ5GN7iDZy
WKcUhRAApLjByf31z2YC9Vdcv/Lp4289WmxUMJ8F0l2ZJ6R4ptqFhP0+qDLVuNYT
NSen0AiMXIDbTVhFiv+4FqZqgFn9rbgqhr1dpXdqW5xU0QJfPFFG75oLMUtdJpXC
A3DQYzx3QSqoD0zTM2pMEF7JWL5rZJvfLIEqdZ5b565qPyGCpiJ0cO6lx9o39s74
RvxfBcwLCgO2V15fVw4lR09Z+qesnXG3urqDkwCwL0QSg3vLF7YfuYvP4aOweRqG
Nz9bOV6HCevS4A3+BntwRowXg6UJRA/Trl0x+5Z6jy2vBChUCPe7fbuznKW69JS1
NgUJ63YuEhRzET8VveolNp9x32OBuIMx9xbEPgmvOiRNjOJ7vJjwj6X33A6GeeL9
25vi5jI5epDHeKSUsQ8StTUC3pESEgiDwiI8Q4Rg9Ki/QdAH4drqOfJZBjsvSPb1
8XRGUrtlmPyGtilI2IG/LSR7eVYGN0WJbDqVrfOG0UFaQuOVekBHJxnMEzr5HlNm
NFaPfXQ8LNOtYDWmK1yON/SuyBTY+LUhNo3i9kz2xNXMinI23NJak8pHArRjHX+L
Ls+1exmE8hS+KpybQvmNINVM9qA4UHvDcOmPJ3bokJHAdfTyVCf+fD48d7i8kAb+
ohY4OdNHzcPSy4Dcv+5R0Kg9hMepgfnoe2dXZ5jrhhiNNvjQU50=
=t1rI
-----END PGP SIGNATURE-----

--JlJsEFsx9RQyiX4C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
