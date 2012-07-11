From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/perfquery.c: Fix compile warning
Date: Wed, 11 Jul 2012 10:10:42 -0700
Message-ID: <20120711101042.7d110a76137554bd5d75bea6@llnl.gov>
References: <4FFD8831.4000202@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FFD8831.4000202-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 11 Jul 2012 10:05:37 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> src/perfquery.c: In function main:
> src/perfquery.c:662: warning: integer constant is too large for long type
>    
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.
Ira

> ---
> diff --git a/src/perfquery.c b/src/perfquery.c
> index e85b14e..32dd98f 100644
> --- a/src/perfquery.c
> +++ b/src/perfquery.c
> @@ -659,7 +659,7 @@ int main(int argc, char **argv)
>  	int mgmt_classes[2] = { IB_SA_CLASS, IB_PERFORMANCE_CLASS };
>  	ib_portid_t portid = { 0 };
>  	int mask = 0xffff;
> -	uint64_t ext_mask = 0xffffffffffffffff;
> +	uint64_t ext_mask = 0xffffffffffffffffULL;
>  	uint16_t cap_mask;
>  	int all_ports_loop = 0;
>  	int node_type, num_ports = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
