From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Mon, 5 Oct 2009 12:20:20 -0700
Message-ID: <7678E71349EE4E57ADB9B81D7C176BB2@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <20091005175656.GK5191@obsidianresearch.com> <F7D418716F3A4A0DACE42CC449624298@amr.corp.intel.com> <20091005181525.GL5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091005181525.GL5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>But that isn't really the point, IB CM already provides this API so,
>why corrupt the RDMA CM abstraction with this?

The RDMA CM abstraction does not work on larger cluster sizes.  Either we can
fix the RDMA CM or force all RDMA CM applications to be re-written and become
transport aware.  This allows the librdmacm to implement a fix and communicate
the necessary information to the kernel for connection establishment using
generic mechanisms and an existing RDMA CM API.  (One alternative is for the
kernel RDMA CM to communicate directly with the IB ACM or other external
service, but I'd like to see much wider testing, acceptance, and standardization
before attempting that.)  I could not find an efficient way of implementing the
entire solution in user space because of the event reporting and port space
handling.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
