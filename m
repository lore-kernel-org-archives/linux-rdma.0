From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add support for
 PortInfo:McastPkeyTrapSuppressionEnabled
Date: Fri, 6 Nov 2009 20:02:17 +0200
Message-ID: <20091106180217.GP7192@me>
References: <20091106141034.GC19678@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091106141034.GC19678-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:10 Fri 06 Nov     , Hal Rosenstock wrote:
> 
> Per published MgtWG erratum RefID 4576

Please describe the change. Reference to private tracker's RefID number
is not enough.

Sasha

> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
> index b82b0d5..ed8fd71 100644
> --- a/libibmad/include/infiniband/mad.h
> +++ b/libibmad/include/infiniband/mad.h
> @@ -357,6 +357,7 @@ enum MAD_FIELDS {
>  	IB_PORT_QKEY_VIOL_F,
>  	IB_PORT_GUID_CAP_F,
>  	IB_PORT_CLIENT_REREG_F,
> +	IB_PORT_MCAST_PKEY_SUPR_ENAB_F,
>  	IB_PORT_SUBN_TIMEOUT_F,
>  	IB_PORT_RESP_TIME_VAL_F,
>  	IB_PORT_LOCAL_PHYS_ERR_F,
> diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
> index 98a0c60..c2f9585 100644
> --- a/libibmad/src/fields.c
> +++ b/libibmad/src/fields.c
> @@ -162,6 +162,7 @@ static const ib_field_t ib_mad_f[] = {
>  	{BITSOFFS(384, 16), "QkeyViolations", mad_dump_uint},
>  	{BITSOFFS(400, 8), "GuidCap", mad_dump_uint},
>  	{BITSOFFS(408, 1), "ClientReregister", mad_dump_uint},
> +	{BITSOFFS(409, 1), "McastPkeyTrapSuppressionEnabled", mad_dump_uint},
>  	{BITSOFFS(411, 5), "SubnetTimeout", mad_dump_uint},
>  	{BITSOFFS(419, 5), "RespTimeVal", mad_dump_uint},
>  	{BITSOFFS(424, 4), "LocalPhysErr", mad_dump_uint},
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
