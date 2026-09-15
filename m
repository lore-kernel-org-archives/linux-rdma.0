Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941333C0A0E
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482656; cv=none; b=RsDkkAtH+mWLVi2ZnWeUK56I6e6hjZf/V3kvDElLt8gGDDB7Pz0GXe9J/xq6wjiiKByt5it6jkss1otQyDVJVevzE5ME76xQ/arVAGLmWzl5X7CGUMiVBU/8VJACCPnJjL4xAxXCrGC+DrgHGGgQs1mxg3QTnwRXP73O+BxciK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482656; c=relaxed/simple;
	bh=ACoc+8xQYH5DC0H+h5ICFHYMsZ52zhMkYnFCOS7aXeA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=drAwv1IPi8MqeASUVFZXB63U7+g33bcCPImysllYJU0ZeHpNIBk5hMgql4+NwgXmshDoLveewGvvAGYwEEQvQEVyk3FXbJsQ9pPsP/34zLQ/1ZTYxQQrl1en0+Lbts6pUD8Z0VIASCta4MxMPumK1fz6k9hCBPW6+231IhfsIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVmts5/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVmts5/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F691F00898;
	Tue, 15 Sep 2026 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482655;
	bh=ACoc+8xQYH5DC0H+h5ICFHYMsZ52zhMkYnFCOS7aXeA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WVmts5/sqoW0H1ZIx48GnI5f3sUyXbYjK+dR0wmMf3oKJuGEWCFAfYrMx+GtEJUSB
	 mQ4NoqtOzckUja31mQX7iwE/D5BJTQZhtlVLbPHEMNSB1jBErHtaTDTmz4Jekt66uB
	 tKID9w0U1s5e52FNOqhSWMidU+nxRywoodDs5cKscRmS0rOFOgavii/sWHIAGvI78g
	 bEW5THM0qXKdFkm31p48CMQhoRvlGZKI9phApKG9rzf3ocD/4MPsms6hQ/I65Lwn7x
	 aT+dVyza1vChMcVYM2qKP9KsbjfI0QAZGn63WFUmkv7tDFaSBd/sHfhKFwgxPrX4kj
	 cMCVjvJMhMqHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 10/15] RDMA/mlx5: Set WQ event handler
 before firmware RQ insertion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-11-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-11-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:30:54 +0000
Message-Id: <20260915143055.43F691F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> create_rq() inserts the RQ into dev->qp_table.tree, making it visible to
> rsc_event_notifier() before rwq->core_qp.event was assigned. A firmware
> WQ_CATAS_ERROR event in that window finds a NULL event pointer.
>=20
> Move the assignment before create_rq().
>=20
> Fixes: 350d0e4c7e4b ("IB/mlx5: Track asynchronous events on a receive wor=
k queue")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D10

