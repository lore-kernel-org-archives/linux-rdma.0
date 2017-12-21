From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Remove comp_mask checks from verbs.h
Date: Thu, 21 Dec 2017 19:19:47 +0200
Message-ID: <20171221171947.GK2942@mtr-leonro.local>
References: <20171220231350.GA19130@ziepe.ca>
 <20171221054216.GF2942@mtr-leonro.local>
 <20171221162442.GC20015@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hk/xWDG3xnLTY+FR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221162442.GC20015-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hk/xWDG3xnLTY+FR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 21, 2017 at 09:24:42AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 21, 2017 at 07:42:16AM +0200, Leon Romanovsky wrote:
>
> > Both these functions are performing their checks of cq_attr->comp_mask,
> > but return different errno. I think that it is perfect timing to start
> > organize and unite our return errors. They should return the same errno.
>
> Bugs bugs everywhere.. This is going to be another patch. I would drop
> the errno set into check_comp_mask and change all comp_mask users to
> call it, and probably drop the _RESERVED uglyness too, but another
> patch.
>
> > > In the case of ibv_queryrt_values_ex, there is no check in the function
> > > op, which is an ABI mistake. So move the check there.
> >
> > ibv_queryrt_values_ex -> ibv_query_rt_values_ex
>
> K.. Are you going to collect the loose patches on the list? Can you
> fix the typo when you grab this one :)

No problem, I scheduled for myself time on Sunday to sync list,
patchworks and rdma-core.

Thanks

>
> Jason

--hk/xWDG3xnLTY+FR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo77TIACgkQ5GN7iDZy
WKebWA//RarJfKUz1oOCpYufkqc/FIqUVAgF2jI7J1pgQJHpz938+xNXuK0XqLpK
exicfek4X9tRsr4elZ8zSACi44vy18KmPEBJ5Yp7kDXjcz3uWqD5R8u513w6JyWH
yCNhtkxWfBmniu6GEXkJRT+rcPYSqsVCs4XPUDY3gLjYvqnQcjdiO7EK8zKao+aI
sefbgvBOo6vuMCNArelXYXnGLwi1Ee8bEFYn1OeQ5m1SvvP0YCzVP33iIyNLYbtu
cLfKqkVyRmlKIHXrwY4nzdHXVbK6npEBLBe1q70XVNj1M6oaAzJDVaHQ0y3Xt/ex
oneLdoDh2rZU9iNdWxr3Dg8Usje4/6qc1WvmT0HtmLr/l3nXJeQdhx6lqYcUjGcu
PNPeO4pz+1vJ+XbU9BcO5D7yNasZ6r4vJjS3tSrXI9tTImZ4uPuEALeg1ZkDqZM7
bvNUeRC0jSIeYgrLK+Qou12zlax6XLmNaZofrdR8Gh85/iZ5Asa7eYlIMhG4JYYv
ALuYs7ogaKhDNmEAsfA2rq05l+0BtZWCLhtJ+ifXrXfvJQY4lHUG9ZyGEYacNIdl
408jEE323foRYFyvHoIp7uGN2uIJ3vPolqJZ11SE+oBzyCg3s+JGitMzRPF3PgDJ
VLoS8ZnTfL2PHsjqn2rr77AXB0q6ty4IKp23rYtp3vIUulVCp1M=
=aQlP
-----END PGP SIGNATURE-----

--hk/xWDG3xnLTY+FR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
