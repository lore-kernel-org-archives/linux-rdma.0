From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Sun, 24 Oct 2010 09:22:43 -0700
Message-ID: <adaocajo90s.fsf@cisco.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101024160018.GA32499@mtldesk30> (Eli Cohen's message of "Sun,
	24 Oct 2010 18:00:18 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > No you did not. It was there already but we never noticed before
 > Yossi's patch.

But AFAICT Yossi's patch (5eb620c8) went into 2.6.22 about 2.5 years
ago... wasn't that already there way before the IBoE stuff started?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
