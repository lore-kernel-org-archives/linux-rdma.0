From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_reg_read()
Date: Fri, 8 Nov 2013 01:04:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF6429@ORSMSX109.amr.corp.intel.com>
References: <527C2D99.9050407@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A8237388CF63E9@ORSMSX109.amr.corp.intel.com>
 <527C316E.50805@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527C316E.50805-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Felix Marti <felix-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 11/7/2013 6:21 PM, Hefty, Sean wrote:
> >> static inline struct ibv_mr *
> >> rdma_reg_read(struct rdma_cm_id *id, void *addr, size_t length)
> >> {
> >>           return ibv_reg_mr(id->pd, addr, length, IBV_ACCESS_LOCAL_WRITE
> |
> >> IBV_ACCESS_REMOTE_READ);
> >> }
> >>
> >> Should this be used for the registering sink memory of an rdma read?  If
> >> so, it won't work for iWARP, which requires REMOTE_WRITE for the sink.
> >> Should this code look at the transport type and set REMOTE_WRITE for
> >> iwarp transports?
> > This is to register memory as the target of an RDMA read operation.  I.e.
> the memory being read.  Is that the same as your 'sink'?
> 
> No, I would call that the 'source' of the read.    Basically the mr
> to-which the read data is placed needs REMOTE_WRITE for iWARP.

Then I think that maps to the rdma_reg_write() call.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
