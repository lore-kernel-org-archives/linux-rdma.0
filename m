From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/cxgb3: When a user QP is marked in error, also mark the CQs in error.
Date: Mon, 25 Oct 2010 08:44:55 -0700
Message-ID: <adaocaii8eg.fsf@cisco.com>
References: <20101021123705.7604.20848.stgit@build.ogc.int>
	<adar5fhts2b.fsf@cisco.com> <4CC590F9.7010608@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC590F9.7010608-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Mon, 25 Oct 2010 09:15:21 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Good catch Roland.  Is there an easy way to configure/build libibverbs
 > and librdmacm as 32bit?   My system only has the 64b versions.  So
 > I'll need to build 32b versions of these to test my fix with a 32b app
 > / 64b kernel.

It kind of depends on the distribution.  On Debian it's not *too* hard
to set up a 32-bit chroot... not sure about other distros.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
