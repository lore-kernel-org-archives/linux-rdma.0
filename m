From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Tue, 8 Sep 2009 08:25:53 +0200
Message-ID: <e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
References: <adaws4an4uh.fsf@cisco.com>
	 <e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	 <adaskeym5gu.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaskeym5gu.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2009 at 6:21 AM, Roland Dreier<rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>
> =A0> With 2.6.31-rc9 + patch 4e49627b9bc29a14b393c480e8c979e3bc922ef7=
 + the
> =A0> patch you posted at the start of this thread the following lockd=
ep
> =A0> complaint was triggered on the SRP initiator system during SRP l=
ogin:
> =A0>
> =A0> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =A0> [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> =A0> 2.6.31-rc9 #2
> =A0> ------------------------------------------------------
> =A0> ibsrpdm/4290 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> =A0> =A0(&(&rmpp_recv->cleanup_work)->timer){+.-...}, at:
> =A0> [<ffffffff802559f0>] del_timer_sync+0x0/0xa0
> =A0>
> =A0> and this task is already holding:
> =A0> =A0(&mad_agent_priv->lock){..-...}, at: [<ffffffffa03c6de8>]
> =A0> ib_cancel_rmpp_recvs+0x28/0x118 [ib_mad]
> =A0> which would create a new lock dependency:
> =A0> =A0(&mad_agent_priv->lock){..-...} -> (&(&rmpp_recv->cleanup_wor=
k)->timer){+.-...}
>
> And this report doesn't happen with the older patch? =A0(Did you do t=
he
> same testing with the older patch that triggered this)
>
> Because this looks like a *different* incarnation of the same
> lock->lock->delayed work/timer that we're trying to fix here -- the
> delayed work is now rmpp_recv->cleanup_work in this case instead of
> mad_agent_priv->timed_work as it was before.

The above issue does not occur with the for-next branch of the
infiniband git tree, but does occur with 2.6.31-rc9 + aforementioned
patches.

As far as I can see commit 721d67cdca5b7642b380ca0584de8dceecf6102f
(http://git.kernel.org/?p=3Dlinux/kernel/git/roland/infiniband.git;a=3D=
commitdiff;h=3D721d67cdca5b7642b380ca0584de8dceecf6102f)
is not yet included in 2.6.31-rc9. Could this be related to the above
issue ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
