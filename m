From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Remove comp_mask checks from verbs.h
Date: Mon, 25 Dec 2017 16:32:41 +0200
Message-ID: <20171225143241.GJ2942@mtr-leonro.local>
References: <20171220231350.GA19130@ziepe.ca>
 <20171221054216.GF2942@mtr-leonro.local>
 <20171221162442.GC20015@ziepe.ca>
 <20171221171947.GK2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xtcA6s3naMKOsC7S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221171947.GK2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xtcA6s3naMKOsC7S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 21, 2017 at 07:19:47PM +0200, Leon Romanovsky wrote:
> On Thu, Dec 21, 2017 at 09:24:42AM -0700, Jason Gunthorpe wrote:
> > On Thu, Dec 21, 2017 at 07:42:16AM +0200, Leon Romanovsky wrote:
> >
> > > Both these functions are performing their checks of cq_attr->comp_mask,
> > > but return different errno. I think that it is perfect timing to start
> > > organize and unite our return errors. They should return the same errno.
> >
> > Bugs bugs everywhere.. This is going to be another patch. I would drop
> > the errno set into check_comp_mask and change all comp_mask users to
> > call it, and probably drop the _RESERVED uglyness too, but another
> > patch.
> >
> > > > In the case of ibv_queryrt_values_ex, there is no check in the function
> > > > op, which is an ABI mistake. So move the check there.
> > >
> > > ibv_queryrt_values_ex -> ibv_query_rt_values_ex
> >
> > K.. Are you going to collect the loose patches on the list? Can you
> > fix the typo when you grab this one :)
>
> No problem, I scheduled for myself time on Sunday to sync list,
> patchworks and rdma-core.

I fixed the patch and changed it to preserve the errno in mlx4 to be EINVAL.

Thanks

>
> Thanks
>
> >
> > Jason



--xtcA6s3naMKOsC7S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpBDAkACgkQ5GN7iDZy
WKdWaQ/+I2S2TX1vCPe80Sfw4Uwwlif9LS0vEfYN9TcG/x/z0EUkJ2nvq+jY/D7y
FwHimMxUUNvDOYpW/3nJJsAbGyvasgoK9tVyi7genwLtgeZoMNSOSbpOU4hWJtQS
drFByzjkLeJi6mMH3DWTpnvDjOJ4aFr5yBV1IagS3W9VE1RuG7FgI7S9n6rww7kd
h4qkw8zIN8RUo60mxiIqzq098PovSBrHF73XKreLFcFhVuBTDGKW7pVVlimwqhSf
1S0EjiEAYi3amEybGuAVp+oHVG+FDN6AQe9eMXMAv2GOZCBwEqygvlv2IJx/op4R
wYjn4LhrIQc+Yi6VH9+ipJ7vhUmLTFVqhke2NqQUQ3L2Y7wzckmbqVtDue35/JMW
7IT2KnIe7DLNUhGzWYemX12iOwRL7Q5zV71aI9s+GTr18WFCKfXPtbmhQsLKhIy6
XmFZZTCsIRKt6ddUyQgTLhPFpkW4bMjUmlZWSEVDCDAsbDPvKBj3Y+v4TeWPVCOd
07jSJbLv/j9pjFqvjhUfdLg4c1kVCOmd4zavN3lzUROkGG5fnLXLegQWEOQiTx/V
JuT2Om5KI1qBC+c00o9Y8SPj6UTV2/Sk2K70tkLQAAkPhqiNdGxU7elGl1+9YRy2
kKOA5xDjIdPeNi/0xTCO1sEMbKTIPuE5sAo31O1ipelDZu9YjIE=
=slcg
-----END PGP SIGNATURE-----

--xtcA6s3naMKOsC7S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
