Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B14B355049;
	Thu, 10 Sep 2026 22:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081088; cv=none; b=LuBN0dl4hJn0o6W+eWHevob+QDUQzku0JpnRWDC+y+xaVzpse+u2OgTi601oyhVVjcAF/EVaTRNn6q2QL3hQ+4qk22O2MSJORGJ8vExiZiO6Jd8lmq2yoK9c9j8IGKdyBM6778yb3qI+nd4iS6AewRU/0JHd+QaJlGwy4zVw3VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081088; c=relaxed/simple;
	bh=/9T4lP7odycPErrV9B9fPbzZa+lV+jFodiifhB445Xw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rSSXGzoUK7ROdspXX/vWNufK3Fv9RXHQLK+KGlEHz5E0EH7q9bGK6U8jqeEOevPFX4aQ6WNe0qPoE/92d1G3SANG9DVpNln35tRO8j+Rdf5KHabwC4Ha4ZgSxGvnRY0QwhFgmEdhTVbWzjNq2RZ5e0WqiDK/d7BwAinnrMM9FPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itiLJ2EY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itiLJ2EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9DF1F000FF;
	Thu, 10 Sep 2026 22:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789081085;
	bh=sQ6x/k1wDKwsXpUfg2/qVSXIi+v2mKe76dRQ9lTpK38=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=itiLJ2EYXsX9JjF0rSbAky8sfubkSsLHfeYhBXljp3JkYlgTKTSFvJMH8tO4tWQwl
	 iFk/fkhuUIVr3efweckyofCd+hC4ZmetpTfyM2FzcssXjtY5tx/NK/u76ho0j9gtfU
	 t5+MndRNhvXcoWOHbxPCRGpn8JC5epxHdjRU5480eJ/tmqoOI2vXjIsQtdNHwpkZ6D
	 F8vdw31R7JlzkyLaf0vVCm3x1XXgRJQOEkXa/40HzPPD7gOpLn3vcQCn01hsgLNUkA
	 iY/UKky/JJVyTNWqAL1VgK9/mS27eznX70+Z6W0R1WmiNhncqWDuFApuhN19PMAU3C
	 dOdwPLz+GbI+Q==
Message-ID: <06792614227360acd42d62693d0af78d0f9e947e.camel@kernel.org>
Subject: Re: [rds-devel] [External] : Re: [PATCH net] rds: ib: use
 rds_conn_drop() on protocol version mismatch
From: Allison Henderson <achender@kernel.org>
To: Gerd Rausch <gerd.rausch@oracle.com>, henrymei
 <ljp1205831794@gmail.com>,  netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	santosh.shilimkar@oracle.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, Aohan Mei
	 <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, 
	stable@vger.kernel.org
Date: Thu, 10 Sep 2026 15:58:04 -0700
In-Reply-To: <a4b5d873-4746-4e36-ae15-c45957459fb4@oracle.com>
References: <20260908123356.1163970-1-henrymei@tencent.com>
	 <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
	 <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
	 <2338b4729960abdf0c753d39cb3b7056421bac18.camel@kernel.org>
	 <a4b5d873-4746-4e36-ae15-c45957459fb4@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-09-10 at 10:08 -0700, Gerd Rausch wrote:
> Hi Allison,
>=20
> On 2026-09-09 15:55, Allison Henderson wrote:
> > On Wed, 2026-09-09 at 10:25 -0700, Gerd Rausch wrote:
> > > On 2026-09-09 00:09, Allison Henderson via rds-devel wrote:
> > > I don't get this.
> > >=20
> > > So RDS should just keep on retrying to connect every second instead
> > > of giving up on that incompatible peer? Forever?
> > >=20
> > > The version number the peer uses remains the same until it gets upgra=
ded somehow.
> >=20
> > Hi Gerd,
> >=20
> > You're right that this ends up as a ~1s retry loop.  While that may
> > not be pretty, I think it's still the right call for a net/stable
> > fix, for a few reasons.
> >=20
> > First, it's already what we do for the same condition in the other
> > direction.  When the passive side rejects us with RDS_RDMA_REJ_INCOMPAT=
,
> > the REJECTED case in rds_rdma_cm_event_handler_cmn() calls
> > rds_conn_drop(), we reconnect with the usual backoff (capped at
> > rds_sysctl_reconnect_max_jiffies, one second), and we log a pr_warn
> > on every attempt.  That's the common direction, a new node talking to
> > an old one.  Aohan's patch just makes the rare direction behave the
> > same way instead of wedging.
> >=20
>=20
> The important difference is that when this happens, and the client
> sees a RDS_RDMA_REJ_INCOMPAT from the peer, it'll downgrade to
> RDS_PROTOCOL_COMPAT_VERSION (3.1):
> An older version expected to be understood by all RDS modules.
>=20
> And thus the connection will be retried with version 3.1,
> and is expected to be accepted by the peer:
>=20
> Function rds_ib_cm_connect_complete() explicitly exempts
> RDS_PROTOCOL_COMPAT_VERSION from the rds_conn_destroy() treatment,
> but allows the connection to proceed.
>=20
> So it is not the same way at all.
>=20
> Before this patch, a version 3.1 connection is expected to be established=
.
> After this patch, there's an infinite connection retry attempt every seco=
nd,
> that'll never succeed.

