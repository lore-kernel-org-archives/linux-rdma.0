From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] ibnetdisc: Fix build for windows
Date: Fri, 5 Aug 2011 17:19:38 -0700
Message-ID: <20110805171938.155e0d58.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373137025A7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373137025A7-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 5 Aug 2011 13:44:39 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Fix a couple of compile errors that occur building on windows.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks applied,
Ira

> ---
>  libibnetdisc/src/chassis.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/libibnetdisc/src/chassis.c b/libibnetdisc/src/chassis.c
> index 3d90034..5726f8e 100644
> --- a/libibnetdisc/src/chassis.c
> +++ b/libibnetdisc/src/chassis.c
> @@ -688,7 +688,7 @@ static int fill_mellanox_chassis_record(ibnd_node_t * node)
>  	}
>  
>  	/* set Chip number (node index) */
> -	node->ch_anafanum = atoi(&node_index[1]);
> +	node->ch_anafanum = (unsigned char) atoi(&node_index[1]);
>  	if(node->ch_anafanum != 1){
>  		IBND_DEBUG("Unexpected Chip number:%d \n",node->ch_anafanum);
>  	}
> @@ -707,7 +707,7 @@ static int fill_mellanox_chassis_record(ibnd_node_t * node)
>  	/* The switch will be displayed under Line or Spine and not under Chassis switches */
>  	node->ch_found = 1;
>  
> -	node->ch_slotnum = atoi(&system_slot_name[1]);
> +	node->ch_slotnum = (unsigned char) atoi(&system_slot_name[1]);
>  	if((node->ch_slot == LINE_CS && (node->ch_slotnum >  (LINES_MAX_NUM + 1))) ||
>  	   (node->ch_slot == SPINE_CS && (node->ch_slotnum > (SPINES_MAX_NUM + 1)))){
>  		IBND_ERROR("fill_mellanox_chassis_record: invalid slot number:%d \n",node->ch_slotnum);
> @@ -1242,13 +1242,12 @@ int group_nodes(ibnd_fabric_t * fabric)
>  	ibnd_chassis_t *chassis;
>  	ibnd_chassis_t *ch, *ch_next;
>  	chassis_scan_t chassis_scan;
> +	int vendor_id;
>  
>  	chassis_scan.first_chassis = NULL;
>  	chassis_scan.current_chassis = NULL;
>  	chassis_scan.last_chassis = NULL;
>  
> -	int vendor_id;
> -
>  	/* first pass on switches and build for every Voltaire node */
>  	/* an appropriate chassis record (slotnum and position) */
>  	/* according to internal connectivity */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
