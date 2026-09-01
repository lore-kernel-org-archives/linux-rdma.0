Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B147A870;
	Tue,  1 Sep 2026 10:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258053; cv=none; b=U2Ws4QRnw/ZE/cPPByBLXIjJHORGsf2E/i58XtRZ1NX6RY4Rvzld5Bmo5CVV5yJL1+tZjxEnRm5LDpue9W/54ljSMOPCQo9W4bm0yHo+75OFI+4TKuuQUkeHKbIUs0yakYFs/H6Jwbre2uq1YyN3K/gdWzpnCzvySA+f0njOe7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258053; c=relaxed/simple;
	bh=VF9KFPboKgg13aVVHcpaEnrHfgX7yIoKDuIe7TI2yiA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iJWEg99AKxWVkxmGOcvSfzqCAzBZ9Ht/H1ytedfF1yvIjaeOb6h2Wieg8MZNj3QOUVhXZUowOuyUKdEJbP8kuIaa+SJcjl1kMPG/fLDinoA2fN7ZdI+IARl4RPsoJwqMdFjS+tqWDtJmgUd8NygOZNQJ26uv/mN6xznPsTKjjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+tg01/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+tg01/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B3C1F000E9;
	Tue,  1 Sep 2026 10:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788258051;
	bh=qIE0bvy4JpZMh89FnsSG+n+9c7Lm7v403flKlMaXLH4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m+tg01/D7q3yFDLc6H0sbwvlMhwZyEyJBjsDPR/dftyRNr2Byyie0ueubJXqtDvK9
	 GHUw9q1J47k5D7T298zxaIz516ZNx/LJn7NaGmg2wOXk6g4UQRCYxllfIgt208UXoD
	 yKIEvR+74JpabomWXWBDPYI59epnrgpydSc1ChTkvYGBjGZIK7QhxQr3f2pnRgfT/v
	 nszsS77nmj95kby7BQ6fkaLI3yKG8oGtgY1FPSmVqwx2Eckl9x33wfPvwXHAdx0ULM
	 jRJn6hSNh8g+sWNJZBTpqbs1Fw/tVY61fEmFbJYxEmBzrWoa7G7B/LodmvFxg3G0Il
	 Wls4hTxboVSQg==
From: Leon Romanovsky <leon@kernel.org>
To: yanjun.zhu@linux.dev, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 Gang Yan <gang.yan@linux.dev>
Cc: Gang Yan <yangang@kylinos.cn>, stable@vger.kernel.org
In-Reply-To: <20260814093740.292954-1-gang.yan@linux.dev>
References: <20260814093740.292954-1-gang.yan@linux.dev>
Subject: Re: [PATCH net v3] RDMA/rxe: Fix integer overflow in
 mr_check_range() leading to OOB access
Message-Id: <178825804838.1146572.5378732546810537205.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 06:20:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 14 Aug 2026 17:37:40 +0800, Gang Yan wrote:
> mr_check_range() validates that [iova, iova+length) falls within the
> registered MR range using wraparound-prone arithmetic:
> 
>     if (iova < mr->ibmr.iova ||
>         iova + length > mr->ibmr.iova + mr->ibmr.length)
> 
> A remote peer can craft an RDMA-Write/Read RETH so that iova + length
> wraps to 0 (e.g. iova=0xfffffffffffffff8, length=8), bypassing the
> check. rxe_mr_iova_to_index() then computes a huge index (int idx, only
> guarded by WARN_ON) and rxe_mr_copy_xarray() dereferences
> mr->page_info[huge], causing an out-of-bounds read/write and a kernel
> oops that is triggerable by an unauthenticated remote peer.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
      https://git.kernel.org/rdma/rdma/c/d10e2a08799e85

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