Hi Gerd,

I think we might be talking about different branches of code?  It
looks like the downgrade you're describing is in the REJECTED case of
rds_rdma_cm_event_handler_cmn().  But this patch doesn't touch that.
The 3.1 exemption in rds_ib_cm_connect_complete() is a few lines above
the one being changed, and it isn't touched either.  So a 3.1 connection
should proceed exactly as before.
 =20
The changes here are only reached in the RDMA_CM_EVENT_ESTABLISHED case,
after the peer has already accepted, and only when the version it accepted
with is below 3.1. IOW: that is specifically a peer that answered our
3.1 proposal with 3.0.  Or an accept that carried no (or truncated)
private data, which leaves c_version at 0 on a fresh conn. =C2=A0

There is no fallback for that case before or after the patch. 3.1 is the
compat floor, so there's nothing lower to fall back to.  Before
the patch, that branch calls rds_conn_destroy() under c_cm_lock and
deadlocks against rds_conn_shutdown().  Which then stalls every RDS
connection on the node.  After the patch it drops the conn and
retries with backoff. =C2=A0Neither case establishes a connection, and neit=
her
was ever going to.

>=20
> > Second, rds_conn_destroy() doesn't actually give up on the peer either.
> > Nothing in RDS remembers that a peer is incompatible.  Destroy frees
> > the conn, and the next rds_sendmsg() to that address either reuses the
> > socket's cached rs->rs_conn or goesthrough rds_conn_create_outgoing()
> > and rds_conn_connect_if_down() and then connects again.  With an
> > application actively sending, that's a create/connect/mismatch/destroy
> > cycle at the application level.  With an idle application the only
> > difference from the drop is whether the retry is timer-driven or
> > send-driven.  Deferring the destroy to a worker doesn't change that
> > picture, it just avoids the deadlock.
> >=20
>=20
> I can't follow.
> Are you suggesting to ban an IP-address / peer for life?
>=20
> A node can always retry an RDS connect, triggered by a sendmsg().
> Much like a failed TCP connect() doesn't ban a peer for life.

No, quite the opposite, apologies if that was unclear.  The point I
was trying to make is that rds_conn_destroy() doesn't "give up" on the
peer either. It frees the conn, and then next sendmsg() recreates it and
connects again.  So the choice here was never "give up" versus "retry".=C2=
=A0
It is "retry on the next send" versus "retry on a timer", and the former
also comes with a dead lock.

>=20
> There's a big difference between an application trying to send data again=
,
> and the RDS module itself spinning around every second and re-trying
> a connect with a version# that is known to be incompatible,
> and thus never succeeding, because the fallback mechanism became broken.
>=20

Agreed, but that would be the net-next follow-up I suggested: mark the
conn when the peer turns out to be incompatible, have rds_conn_shutdown()
skip the timer-driven rds_queue_reconnect() for it, and let
rds_conn_connect_if_down() from the next sendmsg() be the retry.
That gives you the TCP-like behaviour you describe.=C2=A0I just don't think=
 it
should gate a one-line stable fix for a dead lock.

> >=20
> > >=20
> > > I understand how the rds_conn_destroy() path is full of bugs.
> > >=20
> > > But shouldn't that just mean those bugs ought to be fixed,
> >=20
> > While that code path does have bugs, making rds_conn_destroy()
> > safe to call from the CM path is a much bigger change, and one that
> > should probably go through net-next rather than holding up a small
> > fix like this.  The current code hangs every RDS connection on the
> > node the first time this fires, and a one second retry on one conn is
> > strictly better than that.
> >=20
>=20
> It is not only the infinite retry every second that's of concern:
>=20
> This change also implies that all RDS kernel modules speak
> the exact same protocol version.
> I don't see how that assumption can ever be valid.
>=20
> Because after this change, if versions differ, there's no fallback to 3.1=
,
> but connections won't ever get established.

The version negotiation looks unchanged to me.  The passive side still
picks the highest common minor from dp_protocol_minor_mask, or 3.1 for
a 3.1 peer, or rejects with RDS_RDMA_REJ_INCOMPAT.  And the active side
still lowers c_proposed_version to RDS_PROTOCOL_COMPAT_VERSION on that
reject.  The changed line only runs when negotiation has already
produced a result below 3.1, which no fallback can rescue.

FWIW, upstream currently defines both RDS_PROTOCOL_VERSION and
RDS_PROTOCOL_COMPAT_VERSION as 3.1.  And the active side proposes
c_proposed_version, which starts at RDS_PROTOCOL_VERSION.  So, that
means upstream always proposes 3.1.  The downgrade in the REJECTED case
is basically a no-op there.  And an INCOMPAT reject already results in
the once-a-second retry you're describing.  That's what I meant by the
other direction behaving the same way, and it's another reason the "retry
only on send" change is better done once, for both paths, as a follow-up.

I hope that helps?  Let me know if anything is unclear or if you think
I've missed something.

Thank you,
Allison


>=20
> Thanks,
>=20
>    Gerd
>=20

