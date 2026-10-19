Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C272945349C
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383925; cv=none; b=JjYM5X5JHQ0r0JQUXy/ejFDHBttQyniyhIczW+ZiZtZ8Y+lnHyHOwCgDSk4jyGPkO2YZcL9CTLOtCwmASOMmcs7XLmB95GsGZ6QC4yKiLOCYBvGVx2Z/3Nrb7YlNtsbM5KaAH8RbOQ9dpX1h6C9WVbaYp2FRUGzHCzLSxhuCrMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383925; c=relaxed/simple;
	bh=OCUWKGT7AZkyog+r+usBNuADixx7/vpE+rViFHumn4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOdw6tqwEbER2c1hMohhIkK8JupzQFaBdxqj96aVCd/cJmKZfebCjdvR3fvner3olnB8tQpLdLt1a9mluXis67KZuTy/1y2P+n/AU353cbeWipgtGJkkiSOKZraaM/rB1zS5aRsOJEnnKRJ3NEteZAXKKx9q9+5iDMq+MRJ3+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HXXXFaEs; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HXXXFaEs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Aw
	2B94AIp/fE5PYbhVFZfzwqsmQ5VZUsTfV4vLq9MS4=; b=HXXXFaEsjiID70vIwa
	R+GMzpfGQy1Ch+l5tf9IF3A/g4k2wuX/lB4S2KX1XG69J3g05ETIk28TF7dabTjJ
	Q4Erkpj2CsyjqWX50uEIq5DBc9qAIe9109mKv4Oe71m7Y8iUFKmKBDTrxW6XQG1d
	tWpBdYSiWCCWRnqpm1FuRP4Q4=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDnrxV8m9VqGji1BA--.16122S2;
	Mon, 19 Oct 2026 12:24:29 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: sashiko-reviews@lists.linux.dev,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org,
	yanjun.zhu@linux.dev
Subject: Re:Re: [PATCH v2] RDMA/rxe: unpublish the per-net tunnel socket 
Date: Mon, 19 Oct 2026 12:24:28 +0800
Message-ID: <20261019042428.465664-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019023717.455067-1-18983559317@163.com>
References: <20261019023717.455067-1-18983559317@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnrxV8m9VqGji1BA--.16122S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxurW8ZFW8uF4xXFWDXF48Crg_yoW5Zryfpr
	WFgFWUtrWDtrs2ywn7ta1xuF1fAFZYkFy3GFykKry3Aws8uw1ayFWftr1Fvan5Cr4kK34j
	vFn0k3ykuasxZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFD73UUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4B0W+WrVm32jFAAA38

Hi,

Thanks for the review.  I verified both findings against the code and
they are correct.  Details below; a v3 that fixes the use-after-free
follows.

1. [Critical] residual use-after-free via the unpinned tunnel socket

You are right, v2 does not close this one.  Confirmed in code:

- rxe_ns_pernet_sk6() drops rcu_read_unlock() before returning the
  raw sk pointer, without taking a reference;
- rxe_find_route6() passes that pointer to ip6_dst_lookup_flow() in
  the rxe_sender() workqueue context, outside any RCU read-side
  critical section: ip6_route_output_flags() reads sk->sk_bound_dev_if
  and inet6_sk(sk)->srcprefs, and xfrm_lookup_with_ifid() reads
  sk->sk_policy[XFRM_POLICY_OUT];
- therefore neither the synchronize_rcu() in rxe_ns_pernet_set_sk6()
  nor the one inside udp_tunnel_sock_release() can protect a reader
  that already fetched the pointer.  After v2 only new lookups are
  protected (they see NULL, which ip6_dst_lookup_flow() handles).

What v2 does fix is the failure mode KASAN reported: with the
original ordering the per-net pointer stayed published while
udp_tunnel_sock_release() ran and until set_sk(net, NULL) completed
its grace period, so any new lookup in that window fetched an
already-freed socket.  The window for in-flight readers that had
fetched sk before the unpublish remained, as you describe.

The complete fix is to pin the socket.  v3 takes a reference on it
in rxe_ns_pernet_sk4/6() with refcount_inc_not_zero() under
rcu_read_lock() and the callers sock_put() it after use.  Extending
the RCU read-side critical section across the lookup is not an
option because xfrm_lookup_route() may sleep.

2. [High] races with rxe_net_init() / unsynchronized refcount check

Both points are valid.  They pre-date v2 (they come with
f1327abd6abe "RDMA/rxe: Support RDMA link creation and destruction
per net namespace") and are not introduced by it:

- nldev_newlink() is serialized only by link_ops_rwsem, while
  nldev_dellink() uses nldev_dellink_mutex, and the NETDEV_UNREGISTER
  path in rxe_notify() takes neither: rxe_net_init() could observe
  the just-cleared pointer and fail binding ROCE_V2_UDP_DPORT with
  -EADDRINUSE, or sock_hold() a socket that was concurrently being
  released.  With v3 rxe_net_ipv4/6_init() acquire the socket through
  the pinned getter, so they can no longer resurrect a socket that
  is being released; the -EADDRINUSE window itself remains.

- The refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL check was
  indeed TOCTOU, and two concurrent rxe_net_del() callers ("rdma link
  del" racing NETDEV_UNREGISTER of the underlying netdev) could both
  release the tunnel.

Since these races exist in the code that v2 and v3 fix and are
separate from the use-after-free at hand, I kept v3 minimal and
scoped to the socket lifetime fix; I plan to send a follow-up
series with proper locking and per-device reference accounting for
them.

The KASAN report from v2 is kept unchanged in the v3 commit message.
v3 also fixes the truncated subject line of v2 ("...before") and
drops the Reviewed-by tag since the patch changed.

pw-bot: cr

