From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add support for SA NodeRecord
Date: Thu, 1 Dec 2011 11:10:29 -0800
Message-ID: <20111201111029.5133b7f8.weiny2@llnl.gov>
References: <4ED39438.8050109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED39438.8050109-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 28 Nov 2011 06:01:28 -0800
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 199b05f..09b334f 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -1208,6 +1208,24 @@ enum MAD_FIELDS {
>  	IB_CC_TIMESTAMP_F = IB_CC_TIMESTAMP_FIRST_F,
>  	IB_CC_TIMESTAMP_LAST_F,
>  
> +	/*
> +	 * Node Record
> +	 */

To be consistent we should add first and last here:
	IB_SA_NR_FIRST_F

> +	IB_SA_NR_LID_F,

And change this to
	IB_SA_NR_LID_F = IB_SA_NR_FIRST_F,

> +	IB_SA_NR_BASEVER_F,
> +	IB_SA_NR_CLASSVER_F,
> +	IB_SA_NR_TYPE_F,
> +	IB_SA_NR_NPORTS_F,
> +	IB_SA_NR_SYSTEM_GUID_F,
> +	IB_SA_NR_GUID_F,
> +	IB_SA_NR_PORT_GUID_F,
> +	IB_SA_NR_PARTITION_CAP_F,
> +	IB_SA_NR_DEVID_F,
> +	IB_SA_NR_REVISION_F,
> +	IB_SA_NR_LOCAL_PORT_F,
> +	IB_SA_NR_VENDORID_F,
> +	IB_SA_NR_NODEDESC_F,

	IB_SA_NR_LAST_F,

> +
>  	IB_FIELD_LAST_		/* must be last */
>  };
>  
> diff --git a/src/fields.c b/src/fields.c
> index c7402b7..68b9682 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -909,6 +909,22 @@ static const ib_field_t ib_mad_f[] = {
>  	 */
>  	{0, 32, "Timestamp", mad_dump_uint},

And add (not your bug)
	{0, 0},

Here to mark the last field of CC timestamp.

>  
> +	/* Node Record */
> +	{BITSOFFS(0, 16), "Lid", mad_dump_uint},
> +	{BITSOFFS(32, 8), "BaseVers", mad_dump_uint},
> +	{BITSOFFS(40, 8), "ClassVers", mad_dump_uint},
> +	{BITSOFFS(48, 8), "NodeType", mad_dump_node_type},
> +	{BITSOFFS(56, 8), "NumPorts", mad_dump_uint},
> +	{64, 64, "SystemGuid", mad_dump_hex},
> +	{128, 64, "Guid", mad_dump_hex},
> +	{192, 64, "PortGuid", mad_dump_hex},
> +	{BITSOFFS(256, 16), "PartCap", mad_dump_uint},
> +	{BITSOFFS(272, 16), "DevId", mad_dump_hex},
> +	{288, 32, "Revision", mad_dump_hex},
> +	{BITSOFFS(320, 8), "LocalPort", mad_dump_uint},
> +	{BITSOFFS(328, 24), "VendorId", mad_dump_hex},
> +	{352, 64 * 8, "NodeDesc", mad_dump_string},
> +

And just so we don't forget.
	{0, 0}, /* IB_SA_NR_LAST_F */

Here,

Applied with those changes thanks,
Ira

>  	{0, 0}			/* IB_FIELD_LAST_ */
>  
>  };


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
