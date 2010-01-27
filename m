From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb3: Don't allocate the sw queue for user mode CQs.
Date: Wed, 27 Jan 2010 11:39:09 -0800
Message-ID: <adar5pbmj6q.fsf@roland-alpha.cisco.com>
References: <20100127170353.19882.40656.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100127170353.19882.40656.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Wed, 27 Jan 2010 11:03:54 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > -	kfree(cq->sw_queue);
 > +	if (cq->sw_queue)
 > +		kfree(cq->sw_queue);

Looks like cq->sw_queue will be set to NULL when it's not allocated (ie
the userspace case).  So that's OK.

But kfree(NULL) is fine.  So you can drop this hunk I think.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
