From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Tue, 17 Jan 2017 15:27:47 -0700
Message-ID: <20170117222747.GA11409@obsidianresearch.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
 <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
 <1484338667.2679.15.camel@sandisk.com>
 <F3529576D8E232409F431C309E29399336C5FF78@CRSMSX102.amr.corp.intel.com>
 <1484344759.2679.26.camel@sandisk.com>
 <F3529576D8E232409F431C309E29399336C6006C@CRSMSX102.amr.corp.intel.com>
 <1484689709.2729.6.camel@sandisk.com>
 <1484690386.2729.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484690386.2729.8.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 10:00:00PM +0000, Bart Van Assche wrote:
> +	/*
> +	 * qib and hfi1 use two sets of DMA operations:
> +	 * - The DMA operations of the PCIe device for SDMA.
> +	 * - dma_virt_ops for users of the qib and hfi1 drivers.
> +	 * The only purpose of @dma_device is to provide a struct device that
> +	 * provides dma_virt_ops.
> +	 */
> +	struct device dma_device;

Creating a struct device, not calling device_initialize() and then
passing it around it other places is pretty ugly and potentially
dangerous.

Is there some other way?

Can you setup ibdev to be the 'dma device' for the user side?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
