Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF270546283
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 14:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418860; cv=none; b=YmzYe19N9NpgKTC3KT2Lcgm0T/KSIMdLAxOlQSynmixNOLON4pusB5oRwaxVaM51QqGW7IP3KYEIyZX4MoINZCg0Yk3zZDt6b4iRy4jhU1GnhUvGISFc68or1Zj9OGw8JRraKCsDrPedTycB099AnF4Ct9iQzgbNe+8cQAgsdHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418860; c=relaxed/simple;
	bh=ca6OB3manqMOMj85iurLMXE2r4qx8iWusPORDAR1ba8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=in7KknqsG0aXV4EeO0mZMRJeWmR82fi7CxsFA9mIvowia5A1G1KGebb49GrgfruZNVWPk1POkt10Aig/9AKNnV/lIPWRDSrCTod4/HhSIXe7V9BVqpG0ZYr2aw9VF20XYo+IyRwfxZb0Deb8ZCnByeAuuamDxRLxq9s3KbYcoiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZT1yroTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZT1yroTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913D81F000C4;
	Mon, 19 Oct 2026 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418858;
	bh=XmNuj9ykq5UsKzSq7f1ao2McjVRjs3saoW+zzjdypJM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZT1yroTqTAs/UyrDsJwdgfXIvFqda6Sbd4aJ3SmdmZ2ItzBIkJ/eMQQvSkLmjtBnj
	 cs6qq/xaxKEkhOg+JKUCtxjNlr8oa/pOESw4FF747+XBldlaYabvyBkKOz1iTSqiBN
	 gjWWTUEXpzoVhR3W5vJTPHEkQNDRYXsvsuxnQb4mHKT9L2Y9/MbPmFhboa2qMFgWBV
	 aIqnez4zWfa10KUVHkEo6HEndN//LvSfD2JWheadehGljyzZPjE3ViffUZUEA7NdE0
	 KAQDxzyPPnhmgwVMfS3EOfUXTJOt8cKmxecqh1W+xXUJaxsfcQ1tYAgFDKiBeIuImZ
	 yiGbPyINqrHUQ==
Message-ID: <sashiko-outbox-177292@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] net/rds: don't use
 unpin_user_pages_dirty_lock() from atomic context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-8-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-8-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:07:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Allison Henderson <achender@kernel.org>
>=20
> [ Upstream commit d100966325f782aa7775e5f0e8fb04f66f56308e ]
>=20
> rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
> send completion path via
>=20
>   rds_ib_tasklet_fn_send()
>     rds_ib_send_cqe_handler()
>       rds_message_put()
>         rds_message_purge()
>           rds_rdma_free_op() / rds_atomic_free_op()
>=20
> which runs in tasklet (softirq) context.  Both functions unpin the
> user pages of the op with unpin_user_pages_dirty_lock(), which uses
> [ ... ]
>=20
> Signed-off-by: Allison Henderson <achender@kernel.org>
> Link: https://patch.msgid.link/20260730041629.3512480-2-achender@kernel.o=
rg
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-8-sashal@kernel.org?part=3D1

