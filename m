From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: fix insert
 of invalid lid 0xFFFF into lid_port hash_table
Date: Sun, 12 Jan 2014 15:34:03 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04A93D22@CRSMSX101.amr.corp.intel.com>
References: <52C18853.8080107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52C18853.8080107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Good catch some comments below.

> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Monday, December 30, 2013 6:51 AM
> To: Ira Weiny
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Dan Ben-Yosef
> Subject: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: fix insert of invalid
> lid 0xFFFF into lid_port hash_table
> 
> From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibnetdisc/src/ibnetdisc.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c index
> 9d120dd..121fe35 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -647,11 +647,13 @@ void add_to_portlid_hash(ibnd_port_t * port,
> GHashTable *htable)
>  	uint16_t base_lid = port->base_lid;
>  	uint16_t lid_mask = ((1 << port->lmc) -1);
>  	uint16_t lid = 0;
> -
> -	/* We add the port for all lids
> -	 * so it is easier to find any "random" lid specified */
> -	for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
> -		g_hash_table_insert(htable, GINT_TO_POINTER(lid), port);
> +	/* 0 < valid lid <= 0xbfff */
> +	if (base_lid > 0 && base_lid <= 0xbfff) {

Shouldn't we check the "max LID" (based on LMC) here to make sure they are all vaild?

Ira

> +		/* We add the port for all lids
> +		 * so it is easier to find any "random" lid specified */
> +		for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
> +			g_hash_table_insert(htable, GINT_TO_POINTER(lid),
> port);
> +		}
>  	}
>  }
> 
> --
> 1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
