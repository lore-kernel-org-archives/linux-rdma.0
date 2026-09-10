Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B4F46AF16
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038243; cv=none; b=TfM+cn2Qmb0dhP/7iC293lrPjnLujgSwCqEwgYB+I5cy/neicIjBXD1Z2GeaRXTalgi9w/QIwAI3Lw91xHv0RCKqpLjzBCIbch/WxQU9dRqD7BJ464Mqxx7OTwlyxfia69XXxyz6iw4PuYWXrqA+UXZtmdC6tJKpZ4M7vp1yDOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038243; c=relaxed/simple;
	bh=E0T+eidJreBcMuELM//lfuMkxL6ag4fAnI2b5MKpiWU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M9IPXVKFMvpm2vWI/oe1Sg3z5k/XWyufvISXqnoNHgsEjBTTHnIaP00jQnxxgoo6wzbqmoWdTrtRsV5/BmEv29GJWaWl/7migaaJC38P+tI4zYfY9UCxfrwf+fTibpXM+9tpUwwKu8NpdnvvfHR65cN0dpvCwjPEghDft4eJu84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b04ATuqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b04ATuqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF261F000FF;
	Thu, 10 Sep 2026 11:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038239;
	bh=fZIlTRPR8mi6rVdjYQ9j7atumwM6xNAi5cdTykCmeqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b04ATuqFMwDXq4EkfPa0E4mel5jd4JCAC4N2SqlQ7/0MYrswiUSq42FoI3jY4CVqO
	 380WL1j3++Jp84Y3d25GftvZFzIPaz8OEgNuAWotd5nJqXrUcHriBRMKBqRYxNt+BZ
	 dUDdThSa83+BjuLBqsBZqH1AZlFQtCJYPjju3UODucRhvhPh1bkMkmIIpkYVseJIQd
	 CNN4pq2rpTq/X8BUXf2X5fu6yZZXW6FLP8wHzqhV3hXWa3q3ye5kMbXY81KmVFAeG5
	 7kkok/jbXRugY0V0wZxiwxC5LL2fYgux0p3Kv/8WccINp3Sv6mv8q3ONQmpN+z4uqt
	 3eoi38UMvjGCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910104906.19681-1-serhatkumral1@gmail.com>
References: <20260910104906.19681-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 11:03:58 +0000
Message-Id: <20260910110358.BDF261F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Asynchronous GID deletion outlives netns teardown, causing a U=
se-After-Free panic and state corruption.
--

commit 2c5402d7d2ec6f9905d17f75a69f7841c9e31efb
Author: Serhat Kumral <serhatkumral1@gmail.com>

RDMA/rxe: drive UDP tunnel socket lifetime from the GID table

This commit keys the lifetime of shared per-netns UDP tunnel sockets off
the GID table instead of driver-side bookkeeping. It implements
add_gid/del_gid to manage the wildcard sockets, keeping the per-netns
state in a global list and removing the pernet storage and hooks.

Closes: https://syzkaller.appspot.com/bug?extid=3D8c9eede336e3a843750e

> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/=
rxe/rxe_net.c
> index 53daaf4c1eb2e..fa1cf49c13e33 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c

[ ... ]

> @@ -288,10 +283,165 @@ static struct socket *rxe_setup_udp_tunnel(struct =
net *net, __be16 port,

[ ... ]

> +int rxe_add_gid(const struct ib_gid_attr *attr, void **context)
> +{

[ ... ]

> +	mutex_unlock(&rxe_ns_lock);
> +
> +	put_net(net);
> +	*context =3D ns;
> +	return 0;

[Severity: Critical]
Is it safe to drop the active netns reference here?

A code comment mentions that passive net references keep the net pointer
valid as a list key until the sockets are released. However, kernel
sockets use passive references precisely so they do not keep the netns
alive. If a user deletes the namespace, the net structure can be freed
while its pointer remains in ns->net.

If a new netns is allocated at the same memory address before the old
GIDs are completely removed, could a concurrent rxe_add_gid() find
this stale rxe_ns_sock entry, leading to state corruption and
cross-namespace socket sharing?

> +
> +out_free:

[ ... ]

> +int rxe_del_gid(const struct ib_gid_attr *attr, void **context)
> +{

[ ... ]

> +	/*
> +	 * Release under the lock: a concurrent rxe_add_gid() must not
> +	 * see a zero count while the old socket still holds the port,
> +	 * or its bind() fails with -EADDRINUSE.
> +	 */
> +	if (sock)
> +		udp_tunnel_sock_release(sock->sk);

[Severity: Critical]
Can this lead to a use-after-free panic when the namespace is torn down?

When a net namespace is deleted, the NETDEV_UNREGISTER event triggers
an asynchronous unregistration of the IB device via ib_unreg_wq.
Because this is asynchronous, the netns teardown can complete and free
the net structure memory before rxe_del_gid() is executed.

When udp_tunnel_sock_release() is eventually called here, the socket
release path (such as udp_lib_unhash) will dereference sock_net(sk).
Since that points to the freed netns memory, won't this cause a
fatal use-after-free panic?

> +
> +	if (!ns->nr4 && !ns->nr6) {
> +		list_del(&ns->node);
> +		kfree(ns);
> +	}
> +	mutex_unlock(&rxe_ns_lock);
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910104906.1968=
1-1-serhatkumral1@gmail.com?part=3D1
