From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Tue, 30 Jun 2015 05:10:02 -0700
Message-ID: <20150630121002.GA24169@infradead.org>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <1433769339-949-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5C7C@ORSMSX109.amr.corp.intel.com>
 <559281B4.6010807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559281B4.6010807-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 02:47:00PM +0300, Sagi Grimberg wrote:
> Kernel 4.1 introduced the new pmem driver for byte addressable storage
> (https://lwn.net/Articles/640115/). It won't be long before we see HA
> models where secondary persistent memory devices will sit across an
> RDMA fabric. (http://www.snia.org/sites/default/files/DougVoigt_RDMA_Requirements_for_HA.pdf)

And what does this bullshitting slide have to do with our memory models?
In it's current form the pmem driver can't even be used as a (R)DMA
target, so it's totally irrelevant for now.

Let's get a proper in-kernel interface for generic memory registrations
in place as a first step. le this will be a significant amount of work
it'll help greatly with moving nasty implementation details out of
the drivers.  Adding additional registrations methods will be easy
behind the back of a proper abstraction.

> Do we want to live with this limitation forever?

I don't think anyone has refused additional support.  Just the way how
it's done in your patches is a giant nightmare.  The whole RDMA stack
needs a healthy dose of software engineering instead of blindly
following a working group of a marketing organisation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
