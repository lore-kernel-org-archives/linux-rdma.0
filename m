From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Mon, 30 Nov 2009 15:34:06 +0200
Message-ID: <20091130133406.GA32123@mtls03>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
 <20091125001136.GP6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091125001136.GP6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2009 at 05:11:36PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2009 at 06:23:15PM -0500, Jeff Squyres wrote:
> 
> > 2. I am somewhat confused by the overloading of the term "transport".   
> > It appears that a device will have  
> > ibv_device.transport_type==IBV_TRANSPORT_IB for both IB and RDMAOE  
> > devices.  The only way to tell the difference is to examine the new  
> > ibv_port_attr.transport field to see if it is RDMA_TRANSPORT_IB or  
> > RDMA_TRANSPORT_RDMAOE.
> 
> I haven't seen these patches but this seems poor to me. I think any
> app that isn't using rdmacm will need patching and support for RDMAOE
> (certainly all mine will). libibverbs shouldn't overload the existing
> transport_type checks for something that is not 100% compatible with
> IB.
> 
> Is the same true for openmpi? If you try to run it as is on a RDMAOE
> interface will it work? If not I think that alone should kill this
> idea..
> 
If we change struct ibv_port_attr transport field from enum to uint8,
we eliminate binary compatibility problems. That's because the previous
filed is aligned to 16 bits address so that leaves us 16 bits more.

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 07d4395..f7fe68d 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -192,7 +192,7 @@ struct ibv_port_attr {
        uint8_t                 active_width;
        uint8_t                 active_speed;
        uint8_t                 phys_state;
-       enum rdma_transport_type transport;
+       uint8_t                 transport;
 };

Moreover, I would like to change the field's name from transport to
link_protocl. Let me know if that makes more sense to you.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
