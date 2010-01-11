From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: fix post_recv wq overflow check
Date: Mon, 11 Jan 2010 09:08:21 -0800
Message-ID: <adamy0kpo1m.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.64.0912231727040.19295@zuben.voltaire.com>
	<adapr5nt0rc.fsf@roland-alpha.cisco.com> <4B45913C.10405@Voltaire.com>
	<adaocl6qrjc.fsf@roland-alpha.cisco.com>
	<4B45A2E5.2070301@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B45A2E5.2070301-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Thu, 07
	Jan 2010 11:01:25 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > I wonder if the overflow check could be removed all together and be
 > left to the ULP (kernel is trusted environment...) is there any risk
 > in doing so? this way the WR posting code will not experience
 > contention with the poll WC code on the CQ lock.

We could do that I guess if it's a really big performance gain.  I do
think it is quite common to see this WQ overflow check trigger, even for
kernel code, and so we would have to be sure the performance gain is
worth making these bugs much harder to find and fix.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
