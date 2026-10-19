Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4361E7C23
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383055; cv=none; b=WCmwX+9oggpyRj+/PK0Z2ncpDUsoAsUVCs6M9y+E5qp3Mhj7+nw96xYmFGCMuiFbAsmSmGPr2Hw5wLrnE9yzlxbbYt2dw/jNRAy8glnbk/e/LRHq7Xl84xAX8fFu079or6l3dt/LsgFlCv3H/dadNV20Anybpj6jZz4tcI+Fu+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383055; c=relaxed/simple;
	bh=dbGaGWlUvGTnSw/cOsAveAXk4OBbDrXFZouBzyoETRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac9Sv3BZmMkiAYqX/hKHRogWPkTQ8HfDO77RFx3Rob7vkMUQKpJuasrXkPE6icvidiUBAzKsTXb17XiS9rwihPeDuMNJEJc8dHmxfGHFUuXt2nZDh4x+25zyC2ZplcGjQBV3VQb/D+vGlMwf3yQ/Z1w0R9WFjqSLcxMQDRhptd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=W79NGkrn; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="W79NGkrn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=bj
	xhhfbWXOOzUAWwH7pIj7Je30y2dzXsiwo8fgJ0B/Y=; b=W79NGkrnwCkDHdHjvH
	A9nAHCLKOphhnIdiHQWszaAazbgTrE7DIw+yllU2+lqzwmYiG3EvZ6NAF+WAxFc5
	Lr5Z0C848kaA6/cgZ2n1aYTqG94OYMYUfONV2fvHH0DgvaevpmqGQzt3ylPsMFdy
	wtvmYSdoTyttmOJkC1yjDkdN0=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3n4cpmNVq2YaJAw--.16525S2;
	Mon, 19 Oct 2026 12:10:17 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: sashiko-reviews@lists.linux.dev,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org,
	yanjun.zhu@linux.dev
Subject: Re:Re: [PATCH v2] RDMA/rxe: unpublish the per-net tunnel socket 
Date: Mon, 19 Oct 2026 12:10:16 +0800
Message-ID: <20261019041016.463989-1-18983559317@163.com>
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
X-CM-TRANSID:_____wD3n4cpmNVq2YaJAw--.16525S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxurW8AF1UtF4ftrW3Ar4DCFg_yoW5Zr4Dpr
	WSgFWUtr4DKr1Syw1IvF4xZF1fAa9YkFy5GFykKr9rCws8u34ayFWSqr1Fka98Cr4kG3Wj
	vrn8Cws7ua98ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFD73UUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4AlAJGrVmClyawAA3a

Hi,

Thanks for the review.  I verified both findings against the code and
they are correct.  Details below; a v3 that addresses them follows.

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
per net namespace"), but v3 addresses them as well:

- nldev_newlink() is serialized only by link_ops_rwsem, while
  nldev_dellink() uses nldev_dellink_mutex, and the NETDEV_UNREGISTER
  path in rxe_notify() takes neither: rxe_net_init() could observe
  the just-cleared pointer and fail binding ROCE_V2_UDP_DPORT with
  -EADDRINUSE, or sock_hold() a socket that was concurrently being
  released.  v3 serializes rxe_net_init(), rxe_net_del() and
  rxe_ns_exit() with a new rxe_ns_lock.

- The refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL check was
  indeed TOCTOU, and two concurrent rxe_net_del() callers ("rdma link
  del" racing NETDEV_UNREGISTER of the underlying netdev) could both
  release the tunnel.  v3 replaces the heuristic with explicit
  accounting: the per-net pointer owns a publish reference, every
  device holds its own reference (the creating device previously
  never took one, so removing either of two rxe devices in one netns
  tore the tunnel down underneath the other), and the two
  rxe_net_del() callers of one device are deduplicated.

The KASAN report from v2 is kept unchanged in the v3 commit message.
v3 also fixes the truncated subject line of v2 ("...before") and
drops the Reviewed-by tag since the patch changed.

pw-bot: cr

