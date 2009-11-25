From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 10:44:23 -0700
Message-ID: <20091125174423.GL1966@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <DD0B6BCA-5892-4CA9-8F5D-87C6CC1189DC@cisco.com> <20091125045244.GJ1966@obsidianresearch.com> <4B0CFEAB.70304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B0CFEAB.70304-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pasha-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2009 at 11:53:47AM +0200, Pavel Shamis (Pasha) wrote:
> 
> >I think I'm asking you about the non RDMACM stuff in openmpi, ibcm,
> >xoob, etc. I can't tell at glance if any of them will be safe to run
> >on RDMAoE as-is..
> >  
> The oob and xoob are custom ompi mpi connection manager that were
> created specially for Infiniband ONLY. So as result they do what they 
> supposed to do - they work with infiniband devices :-
> ) (and do not work with Iwarp and others.). So we do not brake anything 
> here.

Just so everyone is clear here, the test to run only on Infiniband in the
above cases is done by checking the transport_type for Infiniband:

  if (IBV_TRANSPORT_IB != btl->device->ib_dev->transport_type) {

The code protected by this doesn't work on RDMAoE so RDMAoE must not
set transport_type to IBV_TRANSPORT_IB.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
