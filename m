From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Thu, 19 Jan 2017 15:12:58 +0200
Message-ID: <20170119131258.GT32481@mtr-leonro.local>
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
        protocol="application/pgp-signature"; boundary="6t10AX3Id0Ai6Vje"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170116201218.GA7890-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6t10AX3Id0Ai6Vje
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

I agree with you, in theory it should work.

Let's hope that we will find such brave man who will
remove this line. The removal of this one line will
require from him to do extensive testing and reviewing
different code paths.

Thanks

>
> Jason

--6t10AX3Id0Ai6Vje
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliAu1oACgkQ5GN7iDZy
WKcvxA//QCX91+UiNTDJBajGd7FyGQnrelaLDuG1eVFmuRNx3+dH5XB33ZcANmNA
cmPbpnNIJXFX/SvorHD+enyAsfsxdaWecYaeuSiWwjbyGnwzu4+q5hfzItUFqBqx
qCuhP+D3KsUxu8PMnJ2fF0GngbLxk1uLRrNrPtPuNsxU8YJnEsCjQhTki8PNmjkS
mWcw1hT+eZP7tMv73U27H/hHZMpKNoGXbPQGnOBfS+ddx8yGcWhwbD/yzDfz4hXT
PA/wdWjk33VgIOPiGyJsWarLzihCZxQUpColhALg4ZlhR4SNSmM7jqS42AZs3aON
1xLoLJccXn/7C9epIYfKJQs/J6mBleEZsbO9tphkJkXWUCP+MwI1xhaVkHxv+7/A
XflxKNro6RWHoSakat1IhgH87OuCzjfT8OLUPKdSeTW9819kiaLUC2vQl8+Dx8Y0
o76g4fTIxlgIgTPjOS4ScGC0bztvGlaoOE+0S1Yd6Q6pJ0eVLLAhlOhVrQcggeU7
w+mz8hwrac1NGSrBeFePcTvQsTt+yp18T7rnOXxQISTKKBmqcxo4Z/6b+jHWh2dF
DInGrzk/bz3psQiLlZTA7Vamj0IPjrv667e6us+wvx0YZ+R+8yKjz8ATzIdc4o/S
AtqNOizbsR/OZ4vbbJ7u3RT/XulziUKcH7JNbTpDvzOq2fJFSvI=
=zrKW
-----END PGP SIGNATURE-----

--6t10AX3Id0Ai6Vje--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
