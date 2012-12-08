From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad/dump.c: In mad_dump_mtu, don't set buf[0] to 0
Date: Fri, 7 Dec 2012 17:53:34 -0800
Message-ID: <20121207175334.4d3bde7cb09ce9fe4f01fd40@llnl.gov>
References: <50BF7DAA.9080902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50BF7DAA.9080902-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 05 Dec 2012 12:00:26 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> as this causes invalid MTUCap not to be displayed in output
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/dump.c b/src/dump.c
> index 24e671b..db1abc7 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -476,7 +476,6 @@ void mad_dump_mtu(char *buf, int bufsz, void *val, int valsz)
>  		break;
>  	default:
>  		snprintf(buf, bufsz, "?(%d)", mtu);
> -		buf[0] = 0;
>  	}
>  }
>  
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
