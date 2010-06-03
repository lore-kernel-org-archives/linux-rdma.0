From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/2] infiniband/cxgb4: add null check
Date: Wed, 02 Jun 2010 22:22:07 -0700
Message-ID: <adaaarcr8qo.fsf@roland-alpha.cisco.com>
References: <20100531140152.GU5483@bicker>
	<adaeigpqepg.fsf@roland-alpha.cisco.com>
	<4C07177C.5050502@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C07177C.5050502-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Wed, 02 Jun 2010 21:46:20 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > I actually think that ep->com.cm_id is always valid when
 > connect_reply_upcall() is called.  But I'd have to test it more.  I'd
 > rather not add this change unless someone convinces me that there
 > actually is a path where the cm_id null...

Then would it make sense to change the code

	if (ep->com.cm_id) {
		PDBG("%s ep %p tid %u status %d\n", __func__, ep,
		     ep->hwtid, status);
		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
	}

to just

	PDBG("%s ep %p tid %u status %d\n", __func__, ep,
	     ep->hwtid, status);
	ep->com.cm_id->event_handler(ep->com.cm_id, &event);

?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
