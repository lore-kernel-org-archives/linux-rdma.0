Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336019;
	b=RGJB1RZRXPBCL87EKTxmQi5EuBE0eVAFM9Bz2nl1OTSVb5fO0i3AB2D6m3DIzT9H1m2P
	 P7LFb15TRVrqU1f//Dn3Sun2gc3kZ0bNbnWiFkrf0ofYOt9JzkY+Tmgkdd4z2AbpreNW4
	 usQPGaEcIejVfKcuLRX86XGO0Z3kocoPvWtL8JP0Moi9DGumcvzj+jsAC4E7bjUMb8jvW
	 it0yvXn428WIbvF5FTCTW9Lw88E/6XbaJbQRYN2Uda/kJb/stw8V0B5PA0uJvc60wjbi3
	 +DYy1YwpnlfMAy0H9qODg44fXWV6fP5XoYOjvwIpWUno7Yeur8nVyu3VpCrRlQRP0RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5jWQ2iaj/hqKd2FQlYt0/KJTn0BIlL67InGkY6ECAoM=;
	b=OncElhmNWQcip5VUe7/e9Bs7Bw6Wte1qUCZ3Hnd6ONXKJxGlPtq5DpPK5+2mDRg80Ipn
	 qrQoVGHMpdFK7esLXgAURm9WQkZfiLLMpTm8ZEAeB/Btfv9w6DnL9yo3T6aXlF7Rs6SDv
	 i5Ghf3nh6bHQODh8Rry4BXZ/LOoFveT0hVfWKrfsmWnGuIYA0emV1JnGKqwlrueUuCtNF
	 3Ch5SYidbWRldtH8twcriodF8m3CtNRdQ8+OvjgHP18Pw/rRHKsR6DnC33Y8r2FPy0b6W
	 EQhwIW3K2nEyL9cF9LMTaY2J56D1SUwMhddkpL3cK3Ce7vjeW9STf9j/eneDt8S/Jzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBveSKnI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D0F606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBveSKnI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EAD1F000C1;
	Fri, 30 Oct 2026 04:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336018;
	bh=5jWQ2iaj/hqKd2FQlYt0/KJTn0BIlL67InGkY6ECAoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dBveSKnI1+N7KhJymAr0/dMyCP2igi6AzeIEMc0CkYS3IfldFJamVML7Wn2RxDG1U
	 1aAwvuhCGnqUsH7uy7AyjAyihuPC4dznx7BrSbYlZ0U6d8Xn1zQ59fOmgLDZzmHTrS
	 1uzq+UlytnxVRYxlmVpLC/8DGw5sSNNqx+Q0apiDgsmn0X6UnUBCha+B4MzofqAIix
	 gzQ1c7q6Pw6EBvJKwgJauShtqtcCOfBpdTVnHqf2oaP0Oo4xQAMFmrUH5LK0HKCzaZ
	 I4n0u4xB127r6Nr5VbCLA29RU41fL0/0VA5eajPM4Uta6zQT56XLw0ZapOc/7LrSBN
	 zOCaAwIesbpXA==
Message-ID: <sashiko-outbox-190329@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 2/3] net/mlx5: E-Switch, introduce generic
 work queue dispatch helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428051018.219093-3-tariqt@nvidia.com>
References: <20260428051018.219093-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Mark Bloch <mbloch@nvidia.com>
>=20
> Each E-Switch work item requires the same boilerplate: acquire the
> devlink lock, check whether the work is stale, dispatch to the
> appropriate handler, and release the lock. Factor this out.
>=20
> Add a func callback to mlx5_host_work so the generic handler
> esw_wq_handler() can dispatch to the right function without
> duplicating locking logic. Introduce mlx5_esw_add_work() as the
> single enqueue point: it stamps the work item with the current
> generation counter and queues it onto the E-Switch work queue.
>=20
> Refactor esw_vfs_changed_event_handler() to match the new contract:
> it no longer receives work_gen or out as parameters. It queries
> mlx5_esw_query_functions() itself and owns the kvfree() of the
> result. The devlink lock is acquired and released by esw_wq_handler()
> before dispatching, so the handler runs with the lock already held.
>=20
> Update mlx5_esw_funcs_changed_handler() to use mlx5_esw_add_work().
>=20
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428051018.2190=
93-1-tariqt@nvidia.com?part=3D2

