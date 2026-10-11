Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CFA4078DE;
	Sun, 11 Oct 2026 08:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707995; cv=none; b=U6xOtHmqkEymU+N/PVyDVutbyOzR0mNAV1ZzgiMKKADV0Pstq4KHA0e5WTOcPTob6XW0yPmByx3/k6sIEXnhK4SIz9jShOPrG6es2wMH4DWL/lzQotScZIjZiRBeKppkgp33ntrt+FISv3Ctm34sd+MCc3jliN3b+BPc3e1AkwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707995; c=relaxed/simple;
	bh=sWPUk/r+Xx8NJ2peccjxmC+1zneXlxPtOnuPSgy+fqg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Wv57kU6BIE8JjRvvYK7QvrRbtSfJ+S7mCluZovk4j215fPfW/7GbPw5ZZUjUrDRHsMVbF+ZyKhtUUW6LJ1uInX9umyUJcWibAaVzcxLXmZS4BcgsQAHOK4PZyB+K6q3eoCD0JaVY0X5ubZtx7MJPsr8v/3qUDy7CTISLbjuOXdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwzjOnvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwzjOnvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B801F0089C;
	Sun, 11 Oct 2026 08:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791707994;
	bh=sWPUk/r+Xx8NJ2peccjxmC+1zneXlxPtOnuPSgy+fqg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XwzjOnvDrHCRPgMVVmA2gnMNqE+ysvuk+fNod9hVdRaEobsZ745PABDydZOie2FmB
	 SN8duQfzu8zFqOyNmlVpwQ1/3UuCG3G8fH4FMR5qw0+NNwSv3n50UAkNozhR/3ixbt
	 sVL3ggpWV3V6YCTibXCtZpN5LlZHEAghCZY62/3mUj4iaWr5gbuguIfn+5yVyhUwCn
	 2OX6WQGVav0N2yOWjzvR8NzIn4ugG7hVPTJo0iOHTlfcCkg7gXh5434YT7kbHCONV5
	 lOkxrLHtHW3Sj8TlfhQ95ZaGFnUp/iGtyqlODd9X4ikXD3KGr+8Rrk3XtprJvNN4Ij
	 ujJYiZ4JLi7gA==
Message-ID: <sashiko-outbox-167125@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 1/6] netmem: rename __get/__put_netmem() to
 get/put_net_iov()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261010083935.3274178-2-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
 <20261010083935.3274178-2-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:39:53 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> netmems carry both a non-pp backing refcount and a page_pool
> pp_ref_count. Make the non-pp layer explicit and symmetric across both
> netmem types: get/put_netmem() dispatches to get/put_page() for pages
> and get/put_net_iov() for net_iovs, always acquiring or releasing a
> non-pp reference regardless of page_pool membership.
>=20
> Warn via DEBUG_NET_WARN_ON_ONCE() for net_iov types that do not support
> non-pp references.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010083935.3274=
178-1-almasrymina@google.com?part=3D1

