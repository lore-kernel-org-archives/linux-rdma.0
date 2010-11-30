From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/saquery.c: In
 dump_one_mcmember_record, fix flow label endian
Date: Tue, 30 Nov 2010 17:37:03 +0200
Message-ID: <20101130153703.GG11898@me>
References: <4CC823DC.4030605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CC823DC.4030605-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:06 Wed 27 Oct     , Hal Rosenstock wrote:
> Already in host endian
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied by hands (the patch was malformed). Thanks.

Sasha

> ---
> diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
> index cb4fc18..18c5a1c 100644
> --- a/infiniband-diags/src/saquery.c
> +++ b/infiniband-diags/src/saquery.c
> @@ -1,7 +1,7 @@
>   /*
>    * Copyright (c) 2006,2007 The Regents of the University of California.
>    * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>    * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>    * Copyright (c) 2009 HNR Consulting. All rights reserved.
>    *
> @@ -461,7 +461,7 @@ static void dump_one_mcmember_record(void *data)
>   	       inet_ntop(AF_INET6, mr->port_gid.raw, gid, sizeof(gid)),
>   	       cl_ntoh32(mr->qkey), cl_ntoh16(mr->mlid), mr->mtu, mr->tclass,
>   	       cl_ntoh16(mr->pkey), mr->rate, mr->pkt_life, sl,
> -	       cl_ntoh32(flow), hop, scope, join, mr->proxy_join);
> +	       flow, hop, scope, join, mr->proxy_join);
>   }
> 
>   static void dump_multicast_group_record(void *data)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
