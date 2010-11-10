From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: asynchronous operation with poll()
Date: Wed, 10 Nov 2010 09:43:12 -0800
Message-ID: <adak4klqdlb.fsf@cisco.com>
References: <ibbr34$ima$1@dough.gmane.org>
	<20101109204452.GG909@obsidianresearch.com>
	<ibeaq8$egv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ibeaq8$egv$1@dough.gmane.org> (Jonathan Rosser's message of
	"Wed, 10 Nov 2010 14:39:03 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Could I get some clarification on where there is no ordering
 > guarantee? The WC's do not necessarily come back in the order that the
 > sends were posted?

For a given queue, completions are always returned in the order that
work requests were posted.  However there is no ordering between
different queues.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
