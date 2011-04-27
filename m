From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibnetdiscover.c: Eliminate blank line
 when sysimgguid is 0
Date: Wed, 27 Apr 2011 14:55:41 -0700
Message-ID: <20110427145541.b81824de.weiny2@llnl.gov>
References: <4DB872FF.9050201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB872FF.9050201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 27 Apr 2011 12:48:15 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks,applied,
Ira

> ---
> diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
> index ffb5ea2..9768877 100644
> --- a/src/ibnetdiscover.c
> +++ b/src/ibnetdiscover.c
> @@ -215,7 +215,9 @@ void out_ids(ibnd_node_t * node, int group, char *chname, char *out_prefix)
>  			fprintf(f, " slot %d",
>  				node->ports[1]->remoteport->portnum);
>  	}
> -	fprintf(f, "\n");
> +	if (sysimgguid ||
> +	    (group && node->chassis && node->chassis->chassisnum))
> +		fprintf(f, "\n");
>  }
>  
>  uint64_t out_chassis(ibnd_fabric_t * fabric, unsigned char chassisnum)


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
