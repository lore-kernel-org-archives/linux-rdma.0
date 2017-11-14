From: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: KASAN: use-after-free Read in rds_tcp_dev_event
Date: Tue, 14 Nov 2017 01:57:00 -0500
Message-ID: <20171114065700.GK26261@oracle.com>
References: <001a1148d244ade0aa055d6a69b9@google.com>
 <9e71dff9-7ba8-a3c2-6862-fb8557546a54@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9e71dff9-7ba8-a3c2-6862-fb8557546a54-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Girish Moodalbail <girish.moodalbail-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: syzbot <bot+643ecad3f5bb49700e839363b608c4928f6db8f0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On (11/13/17 19:30), Girish Moodalbail wrote:
> (L538-540). However, it leaves behind some of the rds_tcp connections that
> shared the same underlying RDS connection (L534 and 535). These connections
> with pointer to stale network namespace are left behind in the global list.

It leaves behind no such thing. After mprds, you want to collect
only one instance of the conn that is being removed, that's why
lines 534-535 skips over duplicat instances of the same conn
(for multiple paths in the same conn).

> When the 2nd network namespace is deleted, we will hit the above stale
> pointer and hit UAF panic.
> I think we should move away from global list to a per-namespace list. The
> global list are used only in two places (both of which are per-namespace
> operations):

Nice try, but not so. 

Let me look at this tomorrow, I missed this mail in my mbox.

--Sowmini

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
