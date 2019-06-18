From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport metadata
 matching if firmware supports it
Date: Tue, 18 Jun 2019 10:35:38 +0000
Message-ID: <20190618103535.GF4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-13-saeedm@mellanox.com>
 <AM0PR05MB4866AA7738F3DE1D3CF47FFBD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AM0PR05MB4866AA7738F3DE1D3CF47FFBD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
Content-ID: <953718B094FA504982271FD642327A5D@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jianbo Liu <jianbol@mellanox.com>, Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 10:24:49AM +0000, Parav Pandit wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Saeed Mahameed
> > Sent: Tuesday, June 18, 2019 12:54 AM
> > To: Saeed Mahameed <saeedm@mellanox.com>; Leon Romanovsky
> > <leonro@mellanox.com>
> > Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Jianbo Liu
> > <jianbol@mellanox.com>; Roi Dayan <roid@mellanox.com>; Mark Bloch
> > <markb@mellanox.com>
> > Subject: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport metad=
ata
> > matching if firmware supports it
> >
> > From: Jianbo Liu <jianbol@mellanox.com>
> >
> > As the ingress ACL rules save vhca id and vport number to packet's meta=
data
> > REG_C_0, and the metadata matching for the rules in both fast path and =
slow
> > path are all added, enable this feature if supported.
> >
> > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > index 363517e29d4c..5124219a31de 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > @@ -1906,12 +1906,25 @@ static int
> > esw_vport_ingress_common_config(struct mlx5_eswitch *esw,
> >  	return err;
> >  }
> >
> > +static int esw_check_vport_match_metadata_supported(struct mlx5_eswitc=
h
> > +*esw) {
> > +	return (MLX5_CAP_ESW_FLOWTABLE(esw->dev,
> > fdb_to_vport_reg_c_id) &
> > +		MLX5_FDB_TO_VPORT_REG_C_0) &&
> > +	       MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
> > +	       MLX5_CAP_ESW(esw->dev, esw_uplink_ingress_acl) &&
> > +	       !mlx5_core_is_ecpf_esw_manager(esw->dev) &&
> > +	       !mlx5_ecpf_vport_exists(esw->dev);
> > +}
> > +
> struct mlx5_eswitch* should be const.
> return type should be bool.

It is also completely indigestible and should be break into peaces to
make it readable.

Thanks
