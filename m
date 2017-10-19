From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Introduce Multi-Packet receive work queue
Date: Thu, 19 Oct 2017 08:06:56 +0300
Message-ID: <20171019050656.GU2106@mtr-leonro.local>
References: <20171017150113.8544-1-leon@kernel.org>
 <090b4257-daf4-4f90-555c-b048764d1cda@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="scYsJfBjqkrBfg1Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <090b4257-daf4-4f90-555c-b048764d1cda-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--scYsJfBjqkrBfg1Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 18, 2017 at 12:55:21PM +0300, Sagi Grimberg wrote:
>
> > A Multi-Packet receive WQ comes to improve performance and memory
> > footprint. It is comprised of work requests that can be consumed by
> > multiple packets. Buffers pointed by SGEs of each work request in a
> > multi packet WQ are divided into strides. Both buffer size and stride
> > size must be identical in all work requests of the same multi packet
> > WQ and are set during WQ creation.
> >
> > A single WR in a Multi-Packet WQ can generate multiple completions,
> > depends on the number of packets consumed. Each packet starts at the
> > beginning of a stride and is written in stride granularity.
> >
> > Here is an example of a work request comprised of 3 strides. Packet 1
> > is larger than a stride so it occupies 2 strides. Packet 2 fits in a
> > single stride. Each packet will generate its own completion.
> >
> > |         |         |[packet2]|
> > |    [packet1]      |         |
> > |_________|_________|_________|
> >   stride      stride     stride
> >   <--      work request     -->
> >
> > A Multi-Packet WQ reduces the number of needed post-recv operations
> > thus increasing performance: In the example above, a single post-recv
> > operation was performed instead of 2.
>
> Looks like a nice feature, would be nice if we could use it... The
> problem is that adding a different logic in case this feature exists is
> messy and difficult. Is there any way we can come up with a verbs API
> that will utilize this feature but hide the implementation details from
> the ULPs?

We will be more than happy to work with the community and update our
driver's code if needed, once the community will converge on the proper API.
Right now, we are exposing it through our DV interface.

Thanks

--scYsJfBjqkrBfg1Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnoMvAACgkQ5GN7iDZy
WKfh2g//S9pNoQmE6XCbT0BSBUWsEOK5EJQawo/RbwxC8FTCj1pX1an3ckFJlbqI
X1FVVVZTvfUYD58KHT5Rn+7Q/hGAvMcr9IkP9Vks5xAhBnXKmI6R4VVQY0sMsaTX
UuR4V2sBs0EVA3J8P1fJkX1JQEB/taUJt8O5tsialf6FLJcUhCRHI/TGOwfCtzNk
yItCk9mk1EFP8t+3VjUCp1T4BlNcw0539p65qzcwwHN7dUuwtwZwWcLtcrUB09Vd
78ZL3gGqP7upOVCLe8pI1GGNrvP1vqoW1ppDFNAaDab9kJBwzCWeuzODDge7iaia
TrxADCJormZdGODFFBHTh12FQGtLAY9aBvmEJarzDZAhGd7EgzktQnWa2RSLruyb
qf6V0QIzIXeMyyqI5drzf1DT39/YJzL00riIJJ/l20GoFrj9dK5cjkqB1Grrh+5i
/UQYh7V14zIC+DmVCmAJIffxzWdIqPxyTqTXrC0fjELaTw7kKE7II+OEYs94fCgg
6MOxoBTjErpDwqEWCd0YWMAusrSZCCM0rtCUEMAT3kfcyq1AmHSrEu2OkXvNVT97
Y1w4MSswfoyl/pm5NdAplHUyGgMTkjak0OqGP89tZaCtLnFMCEcsDOLYAV+hR2t2
dlIjpxD+Zlkc0m8lFWTVEFp8TSw4vW4bc7iHtMLEyzlMXoTCWJ4=
=4rZV
-----END PGP SIGNATURE-----

--scYsJfBjqkrBfg1Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
