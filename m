From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Tue, 21 Nov 2017 08:05:04 +0200
Message-ID: <20171121060504.GO18825@mtr-leonro.local>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
 <20171120190434.GG29075@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2SKbs2OUdOmCpwVQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171120190434.GG29075-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2SKbs2OUdOmCpwVQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 20, 2017 at 12:04:34PM -0700, Jason Gunthorpe wrote:
> On Sun, Nov 19, 2017 at 09:21:08PM +0200, Yishai Hadas wrote:
> > +	if (mlx5wq_attr) {
> > +		if (mlx5wq_attr->comp_mask & ~(MLX5DV_WQ_INIT_ATTR_MASK_RESERVED - 1))
> > +			return -EINVAL;
>
> Please no. Check that only the bits this function actually supports
> are set and get rid of _RESERVED.

It is classical API mistake do not properly check validity of input parameters [1].

Thanks

[1] https://lwn.net/Articles/726917/

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--2SKbs2OUdOmCpwVQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloTwhAACgkQ5GN7iDZy
WKcK7A//daxsHPcvzN0qk3TSM8Ctgrtc8fOkdCVwwasSZO0dCZ4iFS4MI7qTCBds
/yW0dY6iG8H7Ie8rIHNmMFfEI6gjpb9tY4PKgxBHi5w0c23zD2iJ4LR9VzG6I8BN
d0ljjXf1q3fj+QjbVrcNIB0F1W5LYbloIXpCkCYgHu5MylZGLbhlV46mPxdXLgNF
HmT4uxnLxD+gtRnbkxv7timqUSvG5tQGOEGFa+B+pVI+zUM09w5zKX2fZAN43C6d
SNcV3UuZ1FE8614+6xjZfqiQhGU14JdRrzVlq8A1T39fUcBNdnc3/xYxGy69EmtS
NgvwApHZaInqNx/SM9bA5bkVAt8MRZHg944MnERfBLXPAOXbGDBfbqb3GpHE72Ry
VNUgdvjoESkUt2g9e2uB8AHHMPb1ja/fZPRMdE53Z5djeGp+uP7qvo0GdEjFKomK
Sp4J8MtwRBBGqrB8jtbB62wAiHLY+ptHGrncF7HnOK3qaxWjidUA6BFYXjJqsNJy
OTmjSrx4phHFGkukwzmyArre79O/6YAttc3rUf7mh/0QAeflaLohBcw+peYe46kz
DgbIr5Qnp3MscMM3Ylop/YyDNZGukzHx0ekDYcHcre0soBEGTvAxB3ltPe9FThPy
kE6spOgDCM/lWfGV//Hw48hIxkGS7/7IRnBNs7MTI/qwRDUW6u0=
=vuZo
-----END PGP SIGNATURE-----

--2SKbs2OUdOmCpwVQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
