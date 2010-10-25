From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Mon, 25 Oct 2010 16:15:47 +0200
Message-ID: <AANLkTi=ZxB4b463OOS6YGxTJSKxjyCj8vy0rNtj0n+uA@mail.gmail.com>
References: <20101024075835.GA11359@mtldesk30>
	<adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30>
	<adaocajo90s.fsf@cisco.com>
	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
	<4CC54D4E.7050203@Voltaire.com>
	<20101025113452.GB1802@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101025113452.GB1802@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 25, 2010 at 1:34 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> IBoE will not work with firmware prior to 2.7.000. I don't think an
> error message is required in this case.

But I'm on **IB** not IBoE, I don't think you mean that the Linux
kernel IB stack is not functional over pre-2.7 firmware with the IBoE
patches?! are you?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
