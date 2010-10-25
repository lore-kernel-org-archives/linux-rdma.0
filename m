From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches (was
 "mlx4: Fix unneeded return error...")
Date: Mon, 25 Oct 2010 12:47:41 +0200
Message-ID: <4CC5604D.2080803@Voltaire.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com> <4CC54D4E.7050203@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC54D4E.7050203-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I pulled/built/booted with the for-next branch of Roland's tree, and I can't get IB link for the node, 
> I don't think this is my problem, since I'm on L2 IB and not Eth, but should this work with pre 2.7 
> firmware?! if not, maybe patch the mlx4 driver to print some error,

okay, I verified that with 2.6.36 this node gets IB link and IPoIB is working fine, so it must be something in or related to the for-next branch, I assume around the IBoE patches that touch mlx4 which make this failure to happen. With 2.6.36 I also see the "awk: /etc/ofed/setup-mlx4.awk:6: (FILENAME=/etc/ofed/mlx4.conf FNR=21) fatal: cannot open file `/sbin/setup-mlx4' for reading (No such file or directory)" warning when loading mlx4_ib, but it doesn't disruptive in the sense that the node works fine, IB wise. 


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
