From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Tue, 24 Nov 2009 21:52:44 -0700
Message-ID: <20091125045244.GJ1966@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <DD0B6BCA-5892-4CA9-8F5D-87C6CC1189DC@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DD0B6BCA-5892-4CA9-8F5D-87C6CC1189DC-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2009 at 09:12:53PM -0500, Jeff Squyres wrote:
> On Nov 24, 2009, at 7:11 PM, Jason Gunthorpe wrote:
> 
> >Is the same true for openmpi? If you try to run it as is on a RDMAOE
> >interface will it work? If not I think that alone should kill this
> >idea..
> >
  
> OMPI uses RDMACM (among others), so I'm not sure I follow what you're  
> asking me...?

I think I'm asking you about the non RDMACM stuff in openmpi, ibcm,
xoob, etc. I can't tell at glance if any of them will be safe to run
on RDMAoE as-is..

At least it looks like there are some basic problems, like oob doesn't
exchange a GID, or setup the AH to use a GRH.

Basically, if setting transport_type == IB for RDMAoE breaks existing
stuff then it probably isn't a good strategy.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
