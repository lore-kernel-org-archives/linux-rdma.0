Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D8244470E
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576113; cv=none; b=AXrOfeuaVKFeWu+OzzW6Gv07Esug/73/33fJKBzk1w7fnLMf7y+RCnGTGmp9Dlpg+pfaghMdlcL2vuXa2TQJxo9l/wlYEZuY3YPQCA7TArH2H+rmSaH6Fd4QlnV1+hog6TGXsxlW2GGPuwpSmxAbPl7zyK+7e9mNT8HevgwgQko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576113; c=relaxed/simple;
	bh=sfRV71BlLyd5mZ1iODYn2/iceAWzAYWFyLz8TbrVoF4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OBge+84o9ASSAs0DBroVJBWOPgKS26XHiqQJYE9VGRfUPlAlYK9NxnUF4KDvt1cBu4GE+PlSAPcB0HUg/Sgxo2d/Aa7eGCID2Tm+c5l1p2hc3jfSXoyOxDKTl7mcORi6gisVhB5u9qzDPHfH4AaYMpCHVV8wj+8I7bxDnv/mV7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJL8XJRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJL8XJRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5404C1F00898;
	Mon, 28 Sep 2026 06:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576101;
	bh=EpQxMonXeWAIyZFa7Ej5RTRqTMjb3wZeOxD1TQwtaQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FJL8XJRxN6ZUoIIKWkRRZfZ4JWZHBzXYsdpl05WU0OAiRyhrDxCqY8jbcbNKKZ9wD
	 5e7N5IZzTG28hHfS9H8MUWNcpBjIYgCyLo/DgN5tHQ0xxO8POMOEjq7jXKfLyAOjBm
	 aV3XBvYCHtHTDPp65sHkpyFYROBAwyGg676VTc5zaNztbvXLLY9vM1+dsSqqLTKOZc
	 sSxfE/nVWSFGEtt67Y5nuLrhp0u6JBRV/ElNBSGJubmwpL5ETKvPgruN/tjUrLyNHm
	 hAJD3DzAIDR34uuc9GQXo0PsdhIUguTyrOMVjPXW3ysNDag1iZs7g+K38pYvRahrO3
	 2kifZjVyRf/SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 07/12] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-8-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:00 +0000
Message-Id: <20260928061501.5404C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> list_del() the node from a stack frame that no longer exists.  Make
> [ ... ]
> what keeps rds_conn_destroy() from being called with the transport
> lock held.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D7

