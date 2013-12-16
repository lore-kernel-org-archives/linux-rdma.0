From: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] ssa_smdb.[c h]: remove 'osm_header.h' dependency from
 'ssa_smdb.h'
Date: Mon, 16 Dec 2013 15:44:17 +0200
Message-ID: <52AF03B1.5060407@dev.mellanox.co.il>
References: <52AF0075.3070709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52AF0075.3070709-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sasha Kotchubievsky <sashakot-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please ignore.

On 12/16/2013 3:30 PM, Ilya Nelkenbaum wrote:
> 
> Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since version 1:
>  - all method declarations were removed from 'ssa_smdb.h'
>  - argument types were changed back from 'void*' to
>    specific types
> 
>  include/infiniband/ssa_smdb.h |   26 --------------------------
>  plugin/src/ssa_extract.c      |   16 ++++++++++++++++
>  plugin/src/ssa_smdb.c         |    1 +
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/include/infiniband/ssa_smdb.h b/include/infiniband/ssa_smdb.h
> index 66fae67..016c99f 100644
> --- a/include/infiniband/ssa_smdb.h
> +++ b/include/infiniband/ssa_smdb.h
> @@ -34,7 +34,6 @@
>  #ifndef _SSA_SMDB_H_
>  #define _SSA_SMDB_H_
>  
> -#include <infiniband/osm_headers.h>
>  #include <infiniband/ssa_db.h>
>  #include <infiniband/umad_sm.h>
>  
> @@ -204,30 +203,5 @@ struct ep_lft_block_tbl_rec {
>  struct ssa_db *ssa_db_smdb_init(uint64_t data_rec_cnt[SSA_TABLE_ID_MAX]);
>  
>  void ssa_db_smdb_destroy(struct ssa_db * p_smdb);
> -
> -/**********************SUBNET OPTS records*******************************/
> -void ep_subnet_opts_tbl_rec_init(osm_subn_t *p_subn,
> -				 struct ep_subnet_opts_tbl_rec * p_rec);
> -
> -/**********************GUID to LID records*******************************/
> -void ep_guid_to_lid_tbl_rec_init(osm_port_t *p_port,
> -				 struct ep_guid_to_lid_tbl_rec * p_rec);
> -
> -/**********************NODE records**************************************/
> -void ep_node_tbl_rec_init(osm_node_t *p_node, struct ep_node_tbl_rec * p_rec);
> -
> -/**********************LINK records**************************************/
> -void ep_link_tbl_rec_init(osm_physp_t *p_physp, struct ep_link_tbl_rec * p_rec);
> -
> -/**********************PORT records**************************************/
> -void ep_port_tbl_rec_init(osm_physp_t *p_physp, struct ep_port_tbl_rec * p_rec);
> -
> -/********************** LFT Block records*******************************/
> -void ep_lft_block_tbl_rec_init(osm_switch_t *p_sw, uint16_t lid, uint16_t block,
> -			       struct ep_lft_block_tbl_rec * p_rec);
> -
> -/********************** LFT Top records*********************************/
> -void ep_lft_top_tbl_rec_init(uint16_t lid, uint16_t lft_top,
> -			     struct ep_lft_top_tbl_rec *p_rec);
>  END_C_DECLS
>  #endif				/* _SSA_SMDB_H_ */
> diff --git a/plugin/src/ssa_extract.c b/plugin/src/ssa_extract.c
> index c8847eb..0587230 100644
> --- a/plugin/src/ssa_extract.c
> +++ b/plugin/src/ssa_extract.c
> @@ -54,6 +54,22 @@ extern struct ssa_database *ssa_db;
>  extern int first;
>  extern int smdb_deltas;
>  
> +extern void ep_subnet_opts_tbl_rec_init(osm_subn_t * p_subn,
> +					struct ep_subnet_opts_tbl_rec * p_rec);
> +extern void ep_guid_to_lid_tbl_rec_init(osm_port_t * p_port,
> +					struct ep_guid_to_lid_tbl_rec * p_rec);
> +extern void ep_node_tbl_rec_init(osm_node_t * p_node,
> +				 struct ep_node_tbl_rec * p_rec);
> +extern void ep_link_tbl_rec_init(osm_physp_t * p_physp,
> +				 struct ep_link_tbl_rec * p_rec);
> +extern void ep_port_tbl_rec_init(osm_physp_t * p_physp,
> +				 struct ep_port_tbl_rec * p_rec);
> +extern void ep_lft_block_tbl_rec_init(osm_switch_t * p_sw, uint16_t lid,
> +				      uint16_t block,
> +				      struct ep_lft_block_tbl_rec * p_rec);
> +extern void ep_lft_top_tbl_rec_init(uint16_t lid, uint16_t lft_top,
> +				    struct ep_lft_top_tbl_rec * p_rec);
> +
>  /** =========================================================================
>   */
>  struct ssa_db_extract *ssa_db_extract(osm_opensm_t *p_osm)
> diff --git a/plugin/src/ssa_smdb.c b/plugin/src/ssa_smdb.c
> index ed0a53e..a6e75a1 100644
> --- a/plugin/src/ssa_smdb.c
> +++ b/plugin/src/ssa_smdb.c
> @@ -32,6 +32,7 @@
>   */
>  
>  #include <infiniband/ssa_smdb.h>
> +#include <infiniband/osm_headers.h>
>  #include <asm/byteorder.h>
>  
>  static const struct db_table_def def_tbl[] = {
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
