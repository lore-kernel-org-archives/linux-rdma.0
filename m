Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490984;
	b=4adacIHmFf0FEHwr0+JhK6ZGTEbCEJfkgzfH4+KPuFFjzqd7dD+ZeJ1Y2pX2+rMLC9ib
	 UOyn5mzgpn4721ubbtEATgLuHBRMvtnbs8c9u+0dL4TtyrIyPDfZyNX0ro/ketAjCAZm4
	 QTynuDb4MFheACVjmxBoTGyAEg6n11U5GwLsUAcA6aVSvcgmzQuciwZLDVOIT+AagZ/UO
	 pR8t3XZ48mdZtKqlNZcG4PNxGVxE+HMHsUGE4zxcUi/FDLwRxNkY+uRrWxfbMTST0ABZ/
	 1RLFcuCbNl0O1Kw6qaM2Xl28HD8QV17MyDun8Z9siVPLToL9kBsZ+YPOsPzRXp10XcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490984;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O2ubgkCPq7KMIZlpd/e6/gC89juqv40D0k839PTcALI=;
	b=GWkgUFFjqG4KKfyDI5vBnZetFPNDfFkmEUx7gpBcuRZdAJoApPKXmhi/lmexV3vaoQP+
	 C6e+/L1mC1aqv1wRBCjFAjL3BJowbv/h1jWuYdx+dTRI+A5dsxZv7nnNwWPCfCGz5gyzV
	 dbxIsT4kj6RI77DDkGkDogSu0HPw06+0WN0JZvOjT+3AZmSQMXvM205eOSYcsLjVfNdz7
	 aHEZdyYdizS3VfkA9araPJK/P4dBYYa/AreQLQQg5Cu0GJs8N9fWx/wy2ACXi23snhcnh
	 dRknkQVmCi3sZ2ERq8ZszHdSuxNTvjX4O9SksQ2qQVt/aB8MbrDeS/4D5AJ/+YxiNfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeFj6mKR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F632606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeFj6mKR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6131F000C4;
	Tue, 20 Oct 2026 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792490984;
	bh=O2ubgkCPq7KMIZlpd/e6/gC89juqv40D0k839PTcALI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XeFj6mKRwm4d45uDXqMvytJxipO33SlsjGTU6Lc8ZAvF3VRkJvDX3+V/4YMWapch5
	 +UXN2AuD6zNt113/OAKvVkLYHVdtYoiXLSEW9rAX929fdfCB/XCuT+JwVD/7TLwfKn
	 Xf/76zz1jmWPMHNAIIQP4Ejw1jbhNDCGxMFCOPl9A4tKFFYoF+8o0FRMvSyJn0k3VL
	 LtF4EpZ/82KW81KSRGBVsccpunmiZD/ZMY1C60kcTpEonSsAFu5MaMwTttL5UUPyTB
	 wgULe4Gtw4OMvc0ykY7yfma1KiS9UXgtM1q20GRPdsDNewowc7n7r+Uu2tBAsj5biF
	 ea9wqEJcAwzsQ==
Message-ID: <sashiko-outbox-178796@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 12/13] RDMA/core: 64-bit memory keys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-12-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-12-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 10:09:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> A device whose keys are wider than 32 bits has no way to name a region
> through lkey and rkey. Carry the wide pair on the region and return it
> from registration when userspace asks for it.
>=20
> The attributes are optional in both directions, so a kernel that does not
> know them ignores the request, and a region without a wide key answers
> zero.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D12

