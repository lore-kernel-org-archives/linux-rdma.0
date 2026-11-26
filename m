Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719076;
	b=3R7BRgHxmeaUHyMo206+FSkQbehZFneae2hrcLF+nGUiU+C+EE96C0R/O/bTqeUCEM0J
	 eZFYtrrOofs2K/6KvTh7h44OdrEZ8BYRgxphy5mGJYJEuH7EtylPCGq0+1x8lrt0VtEvN
	 exPfpiy7BcOUxOQz0jRWUDy7YsGtt5Cl1iiPGuIoxDeGRA43Dg9mo6k/lSeXc+T3nXls8
	 2x+MJrpFIdPOJtj7m4vy+7XxIAXDf4k6tjzcUhf28ttPcprxSm56oDRxTnaBmin59QTlV
	 6jkkZ1M1Ip8UffZxImR0I/UikriK3S4gB4gLMLFm/IupfgT1Rfq7MVpPGJvJu3cTDPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719076;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=hQaebldOOXR+0z72j/Jmx8hvjej4oCEwDMhBnv4JpIw=;
	b=BkaH4jFu7SiBjzB0LyNlIrm/CCFbug43ANstuCSAP13FmWRXu7nhIOFoccdxNZ2lrBNP
	 xGeni8MfaRYT+QCuKYTyfKh7pvt7M6P9Zq4WTusHxDF/EmFM5/LbK8KuhEHbcB+xnjAD/
	 mNBNfBdPFD+Snwtrh+FU2mTSdFwC/+ZPDRlVLC9I2C+qpky9xXNaiVtHSVwn8p4p/ivVH
	 oTTcyANtg3MAqdgLoot4a+BphfL+kcJpr4KxN3sRP6PLZt7roksw7ugsunaw0NFNJDe9u
	 TEe9gxjROoyaWIfM8Kbb49chd7X8NjWDCk6AzbaxDGssJhbtDFnM5ZU0/Oqny5H9sUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Csx0Gjcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6665606A31C;
	Thu, 26 Nov 2026 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Csx0Gjcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BE41F000CA;
	Thu, 26 Nov 2026 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719076;
	bh=hQaebldOOXR+0z72j/Jmx8hvjej4oCEwDMhBnv4JpIw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Csx0Gjcvob7gcFsPwscxr1mhLUlH+WHhXPXxzo3Au1M6kn5jkOJscT47e5+RoKM7V
	 gkPeZcO6NoC85ZKjXKRKgY7K4Z7STcbehRweUhV1srMM142d/rBGCV+r7gQ0jDoK00
	 /CcOISe4lRgctBQp9IoXaNFXluV+AnCsAzbAw6Y+gLcs3LDLNIj8LFygBeF4l1ZCeY
	 redAYO+aOgwE9eaqEmD8UGH+2T8CAtqreIVfRhHQRGnkGIAaTQiluy1eHCS85+hb1w
	 2364IMo5q+/Usvr1ZDmO60KzXeWmn93n6U45+bWHtuH2UNfcwPo0DtfB4DveaTXf+t
	 osqXlmgRhNipw==
From: Leon Romanovsky <leon@kernel.org>
To: zyjzyj2000@gmail.com, jgg@ziepe.ca, 
 Cygnus Qiu <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 yanjun.zhu@linux.dev, stable@vger.kernel.org
In-Reply-To: <20261125204024.517458-1-eritque-arcus@ikuyo.dev>
References: <20261125204024.517458-1-eritque-arcus@ikuyo.dev>
Subject: Re: [PATCH v3] RDMA/rxe: reject MRs whose iova range wraps, keep
 ODP lengths unsigned
Message-Id: <179571907313.1292280.17538889277660912578.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 13:51:13 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 25 Nov 2026 15:40:24 -0500, Cygnus Qiu wrote:
> rxe_check_pagefault() bounds the ODP page index against the umem inside
> a loop over the pages of the access. When the access ends at 2^64,
> iova + length is 0 and the loop does not run, so neither that bound nor
> the HMM_PFN_VALID and HMM_PFN_WRITE checks apply. mr_check_range()
> admits such an access when the MR's own iova range ends at 2^64, which
> rxe_reg_user_mr() accepts. __rxe_odp_mr_copy() and the atomic write and
> flush helpers then index map.pfn_list[] with (iova - ib_umem_start()) >>
> page_shift, which the registrant controls, and the page derived from the
> entry past pfn_list[] is copied to or from the peer.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: reject MRs whose iova range wraps, keep ODP lengths unsigned
      https://git.kernel.org/rdma/rdma/c/2e8b1764bc69d5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

