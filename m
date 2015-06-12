From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 38/41] IB/hfi1: add general verbs handling
Date: Fri, 12 Jun 2015 14:10:58 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506121359550.29124@east.gentwo.org>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com> <20150611231153.16479.20726.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611231153.16479.20726.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 11 Jun 2015, Mike Marciniszyn wrote:

> +static int query_device(struct ib_device *ibdev,
> +			struct ib_device_attr *props)
> +{
> +	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
> +	struct hfi1_ibdev *dev = to_idev(ibdev);
> +
> +	memset(props, 0, sizeof(*props));
> +
> +	props->device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
> +		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
> +		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
> +		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;

Hmmm... One thing that we need here is:

	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK

to avoid the flow back of large multicast streams. Looks like this is
IB/OP only. If you support ethernet then other flags are required too.

> +	props->page_size_cap = PAGE_SIZE;

No large page support?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
