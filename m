From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibportstate.c: Fix sizeof
Date: Fri, 10 Jun 2011 11:43:33 -0700
Message-ID: <20110610114333.cdc60945.weiny2@llnl.gov>
References: <4DEF71D3.30705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DEF71D3.30705-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 8 Jun 2011 05:57:55 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> It shouldn't be sizeof the pointer but this doesn't affect execution
> since this parameter is not used by mad_dump_portstates
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index d2ee58b..1f0f42e 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -126,7 +126,7 @@ static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
>  	char buf[2048];
>  	char val[64];
>  
> -	mad_dump_portstates(buf, sizeof buf, data, sizeof data);
> +	mad_dump_portstates(buf, sizeof buf, data, sizeof *data);
>  	mad_decode_field(data, IB_PORT_LID_F, val);
>  	mad_dump_field(IB_PORT_LID_F, buf + strlen(buf),
>  		       sizeof buf - strlen(buf), val);


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
