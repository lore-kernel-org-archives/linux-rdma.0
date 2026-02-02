Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE336BCEC
	for <linux-rdma@vger.kernel.org>; Mon,  2 Feb 2026 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770041837; cv=none; b=P8v0NtoaRPhfXm1Vi3Ubgd+FX1Qd0zBb4X/YGZtCAnRrMJynXUV2Enyx1FUDtzRH+iS4NUNY7nIt15FxqpzSabwejAYVsFur/RVvdIZl5eUmQCmGP/goJPigeGuztXwNhz8CZHyUH1pSN3BkM/KIj8TCVYRKtQmvQX8wInltBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770041837; c=relaxed/simple;
	bh=/OpYWqxjJ5/Girq0H99XFMT/aIo4WclA++DpTiqktv8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QNGOjPtut7zKYYlaURDtCgg/tnXfHxQ8py60kmdJACj5R3IlhqxEqH0epXvAX9hkrGe+DNfgmlMi4vuRSgxtm9Rb5njXlaLHF4RZVXV1WWD+6QHSwhP04krLRbqM5Bdgh1KuWxeYSGU8grzYPYyXIin4Iuqn/rDDK7c0luQCgGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qogUNlIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qogUNlIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A22C19425;
	Mon,  2 Feb 2026 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770041837;
	bh=/OpYWqxjJ5/Girq0H99XFMT/aIo4WclA++DpTiqktv8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=qogUNlIboUYOLkC0cVHxJqq7LpADQqUIWRtKRL/UH/Ne6uzcTO95vmT5gYIDTwV5N
	 1s2kKti0usgjvIEOzggKCGw4L6zMJMv6Q5rZdDU5iCBdaFtglbUWxJoGPl1163KrSQ
	 4Vh1DioQYr630Sl7KzTlA/OPS3Mf2EA3yCjfTcoisuALHZipfS0XOfKNGqVxQhFV+C
	 Yls/ywRjBLjrXalDPZ633+ShrOjZFA7rs5+2vfCKVkZGpfkOoWLiZHbcr2W6TOme75
	 IdK7JXpoEnJ2C+8qSQ0HI6b9R24kNToCQ4k1TvODjHU6KY+oCjQwBEF95OR5krB/1E
	 RSlnjBkclEMww==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 selvin.xavier@broadcom.com
In-Reply-To: <20260202133413.3182578-1-kalesh-anakkur.purayil@broadcom.com>
References: <20260202133413.3182578-1-kalesh-anakkur.purayil@broadcom.com>
Subject: Re: [PATCH rdma-rext V4 0/5] RDMA/bnxt_re: Add QP rate limit
 support
Message-Id: <177004183428.113822.7675525707714945870.b4-ty@kernel.org>
Date: Mon, 02 Feb 2026 09:17:14 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Mon, 02 Feb 2026 19:04:08 +0530, Kalesh AP wrote:
> This patchset supports QP rate limit in the bnxt_re driver.
> 
> Broadcom P7 devices supports setting the rate limit while changing
> RC QP state from INIT to RTR, RTR to RTS and RTS to RTS. Or, once
> the QP is transitioned to RTR or RTS state.
> 
> 
> [...]

Applied, thanks!

[1/5] RDMA/bnxt_re: Add support for QP rate limiting
      https://git.kernel.org/rdma/rdma/c/e72d45d274d8ed
[2/5] RDMA/bnxt_re: Report packet pacing capabilities when querying device
      https://git.kernel.org/rdma/rdma/c/13edc7d4e0aa4a
[3/5] RDMA/bnxt_re: Report QP rate limit in debugfs
      https://git.kernel.org/rdma/rdma/c/949e7c062d3769
[4/5] RDMA/mlx5: Support rate limit only for Raw Packet QP
      https://git.kernel.org/rdma/rdma/c/cae42d97d94e9c
[5/5] IB/core: Extend rate limit support for RC QPs
      https://git.kernel.org/rdma/rdma/c/42e3aac65c1c9e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

