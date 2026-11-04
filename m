Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766831;
	b=AFC54OEAjqVHAhXy37FKFGxRDsNFXZwndiqilzS98ElDYb/pEttI37WY81yqo/dWl63h
	 oaSbxzc878PUFqpcjOU56Xa/n51XgJRNIWo/ess732xKUCnanu4fX8wEboS6yd4Svb/Nk
	 HdlBpcccNM6zucGbXZrMBaQt3K+bdSIKx15ucKvCCVl4kTkPHLNSZd75i0ksaoMpO6aZL
	 4sAgI2Y4cjg0i1DTgt3rsXQLs8NgvO2LZCAqSF/Z3927HdJNR5Uk/zBJb5RspXOE9wbou
	 sTy70EI912mFS1zBIDk0c1U418t5FUcJtMhsQY2YHMqqxppW7p5zvSphz+eoJFtabbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766831;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8Awde3LB5lCW0DDcRW1lwUaSbFUnHNHFGDL2zIkeTzE=;
	b=TU1U5GaAfEUUGR1ZunNn9I3FKWise8KBHwcYT/pUMTnOivcphQOTqaea5DDpPEt/i/Hi
	 rXL2Y7UGHJERPnmH2WrB7VZfYWbi5kgRgSrN8s9UiEh0GjqepmG1N22rxQnQxs+lHyXMN
	 7w2teWLKRmh3npceRaikcb15MwTtQOHLeRitPLRxR01O3H6pwoJlnK+WD6QsAHnhEcrqO
	 5e+2qjuy/+9xR1iy/JpSeKTgUGJ8W5DNG38T90FlsANDf+Sr8i8CHCJzYc3Et1ow0eRLV
	 6t7QMEDuxYGTaa6prTE5aqGL9x82SsNkYRutFbiTI3ATgg8A+/mCywIvrWNehPvVy/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DP9Q6D3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6420606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DP9Q6D3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C01F000C1;
	Wed,  4 Nov 2026 04:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793766830;
	bh=8Awde3LB5lCW0DDcRW1lwUaSbFUnHNHFGDL2zIkeTzE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DP9Q6D3S6hoYjXw4ZL1o5/ZnGl0ArzjVAOVS/qzSD4KvzUz4wYvGLCae6EdyiC8Kd
	 YZm3WX5om7AFoMClb+jaNSPIK6cl+8h00y7cjcg59qskyy8xXcK9HfTNPmE2wKOLmn
	 M1krJpu258jyvdtSvHX406Qgj4hWvxbz5XyPjpHkAm+8aCAok4k6u0VTvj2swbvVGR
	 ctKi1ZpDuaydpEZV91J/PiL0Yh23aDQvIA7CRvYWl0Fd53S19HDVHaTPrGaKJEWFKP
	 X9G0bPcGjTGqD5kHqc0kn9qxr8y508e2rxRukSTrJxBoIy4bvG7PeShzdEE/pIoQs5
	 KtFX/iX4Fe/IQ==
Message-ID: <sashiko-outbox-196655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/6] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104040318.1844865-4-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104040318.1844865-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 04:33:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The RDMA_CM_EVENT_DEVICE_REMOVAL callback waits for the connection it was
> handed to reach ISER_CONN_DOWN and then frees it.  isert_release_work()
> publishes that state before it drops its reference, so the handler can fr=
ee
> a connection that isert_connect_release() is still running on.  The wait
> itself deadlocks against the handler_mutex rdma_destroy_id() needs.
>=20
> Register an ib_client instead, as nvmet-rdma did in commit f1d4ef7d8883
> ("nvmet-rdma: register ib_client to not deadlock in device removal"), and
> tear the device's connections down from its remove callback.  It walks
> isert_conn_list under isert_conn_mutex, takes a reference with
> kref_get_unless_zero(), tears each one down after dropping the lock, and
> asks iscsi to reinstate the session.  isert_device_put() completes
> removal_comp once the CQs and the PD are gone.  Publishing now happens in
> the same isert_conn_mutex section that tests isert_device->removing, and
> isert_np is reference counted because a connection can outlive its portal.
> [ ... ]
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMO=
VAL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104040318.1844=
865-1-yhlee@isslab.korea.ac.kr?part=3D3

