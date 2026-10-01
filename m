Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BF640910F;
	Thu,  1 Oct 2026 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855897; cv=none; b=UZ7/tQLUSA5NAjRJ1YiRVkJITxqbTrZPlAy3+lVMpv0LmgyixmLxisxcGtMOO/HxG73p8vYL5OklSULmv3Mi7ksOrujK32DiPnVbI2PAcaazyYcz5nY6PcHnj9Je37exx3niXh7rj1BtOt7G2HcoZiSV/fiQctZUmaX5OE1nlvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855897; c=relaxed/simple;
	bh=BIQan3/ClmeV3Y7g/xTCMnl6f3UCtjGKp4VR/xu7dwo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L7TY1OKSh/cURoTpoXY+TVASUn+QOQiJkCVpDBDmez7gIMNs05NKgS3l25l1vyaroxq9Co75DgBVDeAR4legMR72FOaalr0cl/dGXH/eCm1WFNR2Zuz8oBo/2b7VAZR3w21sLFBQvULUwbpf5Or2PE1xQ/YRD3EmL+d7SeOp1MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYyd4L1s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYyd4L1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BC21F000FF;
	Thu,  1 Oct 2026 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855890;
	bh=BIQan3/ClmeV3Y7g/xTCMnl6f3UCtjGKp4VR/xu7dwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FYyd4L1smGcDXlFtNbNGuTTdfaBUKl8qB4uWV1ds3nOaMpg/5y7rBURoA8YXTUFGV
	 gci5/tY4w2tcJSRzgCgm3ISDT1t6h/AcmCd6cVsIZgmvFtWAzkNogfOhQWv+fFxmRh
	 DGYAqIcStlyv5b3JEYV8sxaew9nRe9ywcZ0JGngmSAmGAhmiuyE5sKN2ArpswWTrEL
	 L/JCuRCw8ETh7v0HK7f6GJ8vWSnTvCHiCK7Skksfgo42G1UTij9f5T4OMHTaETqGTr
	 5rtqxaXzrWp9UgvgQ1u9d6+ASH3TcjRNGMvEAbGXIcuUCVBoDMvaOGocJk16Z+ViNd
	 j9herOahVX8mQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 01/18] PCI/P2PDMA: Document the TLP attribute
 assumptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-1-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-1-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 11:58:09 +0000
Message-Id: <20261001115810.59BC21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA selects a mapping without receiving the Request's ordering or
> Address Type attributes. Its ACS handles only strictly ordered Requests
> carrying an Untranslated address.
>=20
> Document that the result is not defined for Relaxed Ordering or
> ATS-translated Requests because those TLP attributes can select different
> routes through the fabric.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D1

