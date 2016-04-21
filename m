From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Thu, 21 Apr 2016 13:35:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420012526.GA25508-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The kernel common code side is pretty straightforward, just a bunch of
> tables of function pointers, templates and idrs for each object_type.

This is the part where the intent and implementation are not clear to me.  I see value in generic user space handle validation, but I prefer they map to driver specific resources.  For example, I don't want a user space allocation of a QP to result in this:

1403 struct ib_qp {
1404         struct ib_device       *device;
1405         struct ib_pd           *pd;
1406         struct ib_cq           *send_cq;
1407         struct ib_cq           *recv_cq;
1408         struct ib_srq          *srq;
1409         struct ib_xrcd         *xrcd; /* XRC TGT QPs only */
1410         struct list_head        xrcd_list;
1411         /* count times opened, mcast attaches, flow attaches */
1412         atomic_t                usecnt;
1413         struct list_head        open_list;
1414         struct ib_qp           *real_qp;
1415         struct ib_uobject      *uobject;
1416         void                  (*event_handler)(struct ib_event *, void *);
1417         void                   *qp_context;
1418         u32                     qp_num;
1419         enum ib_qp_type         qp_type;
1420 };

monstrosity being allocated in the kernel.  The size and layout of this sort of structure impacts scalability and performance.  This is where I want to make sure there's alignment on the overall architecture.

More specifically, I would switch the existing uABI commands to ioctl's, leaving the code paths mostly unchanged, but marking them as legacy.  Then add the new ioctls that you suggested, with future drivers hooking directly into the ioctl framework.  Honestly, I'm not sure the rdma core should define anything beyond the common ioctl structure.  Anything else can just be placed into the driver specific portion, or maybe rdma core sub-subsystem (e.g. ib, iwarp, roce, opa, mlx, ...)  Maybe we would define some common ioctl's across all devices, but I don't think they would look anything like the current commands.  They would need to be much higher level.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
