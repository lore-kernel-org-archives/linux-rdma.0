From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Tue, 08 Sep 2009 10:15:35 -0700
Message-ID: <adabpllmk7c.fsf@cisco.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	<adaskeym5gu.fsf@cisco.com>
	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260909072325w2e0b4b1na0aa01a74f2341e4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Tue, 8 Sep 2009 08:25:53 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > The above issue does not occur with the for-next branch of the
 > infiniband git tree, but does occur with 2.6.31-rc9 + aforementioned
 > patches.
 > 
 > As far as I can see commit 721d67cdca5b7642b380ca0584de8dceecf6102f
 > (http://git.kernel.org/?p=linux/kernel/git/roland/infiniband.git;a=commitdiff;h=721d67cdca5b7642b380ca0584de8dceecf6102f)
 > is not yet included in 2.6.31-rc9. Could this be related to the above
 > issue ?

Yes, that would make sense.  "priv->lock" -- ie the ipoib lock whose
coverage is reduced in 721d67cd -- is in the lockdep report you posted.
So it seems likely that 721d67cd makes the mad_rmpp report not trigger.
However I think the mad_rmpp code does still have a lock-lock-timer
problem that could cause lockdep reports in the future, so I'll have a
look at fixing it.

Do you happen to have the full lockdep output from this test handy?  I'm
curious to see exactly how the mad_rmpp lock gets linked to priv->lock.

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
