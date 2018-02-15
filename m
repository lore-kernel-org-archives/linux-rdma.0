From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 11/14] RDMA/uverbs: Refactor the header
 validation logic
Date: Thu, 15 Feb 2018 16:26:50 +0200
Message-ID: <20180215142650.GI2197@mtr-leonro.local>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-12-leon@kernel.org>
 <20180214234635.GD1718@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9wW3yB/H9ZmnRBtb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214234635.GD1718-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9wW3yB/H9ZmnRBtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 14, 2018 at 04:46:35PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 14, 2018 at 02:38:41PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Move all header validation logic to be performed before SRCU read lock.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/uverbs_main.c | 90 ++++++++++++++++++-----------------
> >  1 file changed, 47 insertions(+), 43 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> > index f8f2182ab86b..e07326139ce9 100644
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -677,6 +677,42 @@ static ssize_t process_hdr(struct ib_uverbs_cmd_hdr *hdr,
> >  	return 0;
> >  }
> >
> > +static ssize_t verify_hdr(struct ib_uverbs_cmd_hdr *hdr,
> > +			  struct ib_uverbs_ex_cmd_hdr *ex_hdr,
> > +			  size_t count, bool extended)
> > +{
> > +	if (extended) {
> > +		count -= sizeof(*hdr) + sizeof(*ex_hdr);
> > +
> > +		if ((hdr->in_words + ex_hdr->provider_in_words) * 8 != count)
> > +			return -EINVAL;
> > +
> > +		if (ex_hdr->cmd_hdr_reserved)
> > +			return -EINVAL;
> > +
> > +		if (ex_hdr->response) {
> > +			if (!hdr->out_words && !ex_hdr->provider_out_words)
> > +				return -EINVAL;
> > +
> > +			if (!access_ok(VERIFY_WRITE,
> > +				       u64_to_user_ptr(ex_hdr->response),
> > +				       (hdr->out_words + ex_hdr->provider_out_words) * 8))
> > +				return -EFAULT;
> > +		} else {
> > +			if (hdr->out_words || ex_hdr->provider_out_words)
> > +				return -EINVAL;
> > +		}
> > +
> > +		return 0;
> > +	}
> > +
> > +	/* not extended command */
> > +	if (hdr->in_words * 4 != count)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
>
> I think you should squish this with the prior two patches

I preferred to split patches as much as possible in this area
to minimize chances of errors.

>
> Jason

--9wW3yB/H9ZmnRBtb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqFmKoACgkQ5GN7iDZy
WKcdmQ//cgnsGqpm0/N2t8/2jI6AuzIlB/xwrdEsRvh6I0pOdtk+aA8iZv6ivREK
Z/IEKcTBuBTl0ZVZIWBlx4++iB0KRgKwuaeSbZ0U6SMMvI5zrxcN8xRyEIa9YSAh
lbzRzob2SyRv7HsMZUJfjjw0okaGq0pozEmpLZW3cEBR+reIx7cdAAQFUAg0/i5h
7GPEB3QkISQQQqecC2Uv9L7RKDMwe0Mu3wdB5NvM56wPQqxPexdsUX5YHh+FB4QQ
RA5EMi4LAm3zMEdpzsEEkGmcf4i3pxtCo0lQT/rHnWVbP5houMS1wcUB12Z4cc5Y
w04neR4w6aujQFgLm4Lh1bL/hWOJ0FbpkCB3ZCvotVXW/uXYAQ/H/wnlnj2N6Md+
ugUZvoJBGbQut2HlRsFZm+C/9h7ta+2kvLc2zGaoQSHkflDQbU3WHAX5WDihYdm0
9rqLFysgfzEa84NIfBbpfLS2b2QJBiduRGUQOVfOAgP7rYgTw/P8/A6eJalwLLxu
6OVkZkMtrDPlepR/L5idk0vpoX2hREcwP4f+ATht1nP1sLV8yTj0X3bp1n7GrPyI
Ikfahs0dD+osV94kGl4EVvsyOYWoer+AyAtVK8OCZ6kqW4l0P2yH9+dgzHUlRV4K
/T6/w2tLKivzrtcrzjID+FdB4aMeZuifRP8/Wc9dZtmcntbK1NM=
=VAh5
-----END PGP SIGNATURE-----

--9wW3yB/H9ZmnRBtb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
