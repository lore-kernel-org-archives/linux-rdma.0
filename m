From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Tue, 08 Sep 2009 10:17:01 -0700
Message-ID: <ada7hw9mk4y.fsf@cisco.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	<adaskeym5gu.fsf@cisco.com>
	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
	<e2e108260909081001u5c31fcf0lca909c488831ec4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260909081001u5c31fcf0lca909c488831ec4b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Tue, 8 Sep 2009 19:01:42 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > Update: patch 721d67cdca5b7642b380ca0584de8dceecf6102f does not apply
 > cleanly to 2.6.31-rc9, so I have been using a slightly modified
 > version of this patch
 > (http://bugzilla.kernel.org/attachment.cgi?id=22624).
 > 
 > I have retested the 2.6.31-rc9 kernel with the following patches applied to it:
 > * patch 4e49627b9bc29a14b393c480e8c979e3bc922ef7
 > * http://bugzilla.kernel.org/attachment.cgi?id=22624
 > * the patch posted at the start of this thread.
 > 
 > With this combination I did not observe any lockdep complaints.

OK, thanks.  That makes sense -- the new mad patch should be equivalent
to the old in terms of what it fixes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
