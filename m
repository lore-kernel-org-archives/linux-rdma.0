Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8471F563FC9;
	Tue, 22 Sep 2026 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095676; cv=none; b=aaT7KlpaXJpDVX7RAMyBudZRROoYw808jYn4yYVcOqoDIbprL3Wori7og7foSFlZaTzpT/2dp09FOKPFv25uYxnw/VWNccXL6kXA2+vMD+FjTtik1r9y3POQrNAjs3481DxgbmFCeQVEv28cpwyWvtF6ixxY7PSA+9HpYz7IWnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095676; c=relaxed/simple;
	bh=j/zyiUi/HaBy9yZbFmdGg1pvT/P24dVq0ppaxuIkitw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ta/JJ5MWlZoALsAOFp+TyuO2SKy8Uu/iisxcPTdZHl8cCaRJXtGsxGxRKdrqDbco07d7VS96TufGFofpujv66rjE2VOjpNSGWvFpFuNaaOL7PfBEd8MVO7Z/V0DoUsq0P7JffMtJgwInpXMii7JwedYnyZsbxazLjcfEuNOL23E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dd5LMYN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dd5LMYN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B881F000FF;
	Tue, 22 Sep 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790095664;
	bh=F7YxeenGDTESAAyhlhjH2/13wWtCmeVIKrw0ukbkh7E=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=dd5LMYN88lOa8yeomd+gwnNZwNLiAdvfa0t+fhXZfLL6/kAFSUpS42MrMYcaTVYco
	 sllnZZIyJkYikzj2vhjxhjLLSe/gDAhtmEHBbW0nyQRxiPZCmBMfSNbTuWqxRlD3BP
	 STDEDdcmiYB18dsAXkwJGYR5KsBWu6X7uQLPeLmsBYodlHFsakanbLRpqYHES3wea3
	 C3Se/c8Xk30ErrEgmNuHoV9SRKLYuO7leNGokfdPdaiMo+HzAVmW7egO4lPAXz6uFc
	 f3YHXyoFil8L41jE+SuAuc1Vb7g5aYFh/cheb7YVULI9HJr4QHK5BuWLdUNfnrFLzE
	 srwgH4LKaBimw==
Message-ID: <d61a18374d74c7fca6448692b86e7351bd2ad080.camel@kernel.org>
Subject: Re: [PATCH net-next v6 00/12] net/rds: make connection lifetime
 reference-counted
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Tue, 22 Sep 2026 09:47:43 -0700
In-Reply-To: <20260922164318.447049-1-achender@kernel.org>
References: <20260922164318.447049-1-achender@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-22 at 09:43 -0700, Allison Henderson wrote:
> Hi all,
>=20

Resend of v6 sent by mistake, please ignore the resend.
Apologies for the spam!

Thanks!
Allison

