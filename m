From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Tue, 24 Nov 2009 17:11:36 -0700
Message-ID: <20091125001136.GP6188@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <209ECE49-3AB9-4E62-B825-54E474321FA6-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2009 at 06:23:15PM -0500, Jeff Squyres wrote:

> 2. I am somewhat confused by the overloading of the term "transport".   
> It appears that a device will have  
> ibv_device.transport_type==IBV_TRANSPORT_IB for both IB and RDMAOE  
> devices.  The only way to tell the difference is to examine the new  
> ibv_port_attr.transport field to see if it is RDMA_TRANSPORT_IB or  
> RDMA_TRANSPORT_RDMAOE.

I haven't seen these patches but this seems poor to me. I think any
app that isn't using rdmacm will need patching and support for RDMAOE
(certainly all mine will). libibverbs shouldn't overload the existing
transport_type checks for something that is not 100% compatible with
IB.

Is the same true for openmpi? If you try to run it as is on a RDMAOE
interface will it work? If not I think that alone should kill this
idea..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
