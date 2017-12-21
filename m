From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH rdma-next 02/14] RDMA/core: Enforce requirement to
 hold lists_rwsem semaphore
Date: Thu, 21 Dec 2017 21:51:34 +0200
Message-ID: <20171221195134.GM2942@mtr-leonro.local>
References: <20171221181748.17126-1-leon@kernel.org>
 <20171221181748.17126-3-leon@kernel.org>
 <20171221191200.GE20015@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WTO+dqXoBrlfXqg9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221191200.GE20015-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WTO+dqXoBrlfXqg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 21, 2017 at 12:12:00PM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 21, 2017 at 08:17:36PM +0200, Leon Romanovsky wrote:
> > @@ -526,8 +531,8 @@ int ib_register_device(struct ib_device *device,
> >  		if (!add_client_context(device, client) && client->add)
> >  			client->add(device);
> >
> > -	device->index = __dev_new_index();
> >  	down_write(&lists_rwsem);
> > +	device->index = __dev_new_index();
>
> Isn't this hunk a for-rc bugfix??

Whole patch can go to for-rc.

This for-rc/for-next thing is new for me. In RDMA, we didn't bother ourselves too
much and sent everything to for-next.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WTO+dqXoBrlfXqg9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo8EMYACgkQ5GN7iDZy
WKfKfRAAxSJM2FWj8vBdAtOawMkwn2cpXbbhbIPxDwI/yGSluS36sfS0uhJHtVJn
kIrv/YajadpxWrC8D3hLlTJMdoWvfwiHYS+46CGpgCHjv2OY+zyt7S6ekuLqigWP
MocBJW4r8TVlgHaAer94j7NGCHDfDR7wF/r+MVF38psv/4SGbxzS8AAy4eAP2Cs9
ma8ex9pdpBa/gP+jagADXsVicmUrDkxPsnp5SnKBdioN4F5Sr2bum84W4Dtfywvx
mxg52Ku95KqouRZAXV6NdUqTjeB809ANRHbutJEEBcHUKWINRWGnC9vJk7DsZN6c
AQ/+uZt04QcuMJNxFFldEUJMReoT1nlYRLMNJonadg1Fefok3nGoTKNezb/Yd9Uw
nVXhXn192uHIKl06fxlQHWzrbRkNTIwOZLHSiHB6GZgzKYKHOHqN1POe5yWkSaFv
IiGncr8yVpLOfFfmuUE9dpybPee6IUBkartxvJzlQzKbX6qUB2Mdb0uM7TRFz69J
9Nki8HbLLDUCaRTlErq5z4MhDMxFuTpU8JlbYQnqKhfHjaxSUNZSaQL/1GcqVx5L
yJqQFHZPOu8if16v4LVWN2HKIk6EZF93sDWrTWUpsR1C0rtOLK+lfZDt0wBWkJ64
q2MRhFF5OjVjbQ2Fh51ZkRy35XQwuV1+DhIZtnL7f9Ni7iKNCFw=
=RtcK
-----END PGP SIGNATURE-----

--WTO+dqXoBrlfXqg9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
