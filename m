From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Sun, 24 Oct 2010 21:12:37 -0700
Message-ID: <adad3qync5m.fsf@cisco.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>
	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Eli Cohen's message of "Sun, 24 Oct 2010 20:05:08 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OK... since my "fix" for the missing return of the error value ended up
breaking things, I just decided to fold this second fix into the
original patch.  The end result is the same code but I didn't think
keeping the buggy point in the middle of history helped anything.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
