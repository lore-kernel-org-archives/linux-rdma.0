From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: fix post_recv wq overflow check
Date: Wed, 06 Jan 2010 23:53:59 -0800
Message-ID: <adaocl6qrjc.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.64.0912231727040.19295@zuben.voltaire.com>
	<adapr5nt0rc.fsf@roland-alpha.cisco.com> <4B45913C.10405@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B45913C.10405-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Thu, 07
	Jan 2010 09:46:04 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > With this not being a regression, I see that it went into your
 > for-next branch and as such I assume will be available by 2.6.34. Are
 > you fine with the patch going into the -stable series?

Actually I was planning on sending it for 2.6.33, since it's so small
and obvious and we're reasonable early in the cycle.  Not sure about
-stable though -- has this been hit in practice?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
