Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4266E1BC08F
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792183076; cv=none; b=tzT1E5AfuhJbbtLoZL6f6THMtgebchK2n56NQPRZlh6ldmfOOfS9BSEi/3zdPD7At0nuHrPmgQhYIolCsVDm3pfgrRfkiiorhoGfHjfZkywzw2+NLphaZovR1gWwz3ihkEg+UeAouY+QZddtVql1ACet2lqToKQ4AlIdleYOxoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792183076; c=relaxed/simple;
	bh=dsKvZXTHIMySTTetipWlZ67m+88i6xNjVZIcYqsvDpM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HmSWX49Yd0qKnsvJ6bMyz2iQq8FOKSfRQpglBdN6DQmhB2Xb7IT93J2F63dZq21i1ukbhP2OnK2rwElkmjfNIhhBbFvCWlZ85tiIO3/olaSDU7PsTyLMzwpNa6OnWUfNbi5f92nBSwCv63uyuIw/18QzwuRG3aWKCNyrLfsuGIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNBHRQCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNBHRQCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6B11F000C4;
	Fri, 16 Oct 2026 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183074;
	bh=dsKvZXTHIMySTTetipWlZ67m+88i6xNjVZIcYqsvDpM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iNBHRQCw9kfMc4k93AuvYPDl3g0f1HiJfn7fLqkyBMBSPhXKHi6e7Hl3jICWIgsAn
	 7ZBz3kWl6qHlTv3Ns8v6F2hQsEpFsU/VKooacQcGk5dlORrQi/Zf2ygYPfLuCV7+02
	 kbfnkp2ZjlEfbBlgRuDHfh+HXcZMueaAEuhI1XgtU3u9BEA0Em2/RLIedQv7LJG1s7
	 +F4GFexidrnXygeq3bk7EXuAFrvXQlRCGiZdEc77RS8SOqkR37yyUS60QBBCIIuKMb
	 1hyhEQIEBx+RRID1bl9Y7qkvLfRJbKKm6sXxXZxcVhGvBVkrNmafefBf7yqm9n+8Cn
	 9FQf2aiKCqWZg==
Message-ID: <sashiko-outbox-174918@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 2/6] RDMA/irdma: Register irdma UVERBS
 ioctl namespace
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016202909.1289496-3-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-3-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 20:37:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> An irdma UVERBS module is now created. An irdma specific shadow buf is
> defined for CQ, while QP and SRQ reuses core's uapi definitions. This
> works since core builds shared core ioctl parsing tree first, before addi=
ng
> driver specific `uapi_definition`.
>=20
> Destroy paths are automatically handled by core dispatchers, as objects
> are now registered in the parsing tree and no additional driver specifics
> are needed in destroy ioctls. Resize, Query, and Modify continue to go
> through write() cmds.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016202909.1289=
496-1-dhu@x6u.co?part=3D2

