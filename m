From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Mon, 25 Oct 2010 06:36:43 -0700
Message-ID: <adaaam2jswk.fsf@cisco.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>
	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
	<4CC54D4E.7050203@Voltaire.com> <4CC5604D.2080803@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC5604D.2080803-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Mon, 25
	Oct 2010 12:47:41 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > okay, I verified that with 2.6.36 this node gets IB link and IPoIB is
 > working fine, so it must be something in or related to the for-next
 > branch, I assume around the IBoE patches that touch mlx4 which make
 > this failure to happen. With 2.6.36 I also see the "awk:
 > /etc/ofed/setup-mlx4.awk:6: (FILENAME=/etc/ofed/mlx4.conf FNR=21)
 > fatal: cannot open file `/sbin/setup-mlx4' for reading (No such file
 > or directory)" warning when loading mlx4_ib, but it doesn't
 > disruptive in the sense that the node works fine, IB wise.

I suspect I broke either the UD header packing or the build_mlx_header
function when I "cleaned up" the patches.  I see the same problem, I'll
take a look today.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
