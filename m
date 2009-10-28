From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Adjusting minimum packet size or "wait to merge requests" in SRP
Date: Wed, 28 Oct 2009 12:51:45 -0700
Message-ID: <ada639zs3e6.fsf@cisco.com>
References: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Chris Worley's message of "Wed, 28 Oct 2009 12:47:45 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > It appears that SRP tries to coalesce and fragment initiator I/O
 > requests into 64KB packets, as that looks to be the size requested
 > to/from the device on the target side (and the I/O scheduler is
 > disabled on the target).

There is no code in the SRP initiator that does anything to change IO
requests that I know of.  So I think this is happening somewhere higher
in the stack.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
