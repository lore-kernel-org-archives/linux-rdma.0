From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Tue, 26 Oct 2010 11:33:05 +0200
Message-ID: <4CC6A051.3010703@Voltaire.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>	<4CC54D4E.7050203@Voltaire.com> <4CC5604D.2080803@Voltaire.com>	<adaaam2jswk.fsf@cisco.com> <20101025161730.GA9335@mtldesk30>	<adalj5mgp96.fsf@cisco.com> <adahbgagopw.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbgagopw.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>> Yep, looks like that's where my cleanup broke things.  I rolled this in
>> and pushed it out; I'm testing it myself now.
 
> My IB port comes to active now, I think that fixed things.

same here, I have IB port coming to active and basic IPoIB, opensm working okay
on the node with the current for-next/IBoE bits

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
