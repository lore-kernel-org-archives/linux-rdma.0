Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB98752B1FE
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 21:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790111036; cv=none; b=lRfqp3mXG6ZJxYv1Sf764MG1DyCVZjYI5VcI8oDcau++Ag1ExhaZa4UI7B6FtQeTE1znkx9PX1vwrrHOjevhFaRTN6kHB4TZkpz+i5UV9tSnyDFeGm5EfzeLmrPYp3XWqR+EsNGf7tzVCsajhCvlERmdCV4IKywItKqpW1PhQcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790111036; c=relaxed/simple;
	bh=S5eW7+vp63yY0l+noIvdw/fUlaRMJPWKsW4XbgyZ4M8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZJjho2nNnS39aO9NgR43fOixrOWO/seuyjSWRU0GpZ5prG6dgN9A96NiaCTwoXKSmVcrjnq5FdXk/w9v9nKwr6GVA4/sCNDDnS9iEh2JKyHXgvxWUHEWy04VLY4uyTlIFMmRbEW1QxwpVOOLclZPJE0bJr340eF7LG6VgEdWgnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bf5fCUBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bf5fCUBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CADD1F000FF;
	Tue, 22 Sep 2026 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790110994;
	bh=S5eW7+vp63yY0l+noIvdw/fUlaRMJPWKsW4XbgyZ4M8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bf5fCUBVJE2mcqUN0X37fe5apK53ZE55MzK+FFOtiUUVt7+fePrLcr9p7k2QOIS+/
	 zDkHqBA+BsH14Plyh/5mQveTACcn6IHUQ06tw0UV/ortSh/LXDRibsuRpPUPpMERGM
	 SvYcgW1FiW6MzFtBtDMyE4sD2yjMtCO1mP603g5KnACRE1iJMOPLryN0KGpTo/eU2o
	 AcoUAmtuCZBFUaxKyw1FAiEH6bt8JiUXz5d80DAbFFF4lsP2292vsse+EzGw6DGpyH
	 e3cKNdxHJa97YfUV+ucTrgXNLCwxLi2fk7KAt9IRwSlrgIGMyht3S4zZpmcdyJw8dz
	 hXCcwrk4g7U/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/rds: replace tasklets with workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sunny Tiwari" <sunnytiwari@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com>
References: <6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 21:03:14 +0000
Message-Id: <20260922210314.9CADD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> tasklet_struct is deprecated. Convert the send and receive completion
> handlers in net/rds/ib to work items on a dedicated high-priority
> workqueue.
>=20
> Allocate per-CPU bound rds_ib_wq with WQ_HIGHPRI | WQ_MEM_RECLAIM in
> rds_ib_init() and destroy it in rds_ib_exit(). Per-CPU binding preserves
> cache locality with the completion vector, matching original tasklet
> affinity without cross-core migration.
>=20
> Replace i_send_tasklet and i_recv_tasklet with struct work_struct. Order
> quiescence via atomic_set_release() and atomic_read_acquire() prior to
> cancel_work_sync() during connection shutdown.
>=20
> Assisted-by: Gemini
> Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6b07af04b3ba66a0900=
9e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com?part=3D1

