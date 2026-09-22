Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92553366045
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790042398; cv=none; b=koBZhNeMQhtbiBldUmfKWLB0+emp3PQLx/Y2SBoum3c1xe1ZkpVWmaq38WybAY375qa5SvBJskgr+H4TknXFyyQLYe4wDi88/lB0XQPHPbfwLe4RKTAjYj8kol/i6AXAZEKLpKjgXwgb4qUcrriBt4YgOmHa6tKgA5S7Y63a1M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790042398; c=relaxed/simple;
	bh=9ib1hSjpm0FdgAUW691iZF8yrKA7ydnakXBH6U/wwkY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PzcMVzUOl7V7gdsUG4UFpzgImXMZnqJXtWJrYH/aB5Umil8ebnhS2mHpLZ8dgeYh0pJXwj8Z7Wr5D4gLhz8JIgEg3nNfyNXi2lyyTU/WaG282d+6aLbQvqjaEr9tbfTh7TnWDNL4Syb9ZqmpCieV5LvsNnhNMiNivdUzHYlhcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmZIk35B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmZIk35B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A481F000FF;
	Tue, 22 Sep 2026 01:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790042397;
	bh=9ib1hSjpm0FdgAUW691iZF8yrKA7ydnakXBH6U/wwkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lmZIk35BlsewVe+6DjJa+SJ5LhfDM+jbNXvw2UlGKcUFb4F0Rq1YRWFt742qsM09X
	 rEB6DL/mDjNoXuets9c/6uF+O3VOnnh9rbuHS8mH4CTnIwKKRkO7ViEIzo8q9Kjlt0
	 kHQ7Pu8V/bYjtujStqnhZNu0qI84iJl/wpvqw1oZ+GrAH01FyNgliyqZov0nz3UfZU
	 UqR4LzWApXsE7jdoz7mX2qnpKsjLenLsN+YUP065id+o3nPp9V1eGgQTDahxliiCqm
	 B+nJSJWRWY1MDhjwOJnSraCQNz4VgqsLTZL50Nl9lBQkv47DNMfQtnafR2+5Ng9e+S
	 R0iBianIIrtLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 4/5] svcrdma: release a send context stranded by a
 partial post
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20260922015128.240977-4-cel@kernel.org>
References: <20260922015128.240977-1-cel@kernel.org>
 <20260922015128.240977-4-cel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:59:56 +0000
Message-Id: <20260922015956.D7A481F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When ib_post_send() rejects a WR mid-chain, svc_rdma_post_send_err()
> returns zero to say that a completion will clean up. The Write and
> Reply chunk WRs in a reply's chain do carry completions, but those
> only trace or close the transport. The Send at the chain's tail is
> the one whose completion puts the send context, so a chain cut
> before the Send leaves the context unreleased. svc_rdma_sendto()
> reports success and never puts it either. No list the transport
> destructor walks holds the context, so it leaks past teardown along
> with the DMA mappings, page references, and rw contexts it owns.
>=20
> The error path cannot release the context itself. The posted WRs
> still reference its rw contexts and pages, and the HCA may still be
> reading them. Nor can it drain the Send Queue to wait for them. A
> drain needs a free SQ slot for its marker WR. A provider that
> rejects a WR after accepting earlier ones has most likely diverged
> [ ... ]
> contract. The chain became long enough to cut only with commit
> 10e6fc1054d9 ("svcrdma: Post the Reply chunk and Send WR together").
>=20
> Fixes: 71b43531ee0b ("svcrdma: Post Send WR chain")
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922015128.2409=
77-1-cel@kernel.org?part=3D4

