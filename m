From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Sat, 31 Dec 2011 11:01:02 +0000
Message-ID: <CAO+b5-qnSSeieJwnxxPENfHPGF4CJeJ8e5_9c9S57PRdL1j1hg@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
	<201108011508.06521.jackm@dev.mellanox.co.il>
	<20110802053824.GA23512@obsidianresearch.com>
	<201108021053.05311.jackm@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com>
	<4EFC8A85.4020803@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFC8A85.4020803-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 29, 2011 at 3:43 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 5. what happens if we just want to enhance an -- existing -- function -
> suppose we want to enhance ibv_post_send / ibv_poll_cq to support features
> like LSO, checksum offload, masked atomic operations, fast memory remote
> invalidate, etc so we add IBV_WR_NEW_FEATURE / IB_WC_NEW_FEATURE enum
> values, this step is simple, again if we go the way of the applicayion
> ensuring through dependencies that they are loaded against libibverbs that
> supports IB_{WR,WC}_NEW_FEATURE.

Not only for the ABI between the Linux kernel and Linux user space but
also for Linux shared libraries it is required that the ABI of a new
version is backwards compatible with previous versions. So any
functionality that can't be added in a backwards compatible way to an
existing function should be added as a new system call, sysfs file or
shared library function - whatever is appropriate.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
