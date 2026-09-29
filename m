Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C114A3839A3
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790707096; cv=none; b=kAlcWjZh3ohYTJK5JL5PUpRBj+If3SHCXi66oJ7/V2Yt8Jwbnkf5z5pkYWfXvLxDDtC0hAvDSAjlTmcg2YZx+b2Gqyv8Hz7ANKDwhJUki0xBExkqH2DVgxZ5LE0+4yiqpJdQy9wIz9DCsUfr+GHfrBjYovsZ03SEiPw25lsPyCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790707096; c=relaxed/simple;
	bh=LuAt74qvEkFGXmveCtE34CAFwA0W/EmDi1gy/s0Uzow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iECrGoRKdzkEhCMjoHAY8uywk9y/unOkO1j2E4YwgW51bFumQPgmytCUy8ACwNsizGy7XCGPS5NpEUfZ6xRBummHGl0cHP3Ik5mlNqbOfYG7E741srFF86qPMTT58NAPcaqCfnB1tHkqbbeIgSvUFhD0SvauCyI/aSSAO9NUZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3G/BIbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3G/BIbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D41F000FF;
	Tue, 29 Sep 2026 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790707095;
	bh=K4o+aTOVDQRhNVi1OgbMpVC10p5UqENe+kMGeh0qatc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=P3G/BIbMj5XxC7UB3yA/AvsflbPO66iuUlqGVseY7RTdnO3AoFBn6+WKR6OAESVYn
	 y5VRCqpJ/Srsl6jfme9WHhR1L1dtWQYSZwLikCNkZnmF4Q8SzwcJoIBATjy7Cj2Oql
	 sgwk12/URoofwXbl6m608ZnzBH2yJYp5f/N2BcOfUCRVnbVVFkinKdwCUSZh6LEUZM
	 efdcAiawnG1Jlps+XrUqPapJBvuZiP3C1lU/Re5Xbd62wa3dTF8EyZJ4iC53OanxJq
	 TV9LVcbN8U1L764nvlQp4D0RE+ZTdDh1Eh4mH7o7E1LxYfzCFjxN8pHRKvIFGYDFzs
	 htzvoGgNgEj1A==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Geliang Tang <geliang@kernel.org>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliang@kernel.org>
In-Reply-To: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
References: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
Subject: Re: [PATCH] RDMA/siw: drop duplicate check_app_limited in
 siw_tcp_sendpages
Message-Id: <179070709246.3974394.9416103585481164471.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:38:12 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 24 Sep 2026 15:39:19 +0800, Geliang Tang wrote:
> After do_tcp_sendpages() was converted to use MSG_SPLICE_PAGES and
> later inlined as direct tcp_sendmsg_locked() calls, callers that
> previously needed an explicit tcp_rate_check_app_limited(sk) to cover
> do_tcp_sendpages() no longer need it. tcp_sendmsg_locked() performs the
> check on every path that queues data, making the outer call redundant.
> 
> The site changed here, siw_tcp_sendpages() in siw_qp_tx.c, holds the socket
> lock and invokes tcp_sendmsg_locked() on every iteration. The early-return
> paths in tcp_sendmsg_locked() that skip tcp_rate_check_app_limited() - the
> MSG_ZEROCOPY allocation failure and MSG_FASTOPEN branches - return without
> queueing any MSG_SPLICE_PAGES data, so there is no functional consequence
> from omitting the outer check.
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: drop duplicate check_app_limited in siw_tcp_sendpages
      https://git.kernel.org/rdma/rdma/c/ad91fd9e9440ab

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

