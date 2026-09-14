Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755C244CAFB;
	Mon, 14 Sep 2026 12:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387812; cv=none; b=s7G4hOplwfMm6ugMC1R16sGSDUHM++R8pY7AtEDIAQqJr16KgvirFz1Es6LH3m7VM7ChTXWYH/zOL+4A+vOfVELHMGGFd27y0PnhBXQ+YdQgAr68xdgQJy6DuLvNP+/1YOVoiucS863RWSCQEB/P0YSKlJsRwTaopYokAcqyTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387812; c=relaxed/simple;
	bh=a1Dm1iDUftrgwWmqeEj0ag45Qt6coZ5OKqNcNwOpcxc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DTIa4LQ4CfrAu0UYea4ZDRiyrteA0YPD6aruLdswWmwlqzy8RCEE7iIcGD/eDTUP1YvJ6kHBj07MuaKUZ+tlYKQF7NkmUBlyEknR8CKS/ogI881By/mfp719FhpJo8i80jmgZA90RclcD1Cyr4HZa+TpefZKaxP7NxRUrE1iMR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQ0lzCbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQ0lzCbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128401F000FF;
	Mon, 14 Sep 2026 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387809;
	bh=mXx/TndpDRT2oBFFbCreBr+6apbVIxKnYsg4iSBp4Ec=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RQ0lzCbhgstDWg7J9bXi1Onfnw0de2OOL7na0qgVF3R50kKglLT9GrEXN1Pimuqr7
	 4LTd4TZjqQRsEEu4ZXzUFAyTZ5SXNExGYfwQoYYlAbsZ1BRGGiibMY8nMP8/KdAcgm
	 1W57Gh061pZomkwHqx3G6FpSW37dzKralWHmI5vgaPrytRLv0reaYlSnd5w5zP3FWS
	 x+Shl1Fv+QUFpJE0g8oZJwFitbelj1/C0bpZi/YhnRkWp8NdWsqaF/6hrcTftxIfYd
	 09X3vVgHOC7nYib/qJnkYxoHKtUiEvSVW9wgdbHEet4BeJ0AkxpW+8/QG41aDHCJNy
	 hqJjFFUwSAwfg==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Tristan Madani <tristmd@gmail.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Nicolas Morey <nmorey@suse.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260909160132.1491248-1-nmorey@suse.com>
References: <20260909160132.1491248-1-nmorey@suse.com>
Subject: Re: [PATCH v2] RDMA/rxe: Use validated num_sge in local buffer
Message-Id: <178938780667.974012.344479087887135840.b4-ty@kernel.org>
Date: Mon, 14 Sep 2026 08:10:06 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 09 Sep 2026 18:01:31 +0200, Nicolas Morey wrote:
> For both SRQ and non-SRQ receive paths, the WQE is copied into a local
> buffer to provide a kernel-owned, validated copy. While calculating the
> memcpy size from the validated num_sge prevents overflow during the
> copy, memcpy() itself still copies num_sge from shared memory.
> 
> A concurrent userspace modification before or during memcpy() leaves
> an unvalidated num_sge in the local buffer, leading to potential
> out-of-bounds reads in rxe_resp_check_length() and copy_data() causing:
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Use validated num_sge in local buffer
      https://git.kernel.org/rdma/rdma/c/112f2b6925c2d7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

