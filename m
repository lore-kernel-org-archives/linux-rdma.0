Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244CB38330F;
	Mon, 12 Oct 2026 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810993; cv=none; b=Pum5EQs5vsonYQ7edgDPJkL2cUZYRtBrbpq7GD9fspwAuIun96C4i+imuafZ7S5ITCXeG1zwimcjU95Yuc1J68ra5PvtcjwT0uyWf3HaZxa7xlgWrsE7O0VtYpKU/dU7tARrDDsNQnV/GUpspF1UyiKD4MRaY5WIRZXYMs1toVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810993; c=relaxed/simple;
	bh=J/yQSMr0uJe1VjnFyZcvAFAq45+EbCCZdoO6Rk+QZW0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=l2Zn+6xpFyKCKQIPkmcwHzHyTAuKZ1KRwEzGcV/AZXcwMJuAWjxuaQ/TQYxc9yeTtjh+Zv7VUoR5/zMNOtXNi+hDKSWDVUezAur5mZsvh4tdV8m/H/N3C3cZcdMwBLcV5E5JkfRKxSrZ5aZu1e2aj/cTt/SnTUV3ByIa4mXb3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USLTIu8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USLTIu8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528551F0089B;
	Mon, 12 Oct 2026 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810991;
	bh=J/yQSMr0uJe1VjnFyZcvAFAq45+EbCCZdoO6Rk+QZW0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=USLTIu8Y5IsIfwzzjmhk0r/ZY0hkSga/trnJSFSVZC44YRjWVrBOnH+zNeTzWCINg
	 rb2d6R5uvE/1HEmYoALENAkZ43CQ+6QAmy8UnN+gr9ov1t5FW/Y66Tplrc/Yk1aqpE
	 NiUbbsEnAtbEth8zWzJMICY4OtYQhsgTuSQVBidC2WH/gRFXiwbwxb6Bl4aVZJfbbL
	 lIzd8AMN9u+WfIZNvLayhKZ+zZULa7b/TrIi0l4x4UOlx0+8S7qfyVxA2PB6O+Xnpi
	 ZpzsmZLBK9bf0/QPZdjjUNYy/7qwGgvobVTS5JshL+JCJB2FcHLMo2lNj/+JY/wR+P
	 GLOrsZsqCeOKA==
Message-ID: <sashiko-outbox-168157@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 15/18] PCI/P2PDMA: Document TLP-class routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-15-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-15-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:16:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> The P2PDMA documentation stated that the mapping result is not defined for
> Relaxed Ordering or ATS-translated Requests. It now is.
>=20
> Replace that paragraph with what the three TLP-sensitive ACS controls do
> and the table of outcomes per class.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D15

