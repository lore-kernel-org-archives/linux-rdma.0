Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD39449BD6D;
	Wed,  9 Sep 2026 22:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788994523; cv=none; b=LaADddVTuzx9FzR6/rptMjxjreIZ5pqyGQTUZv6jOGxv87/8XNzimGJEmrqkHxyscBgZOn6FK5ABJqrcExKZXDDraCmPWhjcu0ScU0QYogy5bKWLuL3AMB73UWdCqwSb0YPzUDIpolzLp/gns8AgckZ8seakT2ec1g90mrZnpyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788994523; c=relaxed/simple;
	bh=J2728F4foT8Qc+xgSemhOh57i62t9cihVg1iZPKFuxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VBAKzM0LCJ0kD5And7HTu4jbAhtX8utKFaYaQZLHzDJRugD5ZKo4jagpjcDPiaspvXizoDhPxOddg+XSXg5T3Y4JKaGyAF5OpRmKUOjHWEg+6/0N6NwCfYS/OI8mZ8gXnl3ZdjdE6Y9P8jwkCgw5Aq3eAfGaL16OgSikYIe+82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLQfoO+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLQfoO+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9E51F00893;
	Wed,  9 Sep 2026 22:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788994507;
	bh=2TZdWTY90rywMETvvm5EfpEqXvpvgxXVuMDFvw5wwhY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PLQfoO+KQGf4wyatV55b3IQnDxBzeRIye175psfhuv55euch4eeaHIQlWVfL8XxSM
	 y3zjQ8hyTzMM4y2MgpWL5fev6dkxxNmx/5kW6nNqdh4nXe93uzrZcmjd9dLo3d4fQu
	 lZieG4z+43F27CxyQ5rYPYF+UYvnsQbqKuIFMOMCFOhf5aBtJiaAJEOjqPURMEefDZ
	 KronESeXU3Ukudbs9UaOdeQqk7GEct0t5D1mDG6XJAeVUMCdUMMuPgmJJSHDLOH6fZ
	 vxzP2Je2MbP3r1AA0bEjAcNjGLlKjyIjcvqF0vADhJu+bP2rBpNseYA8gIjZDzz+eh
	 qwcQG1KUa1XyQ==
Message-ID: <2338b4729960abdf0c753d39cb3b7056421bac18.camel@kernel.org>
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
Date: Wed, 09 Sep 2026 15:55:05 -0700
In-Reply-To: <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
References: <20260908123356.1163970-1-henrymei@tencent.com>
	 <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
	 <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-09 at 10:25 -0700, Gerd Rausch wrote:
> Hi,
>=20
> On 2026-09-09 00:09, Allison Henderson via rds-devel wrote:
> > On Tue, 2026-09-08 at 20:=E2=80=8A33 +0800, henrymei wrote: > From: Aoh=
an Mei <henrymei@=E2=80=8Atencent.=E2=80=8Acom> > > rds_ib_cm_connect_compl=
ete() runs from the RDMA-CM event handler with > conn->c_cm_lock held. When=
 the peer negotiates a protocol
> > On Tue, 2026-09-08 at 20:33 +0800, henrymei wrote:
> > > From: Aohan Mei <henrymei@tencent.com>
> > >=20
> > > rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
> > > conn->c_cm_lock held.  When the peer negotiates a protocol version
> > > older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
> > > rds_conn_destroy(), which is only safe in the rmmod path: it
> > > synchronously tears the connection down and flush_work()es the
> > > shutdown work cp_down_w.
> > >=20
> > > That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
> > > the very lock the event handler still holds, so the flush never
> > > completes: the two workers wait on each other and the RDS connection
> > > workqueues stall for good.
> > >=20
> > > All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
> > > DISCONNECTED) use rds_conn_drop(), which marks the connection
> > > RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
> > > it here as well.
> > >=20
>=20
> I don't get this.
>=20
> So RDS should just keep on retrying to connect every second instead
> of giving up on that incompatible peer? Forever?
>=20
> The version number the peer uses remains the same until it gets upgraded =
somehow.

Hi Gerd,

You're right that this ends up as a ~1s retry loop.  While that may
not be pretty, I think it's still the right call for a net/stable
fix, for a few reasons.

