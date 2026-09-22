Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68035237BA
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067336; cv=none; b=DHqzMtYvWzswmGYi60Ph9YHf5Aj1whLa2bQW/ggZ8vUTqCAYttdmHyGxaD5kb06UxeN10gUD6/J8gZzOg6vUEzQVWk3r4iJPcT19/tpdA5BAUZRq/3ooBwYHg48tlgO0NGTXAVyEsxhmgrJRb2jIjj224BQWjxbkKjFI6/woq/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067336; c=relaxed/simple;
	bh=oU18Z0ZKm7JSsXtsN4qClQv8AdqFJvr4qIsoDZ8vPF0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IuGRXfwbW0SYkEYu3yCU3HWMIs9z9ZYJHRRTIr5dk7oKk6wwzsYamHNcZoeFCuGBOnuR5fOtmW0TIPpTTyRn1N5Q4ncrgV+/8G24IpT+qPg3Xb3jWXD2Yc2nXdYroYX/ldTEvadRP0QgJUy4Op0uzx1t7tDuA4DQ46nM1f9dEI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZe/ZdYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZe/ZdYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214271F0089A;
	Tue, 22 Sep 2026 08:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067334;
	bh=2CH98OUlBaopYxx2xC0nvYY3iJvctfT0QRG0wTx0WAw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TZe/ZdYF9qPCyW9bDA3nR+5nrB9aweqjp96mYcDlnCz28Xa3gwyTw/yIreZNkENm5
	 6qbusNL84IKsmjnyE40DX0UQkSJ3kKzKi11h6/3I3KQPamISXUlCouoh4df3csH4S1
	 DmMXqiH8zc8YtSPOTSM/WzhahhTRKlHC2LfAPcdmHXcnjd3gnD5rsZeIjdS4hHqAKr
	 mRTDAWMkhamIf9qF+XFpLQw0wgX28fdKRKcjZ0rk2mhi2jo/ykVWBmBIZLcHZA00as
	 s2+5j7IqGclf8RJBZvzEzUjv3FCD9N2c1HVyYLqZVLo5/tm0d8GcPzXrUvkAQuIQYf
	 RhgOpyRA+XNRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3] net/rds: restrict the rdma_cm ids to IB
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922084837.390414-1-achender@kernel.org>
References: <20260922084837.390414-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 08:55:33 +0000
Message-Id: <20260922085534.214271F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> RDS only has an IB transport, but it never tells the rdma_cm so.  The
> listener created in rds_rdma_listen_init() is therefore installed on
> every RDMA device in the system, including iWARP RNICs, and the id an
> outgoing connection resolves through in rds_ib_conn_path_connect()
> may be bound to whichever device the address resolution picks:
> rds_ib_laddr_check() only vouched for the local address being served
> by one of RDS's IB devices, while cma_acquire_dev_by_src_ip() walks
> every RDMA device for the same address, so a software iWARP device
> attached to the same netdev can win.  The event handler then runs
> the IB transport's callbacks against a device that is not one.
>=20
> The rdma_cm has an API for exactly this since commit a760e80e90f5
> ("RDMA/core: introduce rdma_restrict_node_type()").  Restrict all
> three ids RDS creates - the listener, the per-connection id and the
> probe id in rds_ib_laddr_check_cm() - to RDMA_NODE_IB_CA before they
> [ ... ]
> to take; this patch is hardening on top of it, not a fix in its own
> right, hence no Fixes tag.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084837.3904=
14-1-achender@kernel.org?part=3D1

