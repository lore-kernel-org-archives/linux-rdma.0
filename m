From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 12/15] RDMA/mlx5: Add a new flow action verb
 - modify header
Date: Wed, 5 Sep 2018 08:20:44 +0300
Message-ID: <20180905052044.GE2977@mtr-leonro.mtl.com>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-13-leon@kernel.org>
 <20180904215823.GA3792@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904215823.GA3792@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 04, 2018 at 03:58:23PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 28, 2018 at 02:18:51PM +0300, Leon Romanovsky wrote:
>
> > +static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
> > +	struct ib_uverbs_file *file,
> > +	struct uverbs_attr_bundle *attrs)
> > +{
> > +	struct ib_uobject *uobj = uverbs_attr_get_uobject(
> > +		attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE);
> > +	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
> > +	enum mlx5_ib_uapi_flow_table_type ft_type;
> > +	struct ib_flow_action *action;
> > +	size_t num_actions;
> > +	void *in;
> > +	int len;
> > +	int ret;
> > +
> > +	if (!mlx5_ib_modify_header_supported(mdev))
> > +		return -EOPNOTSUPP;
> > +
> > +	in = uverbs_attr_get_alloced_ptr(attrs,
> > +		MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
> > +	len = uverbs_attr_get_len(attrs,
> > +		MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
> > +
> > +	if (len % MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto))
> > +		return -EINVAL;
> > +
> > +	ret = uverbs_get_const(&ft_type, attrs,
> > +			       MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE);
> > +	if (ret)
> > +		return -EINVAL;
>
> This should be
>
> 	if (ret)
> 		return ret;
>
> Every call to uverbs_get_const is wrong in this same way..

Right, from technical point of view uverbs_get_const can return EINVAL
only, and it is correct for now, but need to be changed to proper
"return ret".

>
> I can probably fix it if this is the only thing though..
>

Thanks, I appreciate it.

> Jason

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj2erAAoJEORje4g2clin+4YP/ip5DrzB0bIaLLMmX5dx1QFL
3nnuPQp1KN77ujiFZ3aqVZ3HhAVWX0EQlnuVadMMQbACNyEd1yW7ZAv8pN0pEtjK
cVCKGviUbqJTK2yOmwz+6IZP/dH5EQYh95QFLc42sk86LUZ6uMeO7vypP5mlZ2Vd
knb6UEVppTG/HYMYMhy55mTUUgJvCIsXtqBAHsq5qGkJbLMo14bkJlgrMShtFBmm
tdtimjtT9Imx1E5fMCClF1kEgdCwE2OmijzgPwhMXwIYBSpxyLZ9/R2WbFoCegoe
MXT3xZyQ/tIWJJn7F8zAckRkW9hwEC1AdhUcr3hZNeoxXFnx+vmdwEHYoGllyxbu
yOtssch6mlLCIrO3F2yDRBigmIdNdsjhPVX+nBxdWT8k+lzdsiRVSBv0DUNlzVbH
DPF2Jq3Ib9RxJEPU89jE18Q1Cay0to3dsVnAxJ3icVqaJD+8wa6nBwpv9zAYG5F6
F+cIvfHsC6TxTbMjfVJ2v8208/g1VPJZoiDfmW5fpNrg87JuqvRYZKMoAib6c9EG
xBtVujuZUm+W/bz9xLFb3rK2vmyMJH7qJxig/9ssyG82/FHsUTpNsv21h1is4WD3
vIZhUdlJC/63xHvKlf5WI9SmkDS9FwYWejDY5wFy4kMMR/6/3GT6/ba6v2suWB9u
Y7oAEV9dGmBfcZpx1bVV
=lgyA
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
