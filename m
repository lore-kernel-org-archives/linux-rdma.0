From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH 1/4] opensm: added function that dumps PathRecords
Date: Wed, 14 Apr 2010 16:16:06 -0600
Message-ID: <1271283366.4092.145.camel@sale659.sandia.gov>
References: <4BBDDA1E.7030102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BBDDA1E.7030102-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

On Thu, 2010-04-08 at 07:29 -0600, Yevgeny Kliteynik wrote:
> Dumping SL, MTU and Rate for all the
> non-switch-2-non-switch paths in the subnet.
> 
> PRs that are dumped:
> 
>   for every non-switch source port
>       for every non-switch target LID in the subnet
>           dump PR between source port and target LID
> 
> This way number of sources is equal to number of physical
> non-switch ports in the subnet, and only number of targets
> depends on LMC that is used.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---

[snip]

> +
>  /****f* OpenSM: MC Member Record Receiver/osm_mcmr_rcv_find_or_create_new_mgrp
>  * NAME
>  *	osm_mcmr_rcv_find_or_create_new_mgrp
> diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
> index 8aab548..83da258 100644
> --- a/opensm/opensm/osm_sa.c
> +++ b/opensm/opensm/osm_sa.c
> @@ -718,6 +718,87 @@ int osm_sa_db_file_dump(osm_opensm_t * p_osm)
>  	return res;
>  }
> 
> +typedef struct _path_parms {
> +	ib_net16_t pkey;
> +	uint8_t mtu;
> +	uint8_t rate;
> +	uint8_t sl;
> +	uint8_t pkt_life;
> +	boolean_t reversible;
> +} path_parms_t;
> +
> +extern ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
> +				    IN const osm_port_t * p_src_port,
> +				    IN const osm_port_t * p_dest_port,
> +				    IN const uint16_t dlid_ho,
> +				    OUT path_parms_t * p_parms);
> +
> +static void sa_dump_path_records(osm_opensm_t * p_osm, FILE * file)
> +{
> +	osm_port_t *p_src_port;
> +	osm_port_t *p_dest_port;
> +	osm_node_t *p_node;
> +	uint16_t dlid_ho;
> +	uint32_t vector_size;
> +	osm_physp_t *p_physp;
> +	path_parms_t path_parms;
> +	ib_api_status_t status;
> +
> +	vector_size = cl_ptr_vector_get_size(&p_osm->subn.port_lid_tbl);
> +	for (p_src_port = (osm_port_t *) cl_qmap_head(&p_osm->subn.port_guid_tbl);
> +	     p_src_port != (osm_port_t *) cl_qmap_end(&p_osm->subn.port_guid_tbl);
> +	     p_src_port = (osm_port_t *) cl_qmap_next(&p_src_port->map_item)) {
> +
> +		p_node = p_src_port->p_node;
> +		if (p_node->node_info.node_type == IB_NODE_TYPE_SWITCH)
> +			return;

-			return;
+			continue;

Otherwise we stop dumping at the first switch we encounter?

-- Jim



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
