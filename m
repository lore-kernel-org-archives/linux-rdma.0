From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: In validate_mad, validate CM method and attribute
Date: Thu, 12 Nov 2015 13:13:39 -0500
Message-ID: <20151112181339.GA16488@phlsvsds.ph.intel.com>
References: <56447CA2.1070802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56447CA2.1070802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2015 at 01:48:50PM +0200, Hal Rosenstock wrote:
> 
> Receipt of CM MAD with response method for other than ClassPortInfo
> attribute is invalid.
> 
> CM attributes other than ClassPortInfo use send method only
> and GetResp is valid for ClassPortInfo attribute.
> Note also that the CM ClassPortInfo is not currently supported.
> 
> The SRP initiator does not maintain a timeout policy for CM connect
> requests relies on the CM layer to do that. The result was that
> the SRP initiator hung as the connect request never completed.
> 
> A new SRP target has been observed to respond to Send CM REQ
> with GetResp of CM REQ with bad status. This is non conformant
> with IBA spec but exposes a vulnerability in the current MAD/CM
> code which will respond to the incoming GetResp of CM REQ as if
> it was a valid incoming Send of CM REQ rather than tossing
> this on the floor. It also causes the MAD layer not to
> retransmit the original REQ even though it has not received a REP.
> 
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c |    8 ++++++++
>  include/rdma/ib_mad.h         |    2 ++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 8d8af7a..e2d425f 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -1811,6 +1811,14 @@ static int validate_mad(const struct ib_mad_hdr *mad_hdr,
>  		if (qp_num == 0)
>  			valid = 1;
>  	} else {
> +		/* CM attributes other than ClassPortInfo only use Send method */
> +		if (mad_hdr->mgmt_class == IB_MGMT_CLASS_CM) {
> +			if (mad_hdr->attr_id != IB_MGMT_CLASSPORTINFO_ATTR_ID) {
> +				if (mad_hdr->method != IB_MGMT_METHOD_SEND)
> +					goto out;
> +			} else if (mad_hdr->method != IB_MGMT_METHOD_GET_RESP)
> +				goto out;
> +		}

Doesn't this invalidate a CM Get(ClassPortInfo) mad?  Is that the intention
because it is not supported in the CM?

For the future it seems like these types of checks should be done at the class
level.  But I'm not advocating that right now.

Ira

>  		/* Filter GSI packets sent to QP0 */
>  		if (qp_num != 0)
>  			valid = 1;
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index 188df91..ec9b44d 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -237,6 +237,8 @@ struct ib_vendor_mad {
>  	u8			data[IB_MGMT_VENDOR_DATA];
>  };
>  
> +#define IB_MGMT_CLASSPORTINFO_ATTR_ID	cpu_to_be16(0x0001)
> +
>  struct ib_class_port_info {
>  	u8			base_version;
>  	u8			class_version;
> -- 
> 1.7.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
