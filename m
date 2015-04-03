From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 02/19] IB/core: Cache device attributes for use by
 upper level drivers
Date: Fri, 3 Apr 2015 20:43:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBD574@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-3-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-3-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 0d74f1d..0116e4b 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1675,6 +1675,7 @@ struct ib_device {
>  	u32			     local_dma_lkey;
>  	u8                           node_type;
>  	u8                           phys_port_cnt;
> +	struct ib_device_attr        cached_dev_attrs;
>  };

Looking at the device attributes, I think all of the values are static for a given device.  If this is indeed the case, then I would just remove the word 'cached' from the field name.  Cached makes me think of the values dynamically changing, and if that's the case, then this patch isn't sufficient.

Alternatively, if there's only a few values that ULPs need, maybe just store those.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
