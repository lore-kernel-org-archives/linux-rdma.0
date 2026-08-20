Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E926341A4F9
	for <linux-rdma@vger.kernel.org>; Thu, 20 Aug 2026 11:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224371; cv=none; b=CWfaRXDSBjnGjUlqGPJNmNDDVLBTh7ap4JcgENSFw+1ENNMujhKjrc4vdl/5lVeVZOzeK5FptuJEldu2AayL3UbOAEeuaY/4g523tU7+l7MsOxGSxfa1aI76IRdi8gU5uhIYVz1XvHE0PqVjvIMVpkv0fRVskXZnxPiDucQ73vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224371; c=relaxed/simple;
	bh=O5ebyv/3F/19CN5xFhTY1DMmQZS+uNrKoNJiW7nmlpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnXiVslU4NcXG9RWCpqaSM0tXAXe49lSITEeDOHPR2SMpR6piFtAqbWADGKwGApAeDWBfcOiQqSINrI5ZKvVuEw3fmf6Xg2Cv+fe+wF7PeI5KG3O59K9Bl2Rq/5gfbXLejj68W5jBYPJwk43BN36ITmoztGJSVETWJicLGyv/7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AaHKyqC+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaHKyqC+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787224367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4riTGmMvWyWZUwFvb7s+tbSTnCFV+PyunZGmJf0aeDU=;
	b=AaHKyqC+II7CZrBXfZIpynyG+crZUYxtZER0Sf/6slQ3DR4ljVJ0zl4MjNFEV+cCOnMtaR
	06eSDWvVCzRE6/bqAoqHMkCNUBmK8X1hplmP9INKq+D1SQl5BumrPuWDfZC9mI5q/IK7M9
	0qDQN4o1pIu+bkuF8d8hoz9IbNoh+kA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-p_o5ZDABO9yyq30PZGmlWA-1; Thu,
 20 Aug 2026 07:12:42 -0400
X-MC-Unique: p_o5ZDABO9yyq30PZGmlWA-1
X-Mimecast-MFC-AGG-ID: p_o5ZDABO9yyq30PZGmlWA_1787224360
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27D11180075E;
	Thu, 20 Aug 2026 11:12:40 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.48.81])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6B3171800348;
	Thu, 20 Aug 2026 11:12:36 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: Chuyf26@linux.alibaba.com
Cc: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] net/smc: release the internal TCP sock on IPPROTO_SMC socket creation failure
Date: Thu, 20 Aug 2026 13:12:29 +0200
Message-ID: <20260820111229.153086-1-pabeni@redhat.com>
In-Reply-To: <20260813060456.b48HqF9m6NTfFXvq_PL9w_Ih493OogqAqxfAHAfU74A@z>
References: <20260813060456.b48HqF9m6NTfFXvq_PL9w_Ih493OogqAqxfAHAfU74A@z>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/
---
net/smc: release the internal TCP sock on IPPROTO_SMC socket creation failure

This adds a .destroy hook to smc_inet_prot and smc_inet6_prot that calls
smc_clcsock_release(), so the internal TCP sock created by
smc_inet_init_sock() is freed when socket creation fails after proto->init
has run.  It also stores NULL into smc->clcsock at the top of
smc_inet_init_sock().

A couple of questions below.

> diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
> index a94084b4a498..b94a19499986 100644
> --- a/net/smc/smc_inet.c
> +++ b/net/smc/smc_inet.c
> @@ -15,13 +15,16 @@
>  
>  #include "smc_inet.h"
>  #include "smc.h"
> +#include "smc_close.h"
>  
>  static int smc_inet_init_sock(struct sock *sk);
> +static void smc_inet_destroy_sock(struct sock *sk);
>  
>  static struct proto smc_inet_prot = {
>  	.name		= "INET_SMC",
>  	.owner		= THIS_MODULE,
>  	.init		= smc_inet_init_sock,
> +	.destroy	= smc_inet_destroy_sock,
>  	.hash		= smc_hash_sk,
>  	.unhash		= smc_unhash_sk,
>  	.release_cb	= smc_release_cb,

[ ... ]

> @@ -109,6 +113,14 @@ static struct inet_protosw smc_inet6_protosw = {
>  static int smc_inet_init_sock(struct sock *sk)
>  {
>  	struct net *net = sock_net(sk);
> +	struct smc_sock *smc = smc_sk(sk);
> +
> +	/*
> +	 * The smc_sock slab is SLAB_TYPESAFE_BY_RCU and recycled objects
> +	 * are not zeroed. .destroy may run even if .init never completed,
> +	 * so make sure smc_clcsock_release() sees a valid clcsock.
> +	 */
> +	smc->clcsock = NULL;

[Severity: Low]
Is the premise of this comment (and of the matching changelog paragraph,
"Also initialize clcsock to NULL when setting the sock up: the smc_sock
slab is SLAB_TYPESAFE_BY_RCU, so recycled objects are not zeroed") correct?

sk_alloc() always adds __GFP_ZERO, and sk_prot_alloc() then clears the
whole protocol object:

net/core/sock.c:sk_alloc() {
	sk = sk_prot_alloc(prot, priority | __GFP_ZERO, family);
	...
}

net/core/sock.c:sk_prot_alloc() {
	sk = kmem_cache_alloc(slab, priority & ~__GFP_ZERO);
	if (!sk)
		return sk;
	if (want_init_on_alloc(priority))
		sk_prot_clear_nulls(sk, prot->obj_size);
	...
}

sk_prot_clear_nulls() memsets everything except sk_node.next, and
smc_sock.clcsock sits well past sk_node, so isn't clcsock already NULL on
entry to .init even for a recycled SLAB_TYPESAFE_BY_RCU object, making this
store dead code?

The second sentence of the comment also seems hard to satisfy: the mutex
that smc_clcsock_release() takes is only initialized later, inside
smc_sk_init():

net/smc/af_smc.c:smc_sk_init() {
	...
	mutex_init(&smc->clcsock_release_lock);
	...
}

So if .destroy really could run before .init completed, wouldn't
smc_clcsock_release() lock an uninitialized mutex regardless of this NULL
store?  Could the comment and changelog paragraph be dropped or reworded to
match what the code actually guarantees?

>  
>  	/* init common smc sock */
>  	smc_sk_init(net, sk, IPPROTO_SMC);
> @@ -116,6 +128,17 @@ static int smc_inet_init_sock(struct sock *sk)
>  	return smc_create_clcsk(net, sk, sk->sk_family);
>  }
>  
> +static void smc_inet_destroy_sock(struct sock *sk)
> +{
> +	/*
> +	 * If inet_create()/inet6_create() fail after .init has created the
> +	 * internal TCP sock (e.g. rejected by a cgroup BPF program),
> +	 * sk_common_release() ends up here. Release the TCP sock, otherwise
> +	 * it leaks on every failed IPPROTO_SMC socket() call.
> +	 */
> +	smc_clcsock_release(smc_sk(sk));
> +}

[Severity: High]
Can this free the internal TCP socket while the SMC sock is still on the
SMC diag hash list?

sk_common_release() runs .destroy before .unhash:

net/core/sock.c:sk_common_release() {
	if (sk->sk_prot->destroy)
		sk->sk_prot->destroy(sk);
	...
	sk->sk_prot->unhash(sk);
	...
}

and the sk was already inserted into smc_v4_hashinfo/smc_v6_hashinfo by
smc_sk_init() -> sk->sk_prot->hash(sk) == smc_hash_sk() before
smc_create_clcsk() ran, so when smc_inet_destroy_sock() calls
smc_clcsock_release() the sock is still visible to the diag dumper.

The reader side walks that same hashinfo holding only the hashinfo rwlock,
and does an unlocked check-then-dereference of smc->clcsock:

net/smc/smc_diag.c:smc_diag_dump_proto() {
	read_lock(&prot->h.smc_hash->lock);
	head = &prot->h.smc_hash->ht;
	...
	sk_for_each(sk, head) {
	...
}

net/smc/smc_diag.c:smc_diag_msg_common_fill() {
	...
	if (!smc->clcsock)
		return;
	r->id.idiag_sport = htons(smc->clcsock->sk->sk_num);
	r->id.idiag_dport = smc->clcsock->sk->sk_dport;
	...
}

while the writer holds only clcsock_release_lock:

net/smc/smc_close.c:smc_clcsock_release() {
	mutex_lock(&smc->clcsock_release_lock);
	if (smc->clcsock) {
		tcp = smc->clcsock;
		smc->clcsock = NULL;
		sock_release(tcp);
	}
	...
}

With an empty lockset intersection, can a concurrent AF_SMC diag dump (for
example "ss --smc", which has no capability check in
smc_diag_handler_dump()) re-read smc->clcsock as NULL after the NULL check
and oops, or dereference the just-released struct socket / tcp_sock and copy
freed memory into the netlink reply?

The existing teardown path unhashes first and only then drops the clcsock:

net/smc/af_smc.c:__smc_release() {
	sk->sk_prot->unhash(sk);

	if (sk->sk_state == SMC_CLOSED) {
		if (smc->clcsock) {
			release_sock(sk);
			smc_clcsock_release(smc);
	...
}

Would it be better to keep that ordering here, for instance by unhashing
before releasing the clcsock in the destroy path, or by taking
clcsock_release_lock in the diag reader?

The lockless clcsock read in smc_diag is itself older than this patch (see
also smc_close_active_abort() and smc_close_passive_work()), but on the
socket-creation-failure path nothing was freed while the sk was hashed
before this change, since the clcsock was simply leaked.

>  
>  int __init smc_inet_init(void)
>  {
>  	int rc;
-- 
This is an AI-generated review.

