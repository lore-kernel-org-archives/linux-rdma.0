From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad/fields.c: Update counter offsets for
 PortExtendedSpeedsCounters
Date: Mon, 30 Apr 2012 13:43:20 -0700
Message-ID: <20120430134320.ff1763c4.weiny2@llnl.gov>
References: <4F9ECB34.5020509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9ECB34.5020509-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 30 Apr 2012 13:26:12 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Per MgtWG RefID #4841
> 
> SyncHeaderErrorCounter, UnknownBlockCounter, and ErrorDetectionCounterLane<n>
> are now 16 bits rather than 8 bits.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.
Ira

> ---
> diff --git a/src/fields.c b/src/fields.c
> index 21b0fa6..06bc9f0 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -540,44 +540,44 @@ static const ib_field_t ib_mad_f[] = {
>  	 */
>  	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
>  	{64, 64, "CounterSelect", mad_dump_hex},
> -	{BITSOFFS(128, 8), "SyncHeaderErrorCounter", mad_dump_uint},
> -	{BITSOFFS(136, 8), "UnknownBlockCounter", mad_dump_uint},
> -	{BITSOFFS(144, 8), "ErrorDetectionCounterLane0", mad_dump_uint},
> -	{BITSOFFS(152, 8), "ErrorDetectionCounterLane1", mad_dump_uint},
> -	{BITSOFFS(160, 8), "ErrorDetectionCounterLane2", mad_dump_uint},
> -	{BITSOFFS(168, 8), "ErrorDetectionCounterLane3", mad_dump_uint},
> -	{BITSOFFS(176, 8), "ErrorDetectionCounterLane4", mad_dump_uint},
> -	{BITSOFFS(184, 8), "ErrorDetectionCounterLane5", mad_dump_uint},
> -	{BITSOFFS(192, 8), "ErrorDetectionCounterLane6", mad_dump_uint},
> -	{BITSOFFS(200, 8), "ErrorDetectionCounterLane7", mad_dump_uint},
> -	{BITSOFFS(208, 8), "ErrorDetectionCounterLane8", mad_dump_uint},
> -	{BITSOFFS(216, 8), "ErrorDetectionCounterLane9", mad_dump_uint},
> -	{BITSOFFS(224, 8), "ErrorDetectionCounterLane10", mad_dump_uint},
> -	{BITSOFFS(232, 8), "ErrorDetectionCounterLane11", mad_dump_uint},
> -	{256, 32, "FECCorrectableBlockCtrLane0", mad_dump_uint},
> -	{288, 32, "FECCorrectableBlockCtrLane1", mad_dump_uint},
> -	{320, 32, "FECCorrectableBlockCtrLane2", mad_dump_uint},
> -	{352, 32, "FECCorrectableBlockCtrLane3", mad_dump_uint},
> -	{384, 32, "FECCorrectableBlockCtrLane4", mad_dump_uint},
> -	{416, 32, "FECCorrectableBlockCtrLane5", mad_dump_uint},
> -	{448, 32, "FECCorrectableBlockCtrLane6", mad_dump_uint},
> -	{480, 32, "FECCorrectableBlockCtrLane7", mad_dump_uint},
> -	{512, 32, "FECCorrectableBlockCtrLane8", mad_dump_uint},
> -	{544, 32, "FECCorrectableBlockCtrLane9", mad_dump_uint},
> -	{580, 32, "FECCorrectableBlockCtrLane10", mad_dump_uint},
> -	{608, 32, "FECCorrectableBlockCtrLane11", mad_dump_uint},
> -	{640, 32, "FECUncorrectableBlockCtrLane0", mad_dump_uint},
> -	{672, 32, "FECUncorrectableBlockCtrLane1", mad_dump_uint},
> -	{704, 32, "FECUncorrectableBlockCtrLane2", mad_dump_uint},
> -	{736, 32, "FECUncorrectableBlockCtrLane3", mad_dump_uint},
> -	{768, 32, "FECUncorrectableBlockCtrLane4", mad_dump_uint},
> -	{800, 32, "FECUncorrectableBlockCtrLane5", mad_dump_uint},
> -	{832, 32, "FECUncorrectableBlockCtrLane6", mad_dump_uint},
> -	{864, 32, "FECUncorrectableBlockCtrLane7", mad_dump_uint},
> -	{896, 32, "FECUncorrectableBlockCtrLane8", mad_dump_uint},
> -	{928, 32, "FECUncorrectableBlockCtrLane9", mad_dump_uint},
> -	{960, 32, "FECUncorrectableBlockCtrLane10", mad_dump_uint},
> -	{992, 32, "FECUncorrectableBlockCtrLane11", mad_dump_uint},
> +	{BITSOFFS(128, 16), "SyncHeaderErrorCounter", mad_dump_uint},
> +	{BITSOFFS(144, 16), "UnknownBlockCounter", mad_dump_uint},
> +	{BITSOFFS(160, 16), "ErrorDetectionCounterLane0", mad_dump_uint},
> +	{BITSOFFS(176, 16), "ErrorDetectionCounterLane1", mad_dump_uint},
> +	{BITSOFFS(192, 16), "ErrorDetectionCounterLane2", mad_dump_uint},
> +	{BITSOFFS(208, 16), "ErrorDetectionCounterLane3", mad_dump_uint},
> +	{BITSOFFS(224, 16), "ErrorDetectionCounterLane4", mad_dump_uint},
> +	{BITSOFFS(240, 16), "ErrorDetectionCounterLane5", mad_dump_uint},
> +	{BITSOFFS(256, 16), "ErrorDetectionCounterLane6", mad_dump_uint},
> +	{BITSOFFS(272, 16), "ErrorDetectionCounterLane7", mad_dump_uint},
> +	{BITSOFFS(288, 16), "ErrorDetectionCounterLane8", mad_dump_uint},
> +	{BITSOFFS(304, 16), "ErrorDetectionCounterLane9", mad_dump_uint},
> +	{BITSOFFS(320, 16), "ErrorDetectionCounterLane10", mad_dump_uint},
> +	{BITSOFFS(336, 16), "ErrorDetectionCounterLane11", mad_dump_uint},
> +	{352, 32, "FECCorrectableBlockCtrLane0", mad_dump_uint},
> +	{384, 32, "FECCorrectableBlockCtrLane1", mad_dump_uint},
> +	{416, 32, "FECCorrectableBlockCtrLane2", mad_dump_uint},
> +	{448, 32, "FECCorrectableBlockCtrLane3", mad_dump_uint},
> +	{480, 32, "FECCorrectableBlockCtrLane4", mad_dump_uint},
> +	{512, 32, "FECCorrectableBlockCtrLane5", mad_dump_uint},
> +	{544, 32, "FECCorrectableBlockCtrLane6", mad_dump_uint},
> +	{576, 32, "FECCorrectableBlockCtrLane7", mad_dump_uint},
> +	{608, 32, "FECCorrectableBlockCtrLane8", mad_dump_uint},
> +	{640, 32, "FECCorrectableBlockCtrLane9", mad_dump_uint},
> +	{672, 32, "FECCorrectableBlockCtrLane10", mad_dump_uint},
> +	{704, 32, "FECCorrectableBlockCtrLane11", mad_dump_uint},
> +	{736, 32, "FECUncorrectableBlockCtrLane0", mad_dump_uint},
> +	{768, 32, "FECUncorrectableBlockCtrLane1", mad_dump_uint},
> +	{800, 32, "FECUncorrectableBlockCtrLane2", mad_dump_uint},
> +	{832, 32, "FECUncorrectableBlockCtrLane3", mad_dump_uint},
> +	{864, 32, "FECUncorrectableBlockCtrLane4", mad_dump_uint},
> +	{896, 32, "FECUncorrectableBlockCtrLane5", mad_dump_uint},
> +	{928, 32, "FECUncorrectableBlockCtrLane6", mad_dump_uint},
> +	{960, 32, "FECUncorrectableBlockCtrLane7", mad_dump_uint},
> +	{992, 32, "FECUncorrectableBlockCtrLane8", mad_dump_uint},
> +	{1024, 32, "FECUncorrectableBlockCtrLane9", mad_dump_uint},
> +	{1056, 32, "FECUncorrectableBlockCtrLane10", mad_dump_uint},
> +	{1088, 32, "FECUncorrectableBlockCtrLane11", mad_dump_uint},
>  	{0, 0},			/* IB_PESC_LAST_F */
>   	/*


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
