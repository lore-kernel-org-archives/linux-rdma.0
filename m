From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: broken support for UC in rdma_cm
Date: Mon, 15 Mar 2010 15:45:27 +0200
Message-ID: <20100315134527.GA31210@mtldesk030.lab.mtl.com>
References: <20100315111228.GC23358@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100315111228.GC23358-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I just noticed that Vlad already opened a bugzilla bug (1874) on this.
I quote Sean's response:

RDMA CM supports UD and RC QPs (port spaces UDP/TCP) only.  Support
for UC QPs should come from another port space.

This makes sense to me. Still we need to address the issues I raised
below. Sean, are you going to fix this?

On Mon, Mar 15, 2010 at 01:12:28PM +0200, Eli Cohen wrote:
> We got failing tests in our regression that use UC transport from
> userspace. Looking at cma_connect_ib(), I see that it uses IB_QPT_RC
> in the CM request instead of using whatever the transport type of the
> requesting QP. There is no easy way to retrieve that information too
> since the QP is created in userspace. We do have the QP number. One
> way to address this problem is to have an API that returns a pointer
> to struct ib_qp given the ib device and the QP number. Another way
> would be to pass qp_type through the call to rdma_init_qp_attr().
> Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
