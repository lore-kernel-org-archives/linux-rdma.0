From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Mon, 25 Oct 2010 10:23:49 -0700
Message-ID: <adalj5mgp96.fsf@cisco.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>
	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
	<4CC54D4E.7050203@Voltaire.com> <4CC5604D.2080803@Voltaire.com>
	<adaaam2jswk.fsf@cisco.com> <20101025161730.GA9335@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101025161730.GA9335@mtldesk30> (Eli Cohen's message of "Mon,
	25 Oct 2010 18:17:30 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I think this will fix things up. The + operator has precedence over
 > the ? operator so we end up with packet_length equal IB_GRH_BYTES / 4
 > which is wrong.

Yep, looks like that's where my cleanup broke things.  I rolled this in
and pushed it out; I'm testing it myself now.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