> This is v6 of the connection-lifetime set (v1 at [1], v2 at [2],
> v3 at [3], v4 at [6], v5 at [7]), following
> "net/rds: own the fastpath locks across connection teardown", which is
> in net-next.  It is targeted at net-next: although the series fixes
> real use-after-frees (one syzbot report and one report from Chengfeng
> Ye below), it does so by reworking connection lifetime rather than
> patching the individual crash sites, and that rework is too invasive
> for net.
>=20
> rds_conn_destroy() frees the connection, its paths and its workqueues
> on the spot, relying on the documented assumption that "no one else is
> referencing the connection".  That assumption stopped being true a
> long time ago: connections are destroyed on netns teardown and on a
> protocol-version mismatch as well as on rmmod, while pointers to them
> still live in socket rs_conn caches, congestion-map conn lists, CM
> callbacks and workers, and - for as long as an application leaves data
> unread - in every rds_incoming sitting on a receive queue.  No single
> Fixes: commit covers the rot, so the series carries Reported-by tags
> where there are concrete reports instead.
>=20
>   Patch 1 fixes rds_ib_conn_free() re-enabling interrupts under
>   a caller's irqsave lock.
>=20
>   Patch 2 makes the passive-connection exits of __rds_conn_create()
>   undo conn_alloc() the same way the lost-race exit does, through one
>   helper (a refactor: the passive twin only exists for IB, so nothing
>   leaked there).  Both are first in the series because the
>   reference-counted teardown calls conn_free() from more places.
>=20
>   Patch 3 guards the five work-arming sites that never tested
>   rds_destroy_pending(): two IB completion paths, the IB recv refill,
>   the TCP accept kick and the multipath reconnect in sendmsg.
>=20
>   Patch 4 gives the connection its own destroy-in-progress marker.
>   With f97d8c7bab78 in net-next there is no single-connection destroy
>   left for the old predicate to miss, but the later patches need the
>   precise answer: the IB unload re-sweep hands a connection to
>   rds_conn_destroy() more than once, and the passive-twin creation
>   must refuse a parent whose destroy has begun.
>   Based on UEK commits:
>      e2f5005adf63 net/rds: Add krefs to struct rds_connection
>      https://github.com/oracle/linux-uek/commit/e2f5005adf63
>=20
>      6c53ef92f46e net/rds: Merge uses of conn->c_destroy_in_prog & RDS_DE=
STROY_PENDING
>      https://github.com/oracle/linux-uek/commit/6c53ef92f46e
>=20
>   Patch 5 splits rds_conn_destroy() into a synchronous quiesce and a
>   kref-governed free.
>   Based on UEK commits:
>      2c8569e4c880 ("net/rds: Add krefs to struct rds_connection").
>      https://github.com/oracle/linux-uek/commit/2c8569e4c880
>=20
>   Patch 6 makes each transport's exit path wait for its connections to
>   actually be freed before the module goes away.  The wait is
>   unbounded and warns every ten seconds: a connection reference can be
>   held for an application-controlled time (unread data), so a timeout
>   would only move the use-after-free from freed memory to unloaded
>   module text.  rmmod blocking while data is queued and unread is the
>   historical RDS contract.  For IB the wait re-sweeps the nodev list,
>   since device connections migrate to it asynchronously.
>   Based on UEK commits:
>      ece4b4e39afa ("net/rds: wait_event_timeout until zero connections du=
ring rmmod")
>      https://github.com/oracle/linux-uek/commit/ece4b4e39afa
>=20
>      905ec90e6166 ("net/rds: Each RDS transport should keep its own conne=
ction count")
>      https://github.com/oracle/linux-uek/commit/905ec90e6166
>=20
>   Patch 7 unlinks each transport node before its destroy, so a
>   free deferred past the teardown loop cannot write into the loop's
>   stack-local list head.  IB marks a gathered node as claimed by the
>   sweep, since its connect and shutdown paths move the node too.
>=20
>   Patch 8 hands out real references everywhere a connection pointer
>   previously escaped bare, RCU-annotates parent->c_passive, refuses to
>   revive a passive connection whose destroy has begun, and serializes
>   the SIOCRDSSETTOS check with the rs_conn cache.
>   Based on UEK commits:
>      2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
>      https://github.com/oracle/linux-uek/commit/2c8569e4c880
>=20
>      0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not b=
eing destroyed").
>      https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7
>=20
>   Patch 9 has the quiesce purge cp_send_queue under cp_lock, as every
>   adder to that queue holds it.  No sender can be in flight at any of
>   today's destroy triggers (netns teardown, module unload), so this is
>   hygiene rather than a race fix, and the v5 refusals in the senders
>   that guarded against that impossible state are gone.
>=20
>   Patch 10 pins the connection across the RDMA-CM event handler
>   and rejects a connect request for a connection whose destroy has
>   already quiesced it.
>=20
>   Patch 11 drops the now-unused global rds_conn_count.
>   Based on UEK commits:
>      905ec90e6166 ("net/rds: Each RDS transport should keep its own conne=
ction count").
>      https://github.com/oracle/linux-uek/commit/905ec90e6166
>=20
>   Patch 12 makes struct rds_incoming hold a reference on i_conn, the
>   fix for the KASAN use-after-free Chengfeng Ye reported [4].
>   Based on UEK commits:
>       99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds=
_incoming.i_conn").
>       https://github.com/oracle/linux-uek/commit/99b9a3715419
>=20
> Patches 5, 8, 6 and 12 are ports of the connection kref work Sharath
> Srinivasan did for Oracle UEK, adapted to the upstream code.
>=20
> The series has been validated with the RDS selftests over loopback-TCP
> and RXE-RDMA, plus churn tests that delete network namespaces and
> unload the modules under live rds-stress traffic.
>=20
> Changes since v5 [7]:
>  - Rebased; the version-mismatch destroy is now an rds_conn_drop() in
>    net-next (f97d8c7bab78), so patch 4's Fixes: tag is gone and its
>    changelog describes what still needs the per-connection flag, and
>    the CM-callback deadlock reports against earlier versions no longer
>    apply.
>  - Patch 2: described as the refactor it is (the passive twin is
>    IB-only, single path); Fixes: tag dropped.
>  - Patch 9: reduced to the cp_lock purge; the send-side refusals and
>    the negative *queued signalling are dropped, since no sender can be
>    in flight at a destroy trigger.
>  - Patch 6: wait comment describes the initial-sweep-plus-resweep
>    contract; changelog notes the guarantee is complete only once incs
>    hold references.
>  - Patch 8: c_destroy_in_prog read through rds_destroy_pending() in
>    __rds_conn_create(); the c_passive puts documented as possibly the
>    last; READ_ONCE() on the unlocked rs_tos sample; rs_conn comment
>    notes the rds_release() exception.
>  - Patch 10: stale forward-reference comment fixed.
>=20
> Changes since v4 [6]:
>  - Patch 7: the IB sweep marks each gathered node with a new
>    i_ib_node_detached flag instead of relying on list emptiness.  A
>    node parked on the sweep's stack list is not empty, so a concurrent
>    rds_ib_add_conn() would have unlinked it from under the sweep's
>    lockless walk; rds_ib_add_conn(), rds_ib_remove_conn() and
>    rds_ib_conn_free() now leave a claimed node alone.
>=20
> Changes since v3 [3]:
>  - Rebased; the version-mismatch destroy that patch 10 also had to
>    cope with is now an rds_conn_drop() in net (f97d8c7bab78), and
>    patch 10's changelog says what remains for it to cover.
>  - The uninitialised transport pointer in the CM event handler that
>    the second v2 review pass raised turned out to be the bug Aohan
>    Mei already posted a fix for (v2 at [5], stalled after review); it
>    is carried forward separately for net rather than added here.
>  - Patch 7: the teardown walks take a reference on each gathered
>    connection, so a connection destroyed earlier and freed by a
>    pending holder cannot vanish under the iterator, and the two IB
>    list movers tolerate a node the sweep already unlinked instead of
>    BUG_ON()ing; the nodev sweep gathers entry by entry, so the
>    resweep from the unload wait no longer relies on list_splice_init().
>  - Patch 8: SIOCRDSSETTOS check-then-act closed - the install in
>    rds_sendmsg() re-checks the socket's ToS under rs_lock; rs_conn
>    documented as a referenced, rs_lock-serialised cache; contract
>    comment restored to rds_conn_lookup().
>  - Patch 9: rds_send_probe() gets the same rds_destroy_pending()
>    test under cp_lock as rds_send_queue_rm() (a probe queued after the
>    purge pinned the connection for good).
>  - v3 patch 10 (rds_tcp_accept_one() destroy check) dropped: the check
>    was not serialised against the destroy, and the race it aimed at is
>    not reachable - every TCP destroy path stops the listener, flushing
>    the accept work, first.  A comment now records that ordering.
>  - Changelog and comment corrections from the second v2 review pass
>    (self-requeue exemption in patch 3, c_refcount comment in patch 5,
>    the uninterruptible wait and the transport-text wake in patch 6,
>    "lock-free" wording in patch 11, cross-netns comment in patch 12).
>=20
> Changes since v2 [2]:
>  - New patches 1 and 2: pre-existing rds_ib_conn_free() interrupt
>    state clobber and passive-path transport data leak, surfaced by
>    review of the teardown changes.
>  - Patch 6: rds_ib_destroy_nodev_conns() uses list_splice_init(), so
>    the resweep from the unload wait cannot splice a stale list head.
>  - Patch 8: SIOCRDSGETTOS reads rs_tos under rs_lock like SETTOS.
>  - New patch 9: rds_send_queue_rm() refuses a connection whose destroy
>    has begun, under cp_lock, and the quiesce purges cp_send_queue
>    under cp_lock (list corruption against an in-flight sender, and a
>    message that would pin the connection forever).
>  - New patch 10: rds_tcp_accept_one() does not install a socket on a
>    connection whose destroy has begun (socket left pointing at a freed
>    path).
>=20
> Changes since v1 [1]:
>  - New patch 1: guard the five work-arming sites that never tested
>    rds_destroy_pending(); patch 2's changelog and comments narrowed
>    to what it actually newly covers.
>  - Patch 4 moved ahead of the reference holders, so no bisect point
>    has references without the unload wait; wait made unbounded with a
>    periodic warning instead of a 10 s timeout; IB exit re-sweeps the
>    nodev list for connections that detach from their device late.
>  - New patch 5: transport nodes unlinked before destroy (stack list
>    head use-after-free from a deferred conn_free).
>  - Patch 6: c_passive RCU-annotated; a destroyed passive child is
>    refused by __rds_conn_create() and clears the parent's pointer
>    itself; SIOCRDSSETTOS uses rs_lock; lookup comment reworded;
>    explicit not-for-stable note.
>  - New patch 7: reference across the CM event handler, and a
>    destroy-pending re-check in rds_ib_cm_handle_connect().
>  - Patch 9: changelog states what a lingering inc keeps alive and
>    that it blocks module unload.
>  - Changelog corrections throughout (netns teardown paths named as the
>    non-rmmod destroyers, stale rds_conn_path_destroy() reference).
>=20
> [1] https://lore.kernel.org/netdev/20260904070248.160384-1-achender@kerne=
l.org/
> [2] https://lore.kernel.org/netdev/20260912035027.27447-1-achender@kernel=
.org/
> [3] https://lore.kernel.org/netdev/20260914033719.138057-1-achender@kerne=
l.org/
> [4] https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@g=
mail.com/
> [5] https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794=
@gmail.com/
> [6] https://lore.kernel.org/netdev/20260917073958.174056-1-achender@kerne=
l.org/
> [7] https://lore.kernel.org/netdev/20260919061149.250658-1-achender@kerne=
l.org/
>=20
> Allison
>=20
>=20
> Allison Henderson (8):
>   net/rds: ib: don't enable interrupts in rds_ib_conn_free()
>   net/rds: free every path's transport data on the passive create paths
>   net/rds: guard every work-requeueing site with rds_destroy_pending()
>   net/rds: make rds_destroy_pending() report a connection's own destroy
>   net/rds: unlink transport nodes before a possibly deferred connection
>     free
>   net/rds: take cp_lock to purge cp_send_queue in the quiesce
>   net/rds: pin the connection across RDMA-CM event handling
>   net/rds: drop rds_conn_count in favor of t_conn_count
>=20
> Sharath Srinivasan (4):
>   net/rds: split connection destroy into quiesce and kref-governed free
>   net/rds: wait for connections to be freed on transport unload
>   net/rds: hold connection references in lookup, sockets and c_passive
>   net/rds: hold a connection reference from struct rds_incoming
>=20
>  net/rds/af_rds.c         |  24 ++-
>  net/rds/connection.c     | 330 +++++++++++++++++++++++++++++++++------
>  net/rds/ib.c             |  22 ++-
>  net/rds/ib.h             |   4 +
>  net/rds/ib_cm.c          |  29 +++-
>  net/rds/ib_rdma.c        |  67 ++++++--
>  net/rds/ib_recv.c        |   6 +-
>  net/rds/ib_send.c        |  18 ++-
>  net/rds/loop.c           |  61 ++++++--
>  net/rds/message.c        |  16 +-
>  net/rds/rdma_transport.c |  16 +-
>  net/rds/rds.h            |  46 +++++-
>  net/rds/recv.c           |  26 ++-
>  net/rds/send.c           |  68 +++++++-
>  net/rds/tcp.c            |  53 ++++++-
>  net/rds/tcp_listen.c     |  21 ++-
>  16 files changed, 690 insertions(+), 117 deletions(-)
>=20

