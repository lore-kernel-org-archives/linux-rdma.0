From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH TRIVIAL libibmad] fields.c: Fix commentary typo
Date: Mon, 19 Jan 2015 22:27:10 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC05B97@CRSMSX101.amr.corp.intel.com>
References: <54B41BA9.4050005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B41BA9.4050005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Monday, January 12, 2015 11:08 AM
> To: Weiny, Ira
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> Subject: [PATCH TRIVIAL libibmad] fields.c: Fix commentary typo
> 
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira
 

> ---
> diff --git a/src/fields.c b/src/fields.c index 33a6364..9965811 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -835,7 +835,7 @@ static const ib_field_t ib_mad_f[] = {
>  	{BITSOFFS(16, 16), "ThresholdEventCounter", mad_dump_uint},
>  	{BITSOFFS(32, 16), "ThresholdCongestionEventMap", mad_dump_hex},
>  	/* XXX: Q3/2010 errata lists offset 48, but that means field is not
> -	 * world aligned.  Assume will be aligned to offset 64 later.
> +	 * word aligned.  Assume will be aligned to offset 64 later.
>  	 */
>  	{BITSOFFS(64, 32), "CurrentTimeStamp", mad_dump_uint},
>  	{0, 0},			/* IB_CC_CONGESTION_LOG_CA_LAST_F */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
