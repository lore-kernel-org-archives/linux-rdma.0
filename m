From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: libibverbs: ibv_fork_init() and huge pages
Date: Wed, 08 Dec 2010 17:46:09 -0800
Message-ID: <ada1v5rk9b2.fsf@cisco.com>
References: <20100820110616.28288724@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100820110616.28288724@alex-laptop> (Alexander Schmidt's
	message of "Fri, 20 Aug 2010 11:06:16 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

So I'm finally looking at applying this (sorry for all the delay), but
I do have one worry: is it possible for an application to register an MR
that has both a huge page and a normal-size page mapping?  In that case
do things still work, or do things blow up?

And is it worth worrying about this case even if it is theoretically possible?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
