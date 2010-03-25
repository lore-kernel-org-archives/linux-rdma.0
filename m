From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port
	reservation to support AF_IB
Date: Thu, 25 Mar 2010 16:04:35 -0600
Message-ID: <20100325220435.GP29129@obsidianresearch.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AC26D518E7AE4BE6BA3BDFC11480F8DB-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 25, 2010 at 02:00:25PM -0700, Sean Hefty wrote:

> >IMHO, after thinking about it for a bit, I would prefer to see the
> >port space be unused from a user-space perspective when used with
> >AF_IB.
> 
> The rdma_cm_id is associated with a port space on creation, before
> it's known what address family will be used.  The kernel code
> enforces that the SID is formatted correctly for the port space that
> was selected.

Does this early association with the port space have any effect?

> >If a ps is needed in the kernel then it should pick the ps based on
> >the SID prefix that user space provided.. I guess prior to adding the
> >mask bits this wouldn't have made sense, but now that they are in it
> >seems like the way to go.
> 
> I added sib_mask to sockaddr_ib, but it's unused at this point.  I
> think what you're saying makes sense, but for RDMA_PS_IB, once it's
> defined.  RDMA_PS_IB may need to behave as RDMA_PS_TCP or
> RDMA_PS_UDP based on the sib_mask and SID, and ensure that any
> selected SID is reserved from the correct underlying SID region.

I would be inclined to ditch the port space concept entirely for
AF_IB. Just ignore the input parameter and always base the selection
on the SID region. It is confusing to that there are two ways to
specify the same thing.

Is there any reason the port space has to be known when the cm_id is
created but before bind?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
