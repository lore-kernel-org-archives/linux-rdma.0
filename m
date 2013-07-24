From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib/mad: remove Device Mgmt from RMPP class list
Date: Wed, 24 Jul 2013 17:59:09 -0400
Message-ID: <51F04E2D.9060708@dev.mellanox.co.il>
References: <20130724144426.5a63669ea6107c8a3e6c1867@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130724144426.5a63669ea6107c8a3e6c1867-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/24/2013 5:44 PM, Ira Weiny wrote:
> The specification does not indicate that Device Mgmt is an RMPP class.

See Annex 8; DevMgt class version 2 rather than 1 is currently supported.

-- Hal

> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index dc3fd1e..309b507 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -943,7 +943,6 @@ EXPORT_SYMBOL(ib_get_mad_data_offset);
>  int ib_is_mad_class_rmpp(u8 mgmt_class)
>  {
>  	if ((mgmt_class == IB_MGMT_CLASS_SUBN_ADM) ||
> -	    (mgmt_class == IB_MGMT_CLASS_DEVICE_MGMT) ||
>  	    (mgmt_class == IB_MGMT_CLASS_DEVICE_ADM) ||
>  	    (mgmt_class == IB_MGMT_CLASS_BIS) ||
>  	    ((mgmt_class >= IB_MGMT_CLASS_VENDOR_RANGE2_START) &&

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
