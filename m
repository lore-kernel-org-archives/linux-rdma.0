Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830989;
	b=NWtxw2yvN1pX1vGlOBuJVgWuYA3QDiFN8i0AdXmMXGSW8ks4BqmLS6SwKtBAkCM8MhTu
	 qmqJ/yr5xYTymifZwwjPEIGSZuSEil25vleih2lOEWcwJoilwBBtbXAOF2H/W/jUe+bnx
	 HsNgIJp9I3RuCySPaoRIWpnHf8UPJscu9sox16qdv/mJ8v6KCfp9NeLVtu0/5N9Q/8bla
	 xTFZbLhiLSz78He62rkVDLGhhCbZ/CmlqhI1I7wclSTJhArmfMvTmkwqYy0jvhysinVzj
	 8FOglDV/cJEI38v5O650QVtqoVqqi+NolCnF3z1PDuRCsqZ8u1fhll5GmBBCoTFQq5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830989;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Fg2Cyl3OB9tAf+LGvQDahZZf2WtHr0QESzXY6AOus4s=;
	b=aXoETc3jmPtDyfKZIPUAkUBRUwrkO4hVKcwv6o8WuUonb0sJJFAelhH5cYIy5Smyadyz
	 vg5Oh1DwuEn9MNcQMQ3+8zLDXNODY/uHxmdy5haHKcJXKrbipCWlyNm+1q4bmaIE4SqMX
	 eTbx3e2UEkRJJqGe5kNYpY6swuY6PUP99sPx27zVS7a//TMJJ53NLxAVUiQb541Lq0wwY
	 ANETZcSZolniGP+m3qTlXJd1XqNW2vcXCSCXMBLtLHQexp2obItLGN7YkjOlaRxaP0sYk
	 YGmk43Gm8Q+HPL4I/vsXi6CpG1RK4lgdFZeKCfjCbxo1nku4YW4BIeOoYTQjky3Jw/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="k+O/mtgV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751B6606A323;
	Mon, 16 Nov 2026 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k+O/mtgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2ABF1F000C4;
	Mon, 16 Nov 2026 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830989;
	bh=Fg2Cyl3OB9tAf+LGvQDahZZf2WtHr0QESzXY6AOus4s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=k+O/mtgV+wVoINW9AEgi39fd7DxoZetiwUUfB9vVH43UPSfBBXjsEv9blwMdYF87k
	 w+dwNIIArl7y2sziSvbaE8Cop3wWOU5cBzcv/PN9d08YwIWY3yrdPsgu9Z13OwX80z
	 xOMVVupvxYJN1LSBxEO3ZGqWd7Hao//YIQpT02LJkBg/YkcY9tVswvj7Q+fuoRNhYr
	 bydvLI4/XSJs3gfwEolG2p/84qVCs/FVnH7lAT73IP/I5mHMGG1go6zr4sGsGMTMW/
	 F0DVxGH/0WuJK+G88HayBxhx9yKXx9FdGU9O3tmlBqTJ1k1xjY+PSy0e9CM1GNqVzN
	 4xTdZo8kJFocQ==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com, 
 jgg@ziepe.ca, Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v11 0/9] RDMA/mana_ib: Add kernel RC and fast
 registration support
Message-Id: <179483098623.1357294.2203280978008836098.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 07:09:46 -0500
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


On Thu, 12 Nov 2026 00:47:07 -0800, Konstantin Taranov wrote:
> Add kernel RC QPs and fast-registration MRs to the MANA RDMA driver
> for kernel consumers such as NVMe/RDMA and NFS/RDMA.
> 
> Implement QP creation and state management, work request posting,
> completion processing, and error handling. Use the RDMA core's generic
> queue drains for kernel RC QPs, with software-flush notification in the
> posting paths. Kernel RC QPs require extended-WQE and power-of-two-SQ
> hardware support.
> 
> [...]

Applied, thanks!

[1/9] RDMA/mana_ib: Allocate and map fast-registration MRs
      https://git.kernel.org/rdma/rdma/c/424f395f5dc735
[2/9] RDMA/mana: Create and destroy kernel RC QPs
      https://git.kernel.org/rdma/rdma/c/7855337ed8f9fa
[3/9] net/mana: Extend GDMA encoding for new RDMA WQEs
      https://git.kernel.org/rdma/rdma/c/08435b61f00ee2
[4/9] RDMA/mana_ib: Maintain kernel RC QP state
      https://git.kernel.org/rdma/rdma/c/6237f2517f4b20
[5/9] RDMA/mana_ib: Post receive WRs on kernel RC QPs
      https://git.kernel.org/rdma/rdma/c/56e3714bd9cdde
[6/9] RDMA/mana_ib: Post send and memory-management WRs on RC QPs
      https://git.kernel.org/rdma/rdma/c/056987a66d2c8c
[7/9] RDMA/mana_ib: Poll RC completions using PSN and FSN progress
      https://git.kernel.org/rdma/rdma/c/0f33f8d321bf00
[8/9] RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
      https://git.kernel.org/rdma/rdma/c/673631f569550a
[9/9] RDMA/mana_ib: Handle error CQEs for kernel QPs
      https://git.kernel.org/rdma/rdma/c/76da3c7497c394

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

