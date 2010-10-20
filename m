From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2.6.37] RDMA/cxgb3: When a user QP is marked in error, also mark the CQs in error.
Date: Wed, 20 Oct 2010 14:54:30 -0700
Message-ID: <adapqv47co9.fsf@cisco.com>
References: <20101020214432.4869.50981.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020214432.4869.50981.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Wed, 20 Oct 2010 16:44:32 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > - bump the ABI since the create_cq uverbs response changes.

 > - detect older libraries and reduce the mmap size accordingly.

If you bump the ABI, will older libraries still run with the new driver?
Or will they just bail out with "unsupported ABI version"?

If you can work with both old and new userspace libraries, is there any
reason for an ABI break anyway?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
