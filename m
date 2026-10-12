Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC7539CD1F;
	Mon, 12 Oct 2026 04:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791778670; cv=none; b=Txp6w1k8O3ArFUGl8Fm9vOwy9J5TUnrLPU2vgcI4bep1Lt+ciCSAXq+btBOeAB+4MSZMbURo3vWCnN5x2opB59tGa76QfmZzKciuCVF4H2utTv6JSOprS1h15qcBzzIi2cPfAS9gxw5l8KOJaWAc20pS/kVbZcbrkjKLSn8MDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791778670; c=relaxed/simple;
	bh=x/0mpzGNEyDUMM2Z/07Q3LGWJAV+dIsqqkrD/7P1r2I=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pRKWB2vH3d6CO+zEI+zLxXMaYlyxOvvyfWYZIGCKPKaJurlYHGaBLbij3ESd1n8DVZpfHTtEopEAezm6/OzqBHCRZzyKPb0dhOMqyMHQGNqKqbq1pDWTjTgLRVIUkbQUiId1q5RGW745ycBwaK1Rqep4kebkDjPrSmcpYU+z+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaEFgTdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaEFgTdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B1B1F0089D;
	Mon, 12 Oct 2026 04:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791778668;
	bh=3NDiEJWP1B/DEqfo4klFWw1eaIXyNKyTnkzt94wNK+c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MaEFgTdv8dKqjrqh6PjZXCOJXaAZ1/7XIxdUCGTHvNfFAqo44kvrFdqCiUesvjtaz
	 psIXStYvF+7DjDLQj7tV43T9CWmhAynSUXLpstH+uyXAQt7kue7V2WxJoDwMBMaL5O
	 lqBK9ZH3vUKHh452RdRPu2ASpDkGAF7AdU0xkVXow05bQGgFibrccRQMqbSz66Eb/O
	 YhVb6XWE7XY7y2O57YJ38bUxVx6OUAHVj3QM0xQi1pUMO9kqNVhOHV3JIBwbZD+RN6
	 G6rX4jWMYsrw4iKUoZvfr1bVWQY8FmNYahtJcVivCVcHxntzsaVuY91joORDuivtWk
	 9F1LXCSlxJZ0Q==
Subject: Re: [PATCH net-next v9 09/13] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Mon, 12 Oct 2026 04:17:47 +0000
Message-ID: <179177866793.434549.6463697653331835975@kernel.org>
In-Reply-To: <20261008031333.1142174-10-achender@kernel.org>
References: <20261008031333.1142174-10-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit fixes a real use-after-free.

--

net/rds: hold a connection reference from struct rds_incoming

This commit makes every holder of rds_incoming->i_conn own a connection
reference. It takes the reference at the six places where i_conn is
assigned, and drops it from rds_inc_put() and from a new
rds_message_free() helper. It fixes a use-after-free where an inc on a
socket receive queue outlives the connection it points at, for example
after a transport unload.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

> This is not a stable candidate, and carries no Fixes: tag on purpose so
> that it is not picked up without the patches it depends on: reaching the
> use-after-free requires freeing a connection out from under a live
> socket, which needs CAP_SYS_MODULE, and the fix depends on the
> connection reference counting introduced earlier in this series.

[Severity: Low]
Does leaving out the Fixes: tag actually keep this patch out of stable?

AUTOSEL can pick a commit without a Fixes: tag. This one has a
Reported-by:, a Closes:, a KASAN splat and a panic trace, so it looks
like a likely AUTOSEL candidate.

Documentation/process/stable-kernel-rules.rst has a tag for this case.
It tells both AUTOSEL and the scripts that look for Fixes: tags to
ignore a change:

    Cc: <stable+noautosel@kernel.org> # reason goes here, and must be present

Could this patch keep the Fixes: tag and add that Cc line with the
dependency explanation as the reason? That would keep the record of
which commit introduced the bug and still keep the patch out of stable.

A later commit in this series, "net/rds: hold connection references in
lookup, sockets and c_passive", gives the same reason for dropping
Fixes:. Should the noautosel Cc be used there as well?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008031333.1142174-1-achender%40kernel.org
