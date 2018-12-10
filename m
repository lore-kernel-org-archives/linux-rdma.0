From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 08/10] net/mlx5: Support extended destination
 format in flow steering command
Date: Mon, 10 Dec 2018 16:16:20 +0000
Message-ID: <20181210161614.GG3459@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
 <20181210030442.7543-9-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-9-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <9F6E58AC58DF0D438B98ECFD51BB774B@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Eli Britstein <elibr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 09, 2018 at 07:04:40PM -0800, Saeed Mahameed wrote:
> From: Eli Britstein <elibr@mellanox.com>
>=20
> Update the flow steering command formatting according to the extended
> destination API.
> Note that the FW dictates that multi destination FTEs that involve at
> least one encap must use the extended destination format, while single
> destination ones must use the legacy format.
> Using extended destination format requires FW support. Check for its
> capabilities and return error if not supported.
>=20
> Signed-off-by: Eli Britstein <elibr@mellanox.com>
> Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>  .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 80 +++++++++++++++++--
>  include/linux/mlx5/fs.h                       |  2 +
>  2 files changed, 75 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/fs_cmd.c
> index dda63dedaa49..a18fbea7a931 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> @@ -308,22 +308,68 @@ static int mlx5_cmd_destroy_flow_group(struct mlx5_=
core_dev *dev,
>  	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
>  }
> =20
> +static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
> +				  struct fs_fte *fte, bool *extended_dest)
> +{
> +	int fw_log_max_fdb_encap_uplink =3D
> +		MLX5_CAP_ESW(dev, log_max_fdb_encap_uplink);
> +	int num_fwd_destinations =3D 0;
> +	struct mlx5_flow_rule *dst;
> +	int num_encap =3D 0;
> +
> +	*extended_dest =3D false;
> +	if (!(fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST))
> +		return 0;
> +
> +	list_for_each_entry(dst, &fte->node.children, node.list) {
> +		if (dst->dest_attr.type =3D=3D MLX5_FLOW_DESTINATION_TYPE_COUNTER)
> +			continue;
> +		if (dst->dest_attr.type =3D=3D MLX5_FLOW_DESTINATION_TYPE_VPORT &&
> +		    dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
> +			num_encap++;
> +		num_fwd_destinations++;
> +	}
> +	if (num_fwd_destinations > 1 && num_encap > 0)
> +		*extended_dest =3D true;
> +
> +	if (*extended_dest && !fw_log_max_fdb_encap_uplink) {
> +		pr_warn("FW does not support extended destination");
> +		return -EOPNOTSUPP;
> +	}
> +	if (num_encap > (1 << fw_log_max_fdb_encap_uplink)) {
> +		pr_warn("FW does not support more than %d encaps",
> +			1 << fw_log_max_fdb_encap_uplink);

Drivers should avoid using pr_ if they have an struct device, in this
case &dev->pdev->dev ..

This is probably a comment for the entire core code directory I
suppose?

Jason
