Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543233AEB2D;
	Wed, 13 May 2026 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698280; cv=none; b=u+495YtpaxgtdAUxFNRR4nIgwvhk4c1GE/8YpW7FhsIY97vXCfTDB4SG4bVFnpiZ1QXFwPiPR2GsQhrr22bo6BRUhl5lh1mLrDT7kGpsxWRI6qhDIepsAtP8RiFOYEF4Lm5lvjwVCXzAcbVkcoPW9nhWnxIB6Dr9OGAgeaamsZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698280; c=relaxed/simple;
	bh=lhT7NJBZvan2O6Wc05lY2i0l2fScOUH585qfonxfZak=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oZMo5yxCT2/gKRw4D0nX8DpZB2ijzVBd2n3y3wb5/Ls60iRO3eCM5nZ8JaVUaHDv8ItC5YfUvthgVGUqfWnPz8qGIt4fqbsUYs5clYz/8qXrpTJw6HwHIqQ4hr6vq7zFM/hplnciPFZwiUlZdsMCaF+f1R3J5wfB6/4SGg8mes4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5Zs+AKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5Zs+AKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF44C2BCB7;
	Wed, 13 May 2026 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778698280;
	bh=lhT7NJBZvan2O6Wc05lY2i0l2fScOUH585qfonxfZak=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=R5Zs+AKhMrUXeT4vGc/9h8QGsVEodu9ZK5NVq7RgxgdFwUFyFME6LzIxRC93H5gad
	 wFinXc/J5y9nFxa3OUPRdLKJUWh5or9CiT8A7T3HHea7HhVoAPnR9cr2lskw7MRFAd
	 NagSeua/cnqLR1gLpgW/qV/eTJAHxSRjM7QuuduzVk7NWfZyKMORAaZ2SeAEhVa7FK
	 ElkA+kgDFa1ihFYertbg/eKu0IuYVQBYHEQB8BhD3HZjMlwpJqH3ribAOkt/96sl98
	 aTn/7zDozPNXp3Fi9F4uTtSLNvlUBY/D/uOiIiyjVZYbXMOx/tn7EeJyzHRgIJ7+qE
	 ZYdyj2sAM2YFg==
From: Leon Romanovsky <leon@kernel.org>
To: security@kernel.org, pomzm67@gmail.com
Cc: selvin.xavier@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
 jgg@ziepe.ca, eddie.wai@broadcom.com, somnath.kotur@broadcom.com, 
 sriharsha.basavapatna@broadcom.com, devesh.sharma@broadcom.com, 
 dledford@redhat.com, gregkh@linuxfoundation.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>
In-Reply-To: <20260509084011.11971-1-pomzm67@gmail.com>
References: <20260509084011.11971-1-pomzm67@gmail.com>
Subject: Re: [PATCH] RDMA/bnxt_re: zero shared page before exposing to
 userspace
Message-Id: <177869827695.2371282.12223364694168712496.b4-ty@kernel.org>
Date: Wed, 13 May 2026 14:51:16 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 09 May 2026 10:40:11 +0200, pomzm67@gmail.com wrote:
> bnxt_re_alloc_ucontext() allocates uctx->shpg via
> __get_free_page(GFP_KERNEL). The buddy allocator does not zero pages
> without __GFP_ZERO, so the page contains stale kernel data from
> whatever object most recently freed it.
> 
> The page is then mapped into userspace via vm_insert_page() under
> BNXT_RE_MMAP_SH_PAGE in bnxt_re_mmap(). The driver only ever writes
> 4 bytes (a u32 AVID) at offset BNXT_RE_AVID_OFFT (0x10) inside
> bnxt_re_create_ah(); the remaining 4092 bytes of the page are exposed
> to userspace unsanitised, leaking kernel memory contents.
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: zero shared page before exposing to userspace
      (no commit info)

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