First, it's already what we do for the same condition in the other
direction.  When the passive side rejects us with RDS_RDMA_REJ_INCOMPAT,
the REJECTED case in rds_rdma_cm_event_handler_cmn() calls
rds_conn_drop(), we reconnect with the usual backoff (capped at
rds_sysctl_reconnect_max_jiffies, one second), and we log a pr_warn
on every attempt.  That's the common direction, a new node talking to
an old one.  Aohan's patch just makes the rare direction behave the
same way instead of wedging.

Second, rds_conn_destroy() doesn't actually give up on the peer either.
Nothing in RDS remembers that a peer is incompatible.  Destroy frees
the conn, and the next rds_sendmsg() to that address either reuses the
socket's cached rs->rs_conn or goesthrough rds_conn_create_outgoing()
and rds_conn_connect_if_down() and then connects again.  With an
application actively sending, that's a create/connect/mismatch/destroy
cycle at the application level.  With an idle application the only
difference from the drop is whether the retry is timer-driven or
send-driven.  Deferring the destroy to a worker doesn't change that
picture, it just avoids the deadlock.


>=20
> I understand how the rds_conn_destroy() path is full of bugs.
>=20
> But shouldn't that just mean those bugs ought to be fixed,

While that code path does have bugs, making rds_conn_destroy()
safe to call from the CM path is a much bigger change, and one that
should probably go through net-next rather than holding up a small
fix like this.  The current code hangs every RDS connection on the
node the first time this fires, and a one second retry on one conn is
strictly better than that.

> instead of no longer retiring any connection ever,
> even to old & incompatible peers we can't really talk to?
>=20
> Thanks,
>=20
>    Gerd
>=20

I do think there's potential for a good follow-up in what you're
describing through. A separate patch could fix both directions at
once: a per-conn flag set from the REJ_INCOMPAT case and from this one
that makes rds_conn_shutdown() skip the timer-driven rds_queue_reconnect().
Then the conn would then sit in RDS_CONN_DOWN until a socket actually sends
to it.  At which point rds_conn_connect_if_down() gives the peer another
chance in case it was upgraded.  That also gets rid of the once-a-second
log line, which we have today on the REJECTED side too.  That seems like
net-next material to me rather than something to hold this fix on, but
I'd be happy to review it.

I also think it's worth pointing out which peers this actually affects.
Upstream has RDS_PROTOCOL_VERSION and RDS_PROTOCOL_COMPAT_VERSION both
at 3.1.  So this branch only fires for a 3.0 peer (OFED 1.3 era) or for
an accept that carries no or truncated private data.  That would leave
c_version at 0 on a fresh conn.  In practice that's a broken or non-RDS
peer on the RDS port, not a cluster of un-upgraded nodes. So retrying
those on a backoff like any other unreachable peer seems appropriate.

Thanks,
Allison   =20

> > > Fixes: cdc306a5c9cd ("rds: make v3.1 as compat version")
> >=20
> > Hi Aohan,
> >=20
> > Thanks for the catch, this looks correct to me.  Just one nit on the
> > fixes tag.  I think we want: f147dd9ecabf ("RDS/IB: Disallow connection=
s
> > less than RDS 3.1").  That looks like the commit that added the
> > rds_conn_destroy() call to the version check.  Other than that, I think
> > this patch looks good.  With the Fixes tag corrected, you can add my rv=
b:
> >=20
> > Reviewed-by: Allison Henderson <achender@kernel.org>
> >=20
> > Thanks!
> > Allison
> >=20
> > > Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> > > Cc: stable@vger.kernel.org
> > > Assisted-by: CodeBuddy:Kimi-K3
> > > Signed-off-by: Aohan Mei <henrymei@tencent.com>
> > > ---
> > >  net/rds/ib_cm.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> > > index d46146887ba4..2909da8363f3 100644
> > > --- a/net/rds/ib_cm.c
> > > +++ b/net/rds/ib_cm.c
> > > @@ -115,7 +115,7 @@ void rds_ib_cm_connect_complete(struct rds_connec=
tion *conn, struct rdma_cm_even
> > >  				  &conn->c_laddr, &conn->c_faddr,
> > >  				  RDS_PROTOCOL_MAJOR(conn->c_version),
> > >  				  RDS_PROTOCOL_MINOR(conn->c_version));
> > > -			rds_conn_destroy(conn);
> > > +			rds_conn_drop(conn);
> > >  			return;
> > >  		}
> > >  	}
> >=20
> >=20
> > _______________________________________________
> > rds-devel mailing list
> > rds-devel@oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/rds-devel
> >=20

