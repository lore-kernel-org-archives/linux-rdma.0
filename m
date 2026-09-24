Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356248F843
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246510; cv=none; b=ECst71aAPN9SvNRxrzscrnwbOs+p+bSSTPGsc56r65jV3Sq0tWtcXAvWa4Bn+WRTiS8P7iGWPyb41FtNTd5x9udq2AScIdTB65A/R2sY7GY/viCimEezyFqfVHdrolX64f8RiEjDp2kbAvdfjsBmTakENH5J5LpyQmsI+ebgPPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246510; c=relaxed/simple;
	bh=NznmwH4SMuBk9U3OE/mcqNGU0SJCeDlzkwpr1iBM65A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JMDexMtBmm6Nc462btNCXSszlVvL0KeMmWS1CmcC3mvf+Pj3MX4lTVVLnD5nXDHYWoYMqM6/E08fCPWNNGcv/hAIrfFLkoqL7m2xjzKS8NZVK/ShMVozFDEhkjTo2Vnx+cH5M+vy8HG9r60054nLTavVWrSWv/mbwj7XxrQStXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyremZDs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyremZDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBCF1F0089A;
	Thu, 24 Sep 2026 10:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246507;
	bh=NznmwH4SMuBk9U3OE/mcqNGU0SJCeDlzkwpr1iBM65A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nyremZDsCp9PRMYocP8LwOYlrxOIsVLzpGRKCjJt7P7OG5aDE6p+lbyqPiyrK6TPp
	 +g4Vxlb0+T/VXobEtQEyUhmq+gV6ru2H5lkbl7SgsaNA0VCebXz17P3o5S1SU/JSUy
	 VGPdgiNh9ctBQYJdynMOba7AI+tdPvEQ87xZgmk1Ubj/epsMyk1nHYGu5QxQxkVdEZ
	 cK4osLmBWautcrgNogiRxOgi/JGbM/mlSTFJr8CrwRGTrjFWboy3GbTEsk+RJ1zXSg
	 6UrZG1Kc9WV7v2q2KbrokHm9HDnOH0sDE/JbPBEqh2TqrmuF4BthAFIUVZmnKdg54J
	 NQyeMj/Evv5Hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 10/13] net/mlx5: LAG, don't print port mapping
 to debugfs in MPESW mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-11-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:47 +0000
Message-Id: <20260924104147.9CBCF1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> The mapping debugfs file dumps the LAG virtual-to-physical port mapping.
> In MPESW mode the LAG does not own that mapping - port selection is
> driven by user steering rules, not by the LAG - so the dumped values are
> meaningless.
>=20
> Treat MPESW as if LAG is inactive and don't print anything to the user.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D10

