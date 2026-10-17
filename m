Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C903CDBA5
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208297; cv=none; b=IaPmzTdeMPgvuOdoQXWSlDDl9KJjccNYl4+gD0ybI/Rp4Zc7nCRZcUIxC8XLg7h38uPYVqbp8z4vsyS3rO4cZW6JjgUjGY8sXssljq6ClOAw1MiQEBGTZjPnVSiZp2tntoGjTFbF0poy32EoABbQEJrgc39n1BEFUZb4fkysZkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208297; c=relaxed/simple;
	bh=y07/IYY9FkyzOseCZjuIJH5Px2WmiwZMSmyuiXl7Yac=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=A4vbbQ5aXle3LNbc+2vpTpHu5eJi0HPo3dS5e5QBNUolqvhTCYNJju3wM+yuEjVYR3p1+/G41wNg0a/9DdkV04ZhOxQ25i47YwnUmNxLjwm8wKO6Zzpa/BhSKpDNFNN0tvs4blMjuPYgVAJSas7D8ko9eaCzL5RNN3AXxGIBgxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3YaYnTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3YaYnTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1351F000C5;
	Sat, 17 Oct 2026 03:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208296;
	bh=WfYWtrdEb3kygWHp8Qkm29Rv2k25p1kFQTmUKqOT0rI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Q3YaYnTcVdQ/XMMtLHJ04a0ZrARnC8jcfPViYMF7wdxZKg3WxWvGnqKHKXjtnAJrR
	 j3uDjABpC1wvlzooF4kESLLtkGUjW2B/lEUfVehfBtB0u+SzX4BYoeKTJmIGGDfgzz
	 mhKSifsGgEMn26Y6xqS6Kh/mVfPPc3Yg92i9CWKvr0ooVPXNv/tZT8UNOWLD/sOxPr
	 48DHOjEEI6K5rR+8mfo6B/bM3D3Mj0BE7Dk8fgh9+VWYYABDNLdSDUi8mvoqQ4kI80
	 hhW0dCQeC054hrK2JT2Mrh/AIEMsiij61hAzHUB4Ej4Z6zqji4D8FoIGP7VZuXJSRj
	 O6L2Pqx3RxfLg==
Message-ID: <sashiko-outbox-175259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 07/13] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-8-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:16 +0000
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
> rds_tcp_conn_free() skips a node that rds_tcp_kill_sock() marked
> detached, while rds_loop_conn_free() and rds_ib_conn_free() list_del()
> it unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> [ ... ]
>=20
> Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueu=
e")
> Cc: <stable+noautosel@kernel.org> # depends on the connection reference c=
ounting earlier in this series
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D7

