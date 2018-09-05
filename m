From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next v1 05/15] net/mlx5: Break encap/decap into two
 separated flow table creation flags
Date: Wed, 5 Sep 2018 08:10:25 +0300
Message-ID: <20180905051025.GC2977@mtr-leonro.mtl.com>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-6-leon@kernel.org>
 <20180904220242.GA3895@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904220242.GA3895@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 04, 2018 at 04:02:42PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 28, 2018 at 02:18:44PM +0300, Leon Romanovsky wrote:
> > From: Mark Bloch <markb@mellanox.com>
> >
> > Today we are able to attach encap and decap actions only to the FDB. In
> > preparation to enable those actions on the NIC flow tables, break the
> > single flag into two. Those flags control whatever a decap or encap
> > operations can be attached to the flow table created. For FDB, if
> > encapsulation is required, we set both of them.
> >
> > Signed-off-by: Mark Bloch <markb@mellanox.com>
> > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> > Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
> >  drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c           | 7 ++++---
> >  include/linux/mlx5/fs.h                                    | 3 ++-
> >  3 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > index f72b5c9dcfe9..ff21807a0c4b 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > @@ -529,7 +529,8 @@ static int esw_create_offloads_fast_fdb_table(struct mlx5_eswitch *esw)
> >  		esw_size >>= 1;
> >
> >  	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
> > -		flags |= MLX5_FLOW_TABLE_TUNNEL_EN;
> > +		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP |
> > +			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
> >
> >  	fdb = mlx5_create_auto_grouped_flow_table(root_ns, FDB_FAST_PATH,
> >  						  esw_size,
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> > index 9ae777e56529..1698f325a21e 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> > @@ -152,7 +152,8 @@ static int mlx5_cmd_create_flow_table(struct mlx5_core_dev *dev,
> >  				      struct mlx5_flow_table *next_ft,
> >  				      unsigned int *table_id, u32 flags)
> >  {
> > -	int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
> > +	int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
> > +	int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>
> Yuk, please don't use !!.
>
> 	bool en_decap = flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;

We need to provide en_encap and en_decap as an input to MLX5_SET(...)
which is passed to FW as 0 or 1. Boolean type is declared in C as int
and treated as zero for false and any other value for true, so we
can't pass "bool en_decap" without ensuring before that it is 1.

I'm applying this patch as is.

Thanks

>
> Jason

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj2VBAAoJEORje4g2clin0fkP/RjQnuXIOP0ZyG6QdrMc9QxD
PndfbmVW+66OkdmViiyxSyqFo1hxzvYh2PLrzKhReE4V8/ooB9YDNBinqTVDvHYC
ye9MiY+91cZ3XFSINKBVsGJGcBW1jwr7Sx4x/Nd54GsUvkRoAHwDpVPsUKG158Ku
OCW4SI5Xx36MdeAQyou/v0rE18FeCoDuss08F4CCnDKcPWhgBglM16nOHa1yiskR
ZQrgpS35ZafFcwHDZiQZkjyk/T1lVX4hwlH5V/V01HmnZJxYQcKum7rMmZPuk+AI
PFhREFkE5T8ZS5GG/aPz3KKEXx2qJv2IO9yCdmwmErxtsv9NPl/p11AgWggvQvuu
DXR3+77D/YckFHNcS3kSk+SSGK6r6Skbr7RiQgHL6Yobj1MW9yBPAGz675NaJuP5
R3eXLci2x9tU302os8u6w9Y15SiYNmsxa3cw+wjQeTrNHmUS4272OErUAYgcOa6c
i6PEaX+7eIb1Fj6wDxsdi0i9KunI9lA08mQ3ekxpQWVShHE9E+o6JVkFk+PXbFqm
zVs1N0zJ7Y3AYw8U4aVfth5wx/TjFNS2HIhvSBorR7knir+zgGsxPtsHJISyZ1ha
cBWLVQJqJ+QYXh25vPPYAAUdwZXP/ciTWMC9Wj17MybxKqclXdwdqi0GamsQJAen
uUHGOJco1RsEQEQ/rXV7
=MWEY
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
