From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/iblinkinfo.c: Limit some queries to
 switches
Date: Tue, 30 Nov 2010 17:41:28 +0200
Message-ID: <20101130154128.GH11898@me>
References: <4CC81F4B.4090600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CC81F4B.4090600-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:47 Wed 27 Oct     , Hal Rosenstock wrote:
> infiniband-diags/iblinkinfo.c: Limit certain queries to switches
> 
> iblinkinfo man page says:
> DESCRIPTION
>         iblinkinfo reports the link info for each port of each switch 
> active in
>         the IB fabric.
> 
> OPTIONS
>         -S <guid>
>                Output only the switch specified by <guid> (hex format)
> 
>         -D <direct_route>
>                Output only the switch specified by the direct route path.
> 
> Queries by DR path or GUID should (also) be limited to switches.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied by hands (the patch is malformed). Thanks.

Sasha

> ---
> diff --git a/infiniband-diags/src/iblinkinfo.c 
> b/infiniband-diags/src/iblinkinfo.c
> index d0c9b13..b129cb6 100644
> --- a/infiniband-diags/src/iblinkinfo.c
> +++ b/infiniband-diags/src/iblinkinfo.c
> @@ -2,6 +2,7 @@
>    * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>    * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
>    * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights 
> reserved.
> + * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
>    *
>    * This software is available to you under a choice of one of two
>    * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -387,7 +388,7 @@ int main(int argc, char **argv)
> 
>   	if (!all && guid_str) {
>   		ibnd_node_t *sw = ibnd_find_node_guid(fabric, guid);
> -		if (sw)
> +		if (sw && sw->type == IB_NODE_TYPE_SWITCH)
>   			print_switch(sw, NULL);
>   		else
>   			fprintf(stderr, "Failed to find switch: %s\n",
> @@ -402,7 +403,7 @@ int main(int argc, char **argv)
>   		mad_decode_field(ni, IB_NODE_GUID_F, &(guid));
> 
>   		sw = ibnd_find_node_guid(fabric, guid);
> -		if (sw)
> +		if (sw && sw->type == IB_NODE_TYPE_SWITCH)
>   			print_switch(sw, NULL);
>   		else
>   			fprintf(stderr, "Failed to find switch: %s\n", dr_path);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
