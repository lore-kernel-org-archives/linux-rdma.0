Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05CF17BED0
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 04:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790571421; cv=none; b=cTH6nwsbcsAFDnYbv2FHr1Scx160av6+ytfWtPCQzrppgPlstC4WVwWH6t1ehByYzUt4bT+Skq6kJjRWs6+qAjvlKl2bjSg/nb9hKJzFjcajgA3aO067GVzkjoviso0XJ+KhaiZ3C/7Ny+5gllFanDYbwy8GtPhGCfyxubOnd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790571421; c=relaxed/simple;
	bh=95dHZ1H3SS53UPnE8dFQYmJNpQcEQbJgVPMz/LwWxpg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XofV9doP3h8htmT4t4jKIX8T2WQC5PMXbUKY5oGZwbMES7GmGz00psLLVtjye23uF6vShRxmSIO5lDMyFprM4oRa9FTDLJSfd9ssluQhOgIEWJSYUIKLudwMGBQFVdlO7tZYQc8tp28Wb0jrPfm0VusRGcaEgt6MANWri8R5Fyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqOyi1bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqOyi1bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581461F000FF;
	Mon, 28 Sep 2026 04:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790571419;
	bh=883jpa5LqdlR5QE2nrb7wJeDOo/RGL6fwnhwnrRiaJI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kqOyi1bipiREr6/97g0AJz6z4p83OD4YDW+pq1EFGw+0o3nZ1/MY+6eIHVU1jWfkt
	 0QVxCjA0h5lFCruukKMdMHhx6gzMpXN4Owt2FGpppTUXz8/6QZHzIWp+JXvRDmsUwN
	 K0uTzPtf7Wz6vWtM5BPzOJqf/nKJJYQTzyzeq003B1TjDvbGuzyK4YJUhkMGBIMoVK
	 g8Uc2YEo9NjWzJ/dO5so7qiXiW8/fl0dpUpLCcS2JKyXGJbqHBE5nc/m30bgbI/0/I
	 hv04jdtLvIlzr93oFZxgJmCUOvIcY3/zO5cVCZPF8Kq5ckr3CvPlZS8cHVjN+tpXtt
	 MLmuAtzupVb4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net: rds: fix uninitialized trans dereference in
 CM event handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928044507.335883-1-achender@kernel.org>
References: <20260928044507.335883-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 04:56:58 +0000
Message-Id: <20260928045659.581461F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Aohan Mei <henrymei@tencent.com>
>=20
> rds_rdma_cm_event_handler_cmn() assigns trans only when the RDMA
> device is an InfiniBand CA (RDMA_NODE_IB_CA).  On any other device
> type, e.g. an iWARP RNIC such as siw, trans stays uninitialized, but
> the event switch dereferences it: unconditionally in the
> RDMA_CM_EVENT_CONNECT_REQUEST case via trans->cm_handle_connect(),
> and (with a connection context) in the ROUTE_RESOLVED and
> ESTABLISHED cases.
>=20
> An RDS listener on an iWARP device therefore crashes the kernel as
> soon as a connect request arrives: with CONFIG_INIT_STACK_ALL_ZERO
> the wild load becomes a NULL dereference at offset 0xa0
> (&trans->cm_handle_connect) in the iw_cm_wq workqueue.
>=20
> [ ... ]
> [achender: reject only on RDMA_CM_EVENT_CONNECT_REQUEST instead of
>  bailing out for every event on a non-IB device, so that rdma_cm does
>  not destroy connection ids RDS still tracks; changelog adjusted]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928044507.3358=
83-1-achender@kernel.org?part=3D1

