Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF5538239B
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271441; cv=none; b=OQ5ewQmNmHo/kZGGcQCtpT+aH03V3ZpXLZ1SM+QX90D/8jbQJDhl+F3TFGW6Ff1hG/WXllIOaRPgb/7SS6wCUdE3NWddS84i5oewVr6Vbf7RLZwh/ASp1MPrs4Q85OD6LCt2UXNHAbo2GcDNarz6XD3Y24i0hHs+e0yKR0GjAM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271441; c=relaxed/simple;
	bh=RDcV+KHWuNBA7N1KCDekTV/4+LVb/5rAI8SF1dto/hc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qdzh9xuiQpslwm/v3gfWWN/vlFlf1hObcMeWCHJgpvZuC1g9Nnr83HJQoBTEoR+R8H//BUnfjON2XO1VSbsWf9jt4eIWZg0KHA73/wM+s9N1spsbZTqSRsI6Rsyou33cCFi/hs4BclS4D7Qo0yICzlIJGENzaRFDUm+9+pNduos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGHMDnmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGHMDnmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225BA1F00898;
	Sun, 13 Sep 2026 03:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271440;
	bh=D9hF1DSJvMorGoc8eW+ZKF5D+A7oslA09mwcb4udyvo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HGHMDnmAO4q4Z6gtMicqyJkFJzgNoU9tpyGBICT/U7gKYfPuR/9E+oWK+gvXlS1zr
	 6ZPPLSr/mcTry7pbFsTly3+Ik1Pr61p9+UcJAMcTf08i22MRV4cLQ1eAWJx9J+5qGF
	 b74ChFROtOsm/JLd8TBtNlPViDR/FIEtMtAdv/4BJVFaYNGQyrvTmCeC2fZ4hNKjVx
	 7JUQhRkI90+v9cJ61ij/HYUTiyBF7cV8hWARFlIGq7NxsZEVDxdPDWA5EI5V2oSkrY
	 i+h4rFMst4yq/vhtjFcqpdMGQ7RURUVRHtKylikC1syMTv96W8oSkqVyi/n0hUYi7S
	 QfwazNmD0UfPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/9] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-2-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:39 +0000
Message-Id: <20260913035040.225BA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  The sites that can re-arm those works are
> supposed to test rds_destroy_pending() under rcu_read_lock() first,
> paired with the synchronize_rcu() in the destroy path, so that no new
> work can be queued once the cancellation has begun.
>=20
> Five arming sites never got that guard:
>=20
>   - rds_ib_send_cqe_handler() and rds_ib_send_add_credits() re-arm
>     cp_send_w when a send completion or a credit update clears
>     RDS_LL_SEND_FULL,
>   - rds_ib_recv_refill() re-arms cp_recv_w when the recv ring runs
>     low,
>   - rds_tcp_accept_one() kicks cp_recv_w on the freshly accepted
>     socket, and
> [ ... ]
> rds_destroy_pending() pattern the other arming sites already use.
>=20
> Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize =
netns/module teardown and rds connection/workq management")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D1

