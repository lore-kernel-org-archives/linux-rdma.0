From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Mon, 25 Oct 2010 13:34:52 +0200
Message-ID: <20101025113452.GB1802@mtldesk30>
References: <20101024075835.GA11359@mtldesk30>
 <adahbgbppgx.fsf@cisco.com>
 <20101024160018.GA32499@mtldesk30>
 <adaocajo90s.fsf@cisco.com>
 <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
 <4CC54D4E.7050203@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CC54D4E.7050203-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 25, 2010 at 11:26:38AM +0200, Or Gerlitz wrote:
> 
> I pulled/built/booted with the for-next branch of Roland's tree, and I can't get IB link for the node, 
> I don't think this is my problem, since I'm on L2 IB and not Eth, but should this work with pre 2.7 
> firmware?! if not, maybe patch the mlx4 driver to print some error,
> 

Hi Or,
IBoE will not work with firmware prior to 2.7.000. I don't think an
error message is required in this case.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
