From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 6/7] RDMA/netlink: Protect device and port
 queries from device removal
Date: Wed, 3 Jan 2018 07:18:23 +0200
Message-ID: <20180103051823.GH10145@mtr-leonro.local>
References: <20180101110717.29686-1-leon@kernel.org>
 <20180101110717.29686-7-leon@kernel.org>
 <20180102211428.GA7831@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102211428.GA7831-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 02:14:28PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 01, 2018 at 01:07:16PM +0200, Leon Romanovsky wrote:
>
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 34c6cb2a0977..a0ea3dca479d 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -134,7 +134,10 @@ static int ib_device_check_mandatory(struct ib_device *device)
> >  	return 0;
> >  }
> >
> > -struct ib_device *__ib_device_get_by_index(u32 index)
> > +/*
> > + * Caller to this function should hold lists_rwsem
> > + */
>
> This comment isn't 100% right, the device mutex is also OK to hold, I
> dropped it.
>
> > @@ -141,36 +141,41 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  	struct ib_device *device;
> >  	struct sk_buff *msg;
> >  	u32 index;
> > -	int err;
> > +	int ret = -ENOMEM;
> >
> > -	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> > +	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> >  			  nldev_policy, extack);
>
> Initializing ret, then overwriting it with nlmsg_parse is silly, and
> leads to this bug:
>
> >  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >  	if (!msg)
> > -		return -ENOMEM;
> > +		goto err;
>
> Wrong return code after the change.
>
> I fixed it also dropped replacing err with ret since this is probably
> going to be backported.
>
> >  	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> >  	if (!rdma_is_port_valid(device, port))
> > -		return -EINVAL;
> > +		goto err;
>
> Same mistake again
>
> I also squashed this with the prior patch to make backporting simpler
>
>  RDMA/core: Provide locked variant of device name to index function
>
> And queued it to for-rc
>
> See below, please check my work.

Thanks for taking care.>

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpMZ58ACgkQ5GN7iDZy
WKdUVA//ZZAX5I1SpslKbLSkM0dW3Qbm6Tkp5LZRtsxuy3BOl26dnJrqXEI0bhLx
SWk/sMCVjyiscmX2Ux1aF04rIOl8Rd3Zeu30gMZMqqwq5QDqi7bWwsDzVUKT9oAe
edDvqWumiiJpgCxUPRepFxpKyfCUTq2m/bmYx4cHSUgxgYGi4WFd00Wa4qq6IWaO
6R+eO1HXuEX+DR0g153O3CiaYwF0MwkPRUwjX1ZRUBgNtl5VKftAeOMnVCOMmsHr
qt1NruAXl/TsmSslpkhnGt8YAj5RQwH6E9vweI7c6dbroUiOXtwXmM41uFdwLPJh
54B73afha9NXNqbvb9MCDACuNErN4bMobOX8wSKPMCseYjk92Ep3V9dE2yFSUHBV
dUvUi/FZMOl/dTZryEy0rFn+cjdTNiPUx8mOZ5sVfOU16lOdTBRq5au0BPDwxhVY
VwWjy7jHnzC0oNJItVkhUAa5F3nNv++l0Oqeuk7MWT1f46Z0N2EwxHUkyCbfINvS
QjIyyqU5ud4uaF2yZEeYGFq7XUVc3bUDydev+YzRt5bvRb383OUvMZ3ptA0CK86C
ak/JrW08NXecyvK46tbaw5sLJWYP6I6vaGsLFSKNX+98WnUELCU/a5z5wv3/5R3n
B8S2qsF6IDC/WvT7FBT3iCCQTFtUSMIIFmlwJX/D1Qm7WNB8dks=
=EI+W
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
