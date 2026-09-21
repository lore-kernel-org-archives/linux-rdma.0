Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428683BE141
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 10:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985285; cv=none; b=JfL1+mhskJ2+xL5bEketMVXhJDQdkaFuttBxmfkug7f20tvrXgDGRCIwENLZwa58SPHRAM+XPzYsOGYlc0AiL2PBNjoAKlI3294nKvTXlPRjqbUonLiG9TJEgtxX60tGIrbyZq4RPGwjOaNLUfVoPICZHEVYuNzZw7B89FVJ+dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985285; c=relaxed/simple;
	bh=AFOCV+/qkuVp3gnAHOAw9BBnNeNqa1ao875hhXu5WYk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SlfVypKaSf1//UBBzdMLAGK4+2wJqCLTy4uAWTxKGa+ZYcg7eDMunvMDMvyOAQ6mw6f/WLqLm4KvJkGjUxnsd9Zmunv6leGvflvBlDp19yZQdC+ElAGPJSQGS0Sy8Nam+tyCPs6L74UcKA2y8NGG/agNnFFsNXbbEiyVIxKclqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tb/FPf5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tb/FPf5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87DA1F000FF;
	Mon, 21 Sep 2026 10:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789985283;
	bh=AFOCV+/qkuVp3gnAHOAw9BBnNeNqa1ao875hhXu5WYk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tb/FPf5ucKf7iTPvxaXwFhBz85PBO2KFTLKrSSQp9oyfnKUET5V46Tb748j5DukFT
	 pDAsT56TPphZzOFSqruV9b9fIUgmIZPRaCGmjy3qkPWk8Dl2Eld+64qK8ms8X1in4f
	 4P7gaolIjWekKdxTGuhJWLLtYaWUsHZUygGoEa47x8YROpJgF4VBV5qVQvT+Lyuqnr
	 5V95cJymTnf4xcxr5X9CeJ66aBGLeE1T7r+J4SAet4/wXTS6bRlSxOAxaQyCBpykev
	 gTjHcH4ufxkcP0VFjDWZqy5FN9CuzUeyI7KkYAdkQTdlAKCVzWS+D7+w8uNRG7NWZB
	 leN46sy6gOTaA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 4/5] RDMA/mana_ib: Make kernel CQ arming
 robust
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921095352.3524691-5-kotaranov@linux.microsoft.com>
References: <20260921095352.3524691-1-kotaranov@linux.microsoft.com>
 <20260921095352.3524691-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 10:08:03 +0000
Message-Id: <20260921100803.A87DA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Track CQ polling credits across owner-bit wraps and serialize arming
> with polling under cq_lock. Check the relevant owner bits before
> advancing an outstanding arm, and update the hardware consumer position
> when polling exhausts its credits.
>=20
> Expose the allocated CQ capacity to the core. Pull the explicit-index
> GDMA doorbell helper and its declaration forward here because CQ arming
> is its first consumer; ordinary GDMA doorbells retain their zero client
> offset. RC-specific PSN doorbell use is introduced later.
>=20
> Preserve the baseline's dynamic interrupt moderation doorbell with a
> zero client offset. Read CQ owner bits through the scattered backing
> pages when the queue allocation falls back to non-contiguous memory.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921095352.3524=
691-1-kotaranov@linux.microsoft.com?part=3D4

