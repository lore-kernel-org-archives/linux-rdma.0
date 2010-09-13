From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2.6.37 09/11] RDMA/cxgb4: Support on-chip SQs.
Date: Mon, 13 Sep 2010 09:13:01 -0700
Message-ID: <adaiq29wrjm.fsf@cisco.com>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
	<20100910161530.6829.89294.stgit@build.ogc.int>
	<4C8A8DC1.4040302@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C8A8DC1.4040302-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Fri, 10 Sep 2010 14:57:53 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Oops, cought this during regression testing:  The above line should be
 > indexing by wq->rq.size, not wq->sq.size.  This error caused
 > intermittent post failures and I missed it on my first round of
 > testing.

Steve, can you send a fixed version of this patch?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
