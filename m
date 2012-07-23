From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: uverbs message alignment
Date: Mon, 23 Jul 2012 12:30:27 -0600
Message-ID: <20120723183027.GA26358@obsidianresearch.com>
References: <5009D0AF.1090409@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6BE19@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A6BE19-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 21, 2012 at 05:15:26AM +0000, Hefty, Sean wrote:
> > struct c4iw_create_raw_qp_req {
> >          struct ibv_create_qp ibv_req;
> >          __u32 port;
> >          __u32 vlan_pri;
> >          __u32 nfids;
> > };
> 
> struct ibv_create_qp contains a u64, which will force the size of
> the structure to 64-bit.  You should to add an additional 32-bits of
> padding.

Specifically, the padding Sean is talking about is here:

struct c4iw_create_raw_qp_req {
        struct ibv_create_qp ibv_req;
        __u32 port;
        __u32 vlan_pri;
        __u32 nfids;
        __u32 _rsvd0;  // <<<---- pad
};

And similarly in your driver's header. Things are setup so that
device_data does not have to be a multple of 8 bytes long, but it is
guarenteed to be 8 byte aligned.

However as long as you include ibv_req in your struct you have to be a
multiple of 8 bytes long so, you may want to construct your
driver_data the same way that userspace does. Remove the ibv_req from
the struct and cast from driver_data. This avoids this sort of
problem completely.

Also, always ensure structs you are passing between kernel and user
space have no implicit padding at all.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
