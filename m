From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: net/mlx5: Ethernet resource handling files
Date: Tue, 2 Jun 2015 13:02:14 +0300
Message-ID: <20150602100214.GA11247@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Amir Vadai,

The patch afb736e9330a: "net/mlx5: Ethernet resource handling files"
from May 28, 2015, leads to the following static checker warning:

	drivers/net/ethernet/mellanox/mlx5/core/en_flow_table.c:726 mlx5e_create_main_flow_table()
	error: potential null dereference 'g'.  (kcalloc returns null)

drivers/net/ethernet/mellanox/mlx5/core/en_flow_table.c
   719  static int mlx5e_create_main_flow_table(struct mlx5e_priv *priv)
   720  {
   721          struct mlx5_flow_table_group *g;
   722          u8 *dmac;
   723  
   724          g = kcalloc(9, sizeof(*g), GFP_KERNEL);

It should check for allocation failure.

   725  
   726          g[0].log_sz = 2;
   727          g[0].match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
   728          MLX5_SET_TO_ONES(fte_match_param, g[0].match_criteria,
   729                           outer_headers.ethertype);
   730          MLX5_SET_TO_ONES(fte_match_param, g[0].match_criteria,
   731                           outer_headers.ip_protocol);
   732  

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
