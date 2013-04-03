From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] Add IBV_*_USNIC enums for the Cisco Ethernet Virtual NIC.
Date: Wed, 3 Apr 2013 21:45:50 +0300
Message-ID: <CAJZOPZLJWBvqFVUdYch+xU6yFwc0dKTBUb5qV_Hbxf=8HEKkqw@mail.gmail.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
	<1828884A29C6694DAF28B7E6B8A823736F36A3A6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36A3A6-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 3, 2013 at 5:49 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Per off-list conversation with Roland, add some new enums for the
>> Cisco Ethernet Virtual NIC (it's not an RNIC/iWARP device, so it
>> doesn't fit in the same category as RDMA_NODE_RNIC /
>> RDMA_TRANSPORT_IWARP).  "USNIC" = "Userspace NIC".

> Can we get a better patch description?
> Maybe mention something about the NIC?  Does it support all verbs?  Is it for kernel
> users or just user space?  Does this simply export a raw ethernet interface?

Jeff, I agree with Sean, there's not much point to review/discuss
these general/pre-step patches without seeing some actual device
specific kernel (if there are such or user space code if there aren't
any kernel ones) code. e.g you can submit the two kernel pre-step
patches as the two first pieces in a series that has the driver code.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
