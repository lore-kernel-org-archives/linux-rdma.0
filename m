From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port	reservation to support AF_IB
Date: Fri, 26 Mar 2010 18:44:40 -0600
Message-ID: <20100327004440.GE9769@obsidianresearch.com>
References: <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com> <20100325220435.GP29129@obsidianresearch.com> <C70579E21917462C89AAEAE3C225A58B@amr.corp.intel.com> <FD7DFBFAF86D4EA99F82836CBCA8AB33@amr.corp.intel.com> <20100326040809.GD9769@obsidianresearch.com> <57287E48AAAD47A4BD50719B889F4596@amr.corp.intel.com> <350558935FCC47B6A5ABA8402109746C@amr.corp.intel.com> <0F1BE18DBBF74165AEA2B3283B01F338@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0F1BE18DBBF74165AEA2B3283B01F338-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 26, 2010 at 05:11:04PM -0700, Sean Hefty wrote:
> >Actually, the port space doesn't matter when specifying a multicast group.  So,
> >I can't think of any real advantage to supporting AF_IB/PS_TCP.
> 
> Okay - I found one advantage - fewer changes.  :b

Lol!

> I've started adding RDMA_PS_IB.  But the rdma_cm code uses the port space to
> select between UD or RC operation, so additional changes are needed.
> (I'm doing

Gross, way too overloaded...

How does UD operation work with the SID anyhow?

> them now rather than deferring them, since it affects the user to kernel
> interface.)  Since PS IB is not sufficient, I'm adding the qp_type as a
> parameter into rdma_create_id, for that purpose instead.  (This change is only
> to the kernel API.)

So where does ai_qp_type get stuffed in user space?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
