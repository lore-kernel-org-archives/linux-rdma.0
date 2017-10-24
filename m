From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Endianess in cxgb4
Date: Tue, 24 Oct 2017 14:31:05 -0500
Message-ID: <06a801d34cfe$a2563840$e702a8c0$@opengridcomputing.com>
References: <20171024183759.GK16127@mtr-leonro.local> <20171024185506.GE1806@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024185506.GE1806-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Tue, Oct 24, 2017 at 09:37:59PM +0300, Leon Romanovsky wrote:
> > Hi Steve,
> >
> > I reviewed my reports from various static checkers and saw strange code
> > in build_tpte_memreg() function that in drivers/infiniband/hw/cxgb4/qp.c.
> >
> > That function has following code:
> >  614         fr->r2 = cpu_to_be32(0);
> >  615         fr->stag = cpu_to_be32(mhp->ibmr.rkey);
> >
> > The r2, stag and rkey are u32, why do you need cpu_to_be32() conversion?
> >
> > The error report which I got is:
> >
> >  134 drivers/infiniband/hw/cxgb4/qp.c:614:16: warning: incorrect type in
> assignment (different base types)
> >  135 drivers/infiniband/hw/cxgb4/qp.c:614:16:    expected unsigned int
[unsigned]
> [usertype] r2
> >  136 drivers/infiniband/hw/cxgb4/qp.c:614:16:    got restricted __be32
[usertype]
> <noident>
> >  137 drivers/infiniband/hw/cxgb4/qp.c:615:18: warning: incorrect type in
> assignment (different base types)
> >  138 drivers/infiniband/hw/cxgb4/qp.c:615:18:    expected unsigned int
[unsigned]
> [usertype] stag
> >  139 drivers/infiniband/hw/cxgb4/qp.c:615:18:    got restricted __be32
[usertype]
> <noident>
> 
> I looked at cxgb in userspace and gave up. It seemed to be storing be
> and host values in the same memory locations :(

The Terminator HW/FW WRs are in BE always, with the exception that something
"opaque and owned by the host" is in HBO.  The only one I can think of is the
wrid field in each Terminator SQE.  It is provided by the host in each WR, and
is opaque to the HW/FW.  That is, the HW/FW does not interpret this 16b field,
but simply reflects it in the corresponding CQE.  

See my reply to Leon regarding the above issue...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
