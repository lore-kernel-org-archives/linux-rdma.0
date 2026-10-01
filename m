Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C33C47D442;
	Thu,  1 Oct 2026 06:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835375; cv=none; b=eApcJ70r9ZxEGQJkclRI6yVcB4YOdShKmEWxbJpzA/lUTIiUvQMFlLzAdLUo76dNlehOgL6yv9VFySlwihFoXsDBHzDTVLyHCmelPUoeGw9Av9MQJJYAHLS7rtfipx/8o6S5cJh3IQ+cUnv2tb96D2XHTgz8KVI/HcOc5hZYfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835375; c=relaxed/simple;
	bh=qVX8CmUXJJG5RyiHaFJuA8rSKQuN373gBXhSQPENC4Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dHz1KWaL4LBdjh+xdIBjN/yKo0/AELCLz0DI36TxOeRd9ZbixT7fio1JhoqiTg80B2gn3D3pPXBo3QqxHXRZpN/VXlPJP219UAgEZPEcFa/k8I48bnE+FQI8cMAjJG0F1ZKFhGlbCud6/T1AZC29NME3cMRH9r79uCUFZyLpyiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTnO4Hgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTnO4Hgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862611F00899;
	Thu,  1 Oct 2026 06:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835372;
	bh=czhlKz4TnAEpf8M3BzN1K/FYIsAp58sDF0KnjtBxVHg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZTnO4HgqcTP1VpNJyLVyXZOUrWh6Ei0kSxdYF9szNaWM7NHVDbHKPofdhi1+ZEZBz
	 ukeDkCCuo63kPCI7EyHEFRaTLHtr5W7iPcYK8rRHlCd92oLvgWAVKShNbZTBqaU75n
	 rC9vZg/mtXzkrvNiyGShTaWOX+4ZZ210IHyOGEa7hpZWJkZjz4gzNoeFiaqvS9e4sB
	 A0av9jOuYIXAoaTBSzQEPqCEhdJO2g7kseuQUoh9eZ1TNKKNFZLdi5Wo7gAROwtlYI
	 FM4yIuL5AgpFDUYlt/rMBzSfLhsA63Q8Jc6lILCYCBpOCp/is0+vOXbQqNg5Ddg+vi
	 fGwW/I1aiuHCw==
Subject: Re: [PATCH net-next v7 08/12] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:12 +0000
Message-ID: <179083537208.434549.10956746980107541963@kernel.org>
In-Reply-To: <20260927061448.167862-9-achender@kernel.org>
References: <20260927061448.167862-9-achender@kernel.org>
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

- [Low] The commit fixes a use-after-free that users can hit and that was
  reported with a KASAN trace and a panic trace (Reported-by/Closes tags…

--

net/rds: hold a connection reference from struct rds_incoming

This commit makes every holder of rds_incoming->i_conn take a reference
on the connection. It covers rds_inc_init(), rds_inc_path_init(),
rds_recv_incoming(), rds_send_queue_rm(), rds_send_probe() and the
congestion map path of rds_send_xmit(). The references are dropped from
rds_inc_put() and from a new rds_message_free() helper, which fixes a
use-after-free of the connection seen from rds6_inc_info_copy() and from
rds_ib_inc_free() after the connection has been destroyed.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

> This is not a stable candidate: reaching the use-after-free requires
> freeing a connection out from under a live socket, which needs
> CAP_SYS_MODULE, and the fix
> depends on the connection reference counting introduced earlier in this
> series.

[ ... ]

> Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

[Severity: Low]
This isn't a bug, but should the commit carry a Fixes: tag?

It fixes a use-after-free that has been reported, with a KASAN trace in
rds6_inc_info_copy() and a panic in rds_ib_recv_cache_put(), and it has
Reported-by and Closes trailers. The unreferenced i_conn pointer appears
to date back to the original RDS code.

Leaving the tag out looks deliberate. The quoted paragraph says the patch
depends on the connection reference counting added earlier in this series,
and a Fixes: tag could lead stable tooling to pick it up without those
prerequisites.

Would it help to add a Fixes: tag pointing at the commit that introduced
i_conn, maybe together with a note or a Cc: stable line that names the
prerequisite patches? That way the origin of the bug is recorded without
inviting a partial backport.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
