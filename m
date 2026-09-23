Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39898446C19
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153670; cv=none; b=BnrO2kJ8n21DCbp2Q62vWyO0vZUBUet8xVALG4X9lJPi0QeWq1JkvFHbKjr6zmxKFHOi0IhaeWs+EbRGpxDBLfOTnX1o5ETmC+tNcCQCCQn7F0Ncr0Two6bDzTO2yM1zj73IKpreWHFbQbMZOlmd8dAjwYLULJt8TU7H4g04ShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153670; c=relaxed/simple;
	bh=4kTvXAuK/H2USjSRuXE5e+/bgf6AzarrPls8yNOBNxs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qp2wxvFxiI2qqYP4qYwE3STejUmiZu7MVKZVOkwVAIUjA4Nk72ypbFTPyjT1g/F2f/5WQ3M+DZIp7kA8LFyvZM0KAOi8AmMHlD1O2jkI6I8Fvjyw9z+7lklcCdxaDLa2l5s6ahi8DoCMf8NCYZuXoQ8E+FInapKZCE8XkziPObc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGxKv5/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGxKv5/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246F61F008A3;
	Wed, 23 Sep 2026 08:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153663;
	bh=P6Acd7HWQi/1ktnxd5QRo4bllbGtZKBRPC9gk8NVp2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nGxKv5/e9t+d1F43Zt8MB7ETOYqWK71IIC9+YwBLPGTlCoO+OnpfFz/u4TiFpCacu
	 YMNZOYb8+aI1y7F20Bl+ijYjCLKsz9qydcq21almn9aLVZBF/1JSByYrWqlgYG8TTd
	 njlV8yu5++uI44j3kdjIW0qCI9j8Ck0yGEo87A69w3POtww8rty4Y8TYlaDz2Ot3ur
	 kkaxTEKtJyaCbZeJFPdRsQxu0UZpWQrcyS1NO/0VEVs+gfFSMYXzju0y7agN+AEeG6
	 hFqp4/+2snmjvFOlZww6g5W21NvOWHLRTVZvPH01tTBqWBI/6Bpf/8u0lQ8aIdS4Lc
	 CPlGDlbLAAcLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-4-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:22 +0000
Message-Id: <20260923085423.246F61F008A3@smtp.kernel.org>
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
> single connection.
>=20
> Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize =
netns/module teardown and rds connection/workq management")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D3

