From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 12/15] RDMA/mlx5: Add a new flow action verb
 - modify header
Date: Wed, 5 Sep 2018 21:02:41 +0300
Message-ID: <20180905180241.GU2977@mtr-leonro.mtl.com>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-13-leon@kernel.org>
 <20180904215823.GA3792@ziepe.ca>
 <20180905052044.GE2977@mtr-leonro.mtl.com>
 <20180905163842.GB21028@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iwjEIfU64POCkTAH"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905163842.GB21028@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--iwjEIfU64POCkTAH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 05, 2018 at 10:38:42AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 05, 2018 at 08:20:44AM +0300, Leon Romanovsky wrote:
> > On Tue, Sep 04, 2018 at 03:58:23PM -0600, Jason Gunthorpe wrote:
> > > On Tue, Aug 28, 2018 at 02:18:51PM +0300, Leon Romanovsky wrote:
> > >
> > > > +static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
> > > > +	struct ib_uverbs_file *file,
> > > > +	struct uverbs_attr_bundle *attrs)
> > > > +{
> > > > +	struct ib_uobject *uobj = uverbs_attr_get_uobject(
> > > > +		attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE);
> > > > +	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
> > > > +	enum mlx5_ib_uapi_flow_table_type ft_type;
> > > > +	struct ib_flow_action *action;
> > > > +	size_t num_actions;
> > > > +	void *in;
> > > > +	int len;
> > > > +	int ret;
> > > > +
> > > > +	if (!mlx5_ib_modify_header_supported(mdev))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	in = uverbs_attr_get_alloced_ptr(attrs,
> > > > +		MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
> > > > +	len = uverbs_attr_get_len(attrs,
> > > > +		MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM);
> > > > +
> > > > +	if (len % MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto))
> > > > +		return -EINVAL;
> > > > +
> > > > +	ret = uverbs_get_const(&ft_type, attrs,
> > > > +			       MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE);
> > > > +	if (ret)
> > > > +		return -EINVAL;
> > >
> > > This should be
> > >
> > > 	if (ret)
> > > 		return ret;
> > >
> > > Every call to uverbs_get_const is wrong in this same way..
> >
> > Right, from technical point of view uverbs_get_const can return EINVAL
> > only, and it is correct for now, but need to be changed to proper
> > "return ret".
>
> No, it can return ENOENT as well.

Ahh, right, the "|| !def_val" part.

Thanks

>
> Jason

--iwjEIfU64POCkTAH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbkBpBAAoJEORje4g2clinuYEP/3rGc+bTrP0Djvf29kz7FJKp
sxeAICxIfDrR0aY16HcMuxW4/8KbuPb0iwb43tcdf42aA6ApU7x02rEqCJeIA3dU
PBbOWD8aVylXkiNyxFjfjLjH6XkaEHWkXTbYRtRmCEqYBCEAWpmovHEAflaIzN7h
3jnxJanjqPZUc54b5jJ3BVjTqbaahPTyRLJXGbd9aKrSh4FlgLKP/hnRJJieMaxg
1zL4IhYBY8SyLP+zc9Gsu5S+2HEeCDafG0fJzH0UJjtDQH0RDjp0VnuNMAwUzDhN
0uw0RIFFvVH5NfsjhS6MqrqSQd0VIBs6HKNjBqJtR61Gho/h/ZeJWEbRMpPaNF4T
vLF1WUzLVbDP/WtobwzJB2E9yHxbkyJx6Bq32AcRB4juD9yWpH53NrjhdH64JTME
AZ6VdzA7WNgMKMZu8TRTAlCY+n7ejk9M/SbNqFYFyVzfwan1WMaCXfo2lOvvOT/K
cPbxeQsX/PUDbcBo+o6fafd3qcZ5t3/7z9RKGt4YP0VzITObE1eYjn4k84+E+ugK
Gx2KUWIm00ryHnwsnvpnAUOwIjk7Nru6gXTIY8H8PiS6RL9Jpxz2zU9ZH49XvETD
rmreY5H/iigaz6vd51jOR4srKw2GCrfnJ/KC64TmQX7b2T1TX6BnQHM8m/oFxCHm
uRky1houbDLjKW9CZryE
=FhLu
-----END PGP SIGNATURE-----

--iwjEIfU64POCkTAH--
