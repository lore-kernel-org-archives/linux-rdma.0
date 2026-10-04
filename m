Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C590424D41
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 11:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791114034; cv=none; b=kX88CWEJsb7J6w/L+FZ3s2uXqqRGDEBzvFVn42i6cDF0d25JJ7VwLvDSRmK844RjT7XMFAvJHJK4R+e1oBie1D+N0lYQYzhOEI0WgQzB1BWqRYKe5wj9snPIO4emB+uO1FmmfQHd9ZLoobHCl1b/wZ/0lCsBbWr9jdYhHsWh5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791114034; c=relaxed/simple;
	bh=Okychga2OMtIIyyOufLUAK3uNGKtVFssTnlPmSqhFsg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MigG2/DrZAHgAI8yKxP2krLYomoBw3S3ZXsScnhnrZmWahvKb+ur9VY9qpjQWeiUKT1+QlphRC4fbwe2ln8mjNRwE/BC9I5Nf2ne5Q7GUENpFmXVhkUz/djN3BL4PYjB5AB15iO2OmrCLMA+tz6M7EbKLdqhlbCKdvQXm8YtYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owYiu0B1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owYiu0B1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A331F000FF;
	Sun,  4 Oct 2026 11:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791114032;
	bh=+7R7WF/Hv9XvajdxR8RICJaMCMBIn8eEDGG6SJafAMo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=owYiu0B1QpmWnoFaVKyPRh6BGesqaYIJwV5/P9Lt63ewfh+Z5TtNWN9+SLVUO7rXM
	 oJH8njABHycrl8IlSQHbPe2AWbt4Px+lTct7FLIsqWXtjCpNmzys9ycXefgVO08Tty
	 IGgHkBPo5ucxvl+eTnFyCSvxUdm9MwFU3Z3zY36Wr4mkUU8zN6Qt+AnvZPN4vXbV2E
	 oF3eM5I/vvrh9i1hTUoIJGHZ7SvvaRYkUJNeZw5gtoAiSjS+SkrDWnkDsAte4qYxls
	 0eKFZFtBc1FJw9Ok7//NJVZMdlz375Dulsq7nozRssKdu3dMEGyPrN4LIjuQA3qIPc
	 2Q+w7pUJm+L7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cma: wait for addr_handler() to finish in
 rdma_destroy_id()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Palla Raghunath" <raghunathpalla.0209@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004112613.18171-1-raghunathpalla.0209@gmail.com>
References: <20261004112613.18171-1-raghunathpalla.0209@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 11:40:32 +0000
Message-Id: <20261004114032.94A331F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> syzbot hit a use-after-free of id_priv in addr_handler(). The bad read
> is in debug_mutex_unlock(), from the last mutex_unlock() of
> handler_mutex, and the memory was freed by ucma_close() ->
> rdma_destroy_id().
>=20
> addr_handler() moves the state from RDMA_CM_ADDR_QUERY to
> RDMA_CM_ADDR_RESOLVED (or RDMA_CM_ADDR_BOUND on error) under
> handler_mutex. If rdma_destroy_id() runs at that point, it waits on
> handler_mutex. When addr_handler() unlocks, the destroying task can take
> the mutex before mutex_unlock() has returned. It then sees a state other
> than RDMA_CM_ADDR_QUERY, so cma_cancel_operation() skips
> rdma_addr_cancel(), and _destroy_id() frees id_priv. mutex_unlock() in
> the work then touches the freed lock:
>=20
>   ib_addr work                         close()
> [ ... ]
>=20
> Fixes: 722c7b2bfead ("RDMA/{cma, core}: Avoid callback on rdma_addr_cance=
l()")
> Reported-by: syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dae549381b4daac2895b1
> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004112613.1817=
1-1-raghunathpalla.0209@gmail.com?part=3D1

