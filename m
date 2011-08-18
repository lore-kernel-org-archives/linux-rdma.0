From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad/dump.c: Allow 0 (extended speed active) in
 mad_dump_linkspeed
Date: Thu, 18 Aug 2011 11:01:06 -0700
Message-ID: <20110818110106.7f821260.weiny2@llnl.gov>
References: <4E498643.2070001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E498643.2070001-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 15 Aug 2011 13:49:07 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> for PortInfo:LinkSpeedEnabled
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/dump.c b/src/dump.c
> index 29fb742..00831a3 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -244,6 +244,9 @@ void mad_dump_linkspeed(char *buf, int bufsz, void *val, int valsz)
>  	int speed = *(int *)val;
>  
>  	switch (speed) {
> +	case 0:
> +		snprintf(buf, bufsz, "Extended speed");
> +		break;
>  	case 1:
>  		snprintf(buf, bufsz, "2.5 Gbps");
>  		break;


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
