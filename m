From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: rnfs: rq_respages pointer is bad
Date: Wed, 05 May 2010 15:58:07 -0700
Message-ID: <ada6332arcw.fsf@roland-alpha.cisco.com>
References: <1267489621.9774.41.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1267489621.9774.41.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org> (David J. Wilder's
	message of "Mon, 01 Mar 2010 16:27:00 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > The source of the problem is in rdma_read_complete(), I am finding that
 > rqstp->rq_respages is set to point past the end of the rqstp->rq_pages
 > page list.  This results in a NULL reference in svc_process() when
 > passing rq_respages[0] to page_address().

did this ever end up getting fixed upstream?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
