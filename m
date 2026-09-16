Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6132548665D
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549664; cv=none; b=bwNQkUwq8ZH8UbAhXKM6522LXNc+rYXgm9+9bhXK95ywQ53FQuoS/hTMpio9WQbjxkkM1oxGc7kSwc0C8ee78jLJoaQi2PRKr5eAF5YJrzj6vUYAzmKpi97AdhZQUsV49luPpsiJ7v0agx/LZK7PS8hH032WbygrxohACkyUuJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549664; c=relaxed/simple;
	bh=4hHE+IfpnNr1+KHPkheAtXQzSpQQA3pZetExvNheA1A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k/5sbMluTb29ynf/EWtr3WxWSywGq8dy6IpI1sA1qvQwxt3z1KwfhV4nsPjzIZwNNTUzUiDToMRATEScrCFDaDOXQHBEWKC4K1QXCc0qQKW3xMp68dU1lDtnUXFRP/GZ2aB3DGJOsViER4aLK9peSGUwtACTwA6ue5XdDnL/05k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVSWTtpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVSWTtpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848F81F000FF;
	Wed, 16 Sep 2026 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789549648;
	bh=nVLdubhA5M+yNEquoboSqDx5IDNBwWJcuBxyUnNnoRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lVSWTtpByOHiJ2QBxhO4MBfT/39ztmlZgsyMxUtTj2r6+KZnRo9EbubZTZvxziKUb
	 dyQo9E3dLXU+KaCEP2rhcw+MHPCIPAlg2qbmRF1YtZjTwgpkQ4K7kr4Zp+ylvBz5mU
	 Bgm8OE33OdXeGBuW39mqSRtBhws3uM6BcZGjH6fG8jtcFCfWhecagWYelmzlKgBzrb
	 M5blQbkrRERDGG0VMBaqfuc9pu691iwiHN50W4wn8pf0ZYSIGN2PpBvXchY9aynd3d
	 AMnHIRb9vVbeg23xpwruFPnoM3pDBfYl+KSy0bWegzaxjVWtV6s2xiFMGoH0a+ehBb
	 sAJy/w5C/qPfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Drop restrack ref on ib_init_ucontext()
 failure in GET_CONTEXT
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916085529.1838-1-lirongqing@baidu.com>
References: <20260916085529.1838-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 09:07:28 +0000
Message-Id: <20260916090728.848F81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> The UVERBS_METHOD_GET_CONTEXT handler allocates the ucontext via
> ib_alloc_ucontext(), which calls rdma_restrack_new() (initialising the
> kref to 1) and rdma_restrack_set_name(NULL), the latter attaching the
> current task and taking a task_struct reference.  When ib_init_ucontext()
> subsequently fails, the error path only does:
>=20
> 	kfree(attrs->context);
> 	attrs->context =3D NULL;
>=20
> without first calling rdma_restrack_put() on &attrs->context->res.  The
> kref therefore never reaches zero, restrack_release() is never invoked,
> and put_task_struct() is never called, so the task_struct reference taken
> during set_name is leaked permanently.
>=20
> A local user with access to an RDMA device can repeat this path (e.g. by
> hitting an RDMA cgroup limit or supplying invalid ucaps) and leak one
> task_struct reference per attempt, eventually preventing those processes
> from being reaped or exhausting memory.
>=20
> The legacy ib_uverbs_get_context() path already handles this correctly
> at its err_ucontext label, where rdma_restrack_put() precedes kfree().
> Mirror that ordering here.
>=20
> Fixes: a1123418ba10 ("RDMA/uverbs: Add ioctl command to get a device cont=
ext")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916085529.1838=
-1-lirongqing@baidu.com?part=3D1

