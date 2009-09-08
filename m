From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [ofa-general] Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer
	deadlock
Date: Tue, 8 Sep 2009 19:01:42 +0200
Message-ID: <e2e108260909081001u5c31fcf0lca909c488831ec4b@mail.gmail.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	<adaskeym5gu.fsf@cisco.com>
	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, general@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2009 at 8:25 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Tue, Sep 8, 2009 at 6:21 AM, Roland Dreier<rdreier@cisco.com> wrote:
> > =A0> With 2.6.31-rc9 + patch 4e49627b9bc29a14b393c480e8c979e3bc922ef7 +=
 the
> > =A0> patch you posted at the start of this thread the following lockdep
> > =A0> complaint was triggered on the SRP initiator system during SRP log=
in:
> > =A0>
> > =A0> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > =A0> [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > =A0> 2.6.31-rc9 #2
> > =A0> ------------------------------------------------------
> > =A0> ibsrpdm/4290 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > =A0> =A0(&(&rmpp_recv->cleanup_work)->timer){+.-...}, at:
> > =A0> [<ffffffff802559f0>] del_timer_sync+0x0/0xa0
> > =A0>
> > =A0> and this task is already holding:
> > =A0> =A0(&mad_agent_priv->lock){..-...}, at: [<ffffffffa03c6de8>]
> > =A0> ib_cancel_rmpp_recvs+0x28/0x118 [ib_mad]
> > =A0> which would create a new lock dependency:
> > =A0> =A0(&mad_agent_priv->lock){..-...} -> (&(&rmpp_recv->cleanup_work)=
->timer){+.-...}
> >
> > And this report doesn't happen with the older patch? =A0(Did you do the
> > same testing with the older patch that triggered this)
> >
> > Because this looks like a *different* incarnation of the same
> > lock->lock->delayed work/timer that we're trying to fix here -- the
> > delayed work is now rmpp_recv->cleanup_work in this case instead of
> > mad_agent_priv->timed_work as it was before.
>
> The above issue does not occur with the for-next branch of the
> infiniband git tree, but does occur with 2.6.31-rc9 + aforementioned
> patches.
>
> As far as I can see commit 721d67cdca5b7642b380ca0584de8dceecf6102f
> (http://git.kernel.org/?p=3Dlinux/kernel/git/roland/infiniband.git;a=3Dco=
mmitdiff;h=3D721d67cdca5b7642b380ca0584de8dceecf6102f)
> is not yet included in 2.6.31-rc9. Could this be related to the above
> issue ?

Update: patch 721d67cdca5b7642b380ca0584de8dceecf6102f does not apply
cleanly to 2.6.31-rc9, so I have been using a slightly modified
version of this patch
(http://bugzilla.kernel.org/attachment.cgi?id=3D22624).

I have retested the 2.6.31-rc9 kernel with the following patches applied to=
 it:
* patch 4e49627b9bc29a14b393c480e8c979e3bc922ef7
* http://bugzilla.kernel.org/attachment.cgi?id=3D22624
* the patch posted at the start of this thread.

With this combination I did not observe any lockdep complaints.

Bart.
