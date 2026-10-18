Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE32E8DE3
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792325480; cv=none; b=jOtsnt0ftAmcAaxJJ7g2TC9OCt14LNECaHqy1RtVVISR6AowlWa1rHfhxwo+Y0QAkPVFF+bjT7ElA+sU4QvPQ2QQNpYlM2Woh0dyndibR13JwQe7pOlm4oSE+ou8ZVrYRpdA/TCaMl5YkwnC/4VmUvkiaZ/OTx5AC+dC3bSSzgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792325480; c=relaxed/simple;
	bh=FY+trsvlOBu5gzoQJ/S7QIwenIw5zifSKNjzB6h7Dng=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gAasU0fUisRpOVR1CA73oITj+mjsTo1BBVvgVz98TCcGhdZaipTvTE4v2xzUgOkHlzDS5zxhf9tuVMHWj1XgbyhNBlWvFptIm6aqedy5jGKf8tu1qcKL3fZv+YWvZ/cXVK4fzDDIL0b6mS8WqXrb0Cld3st25TblNd5a8GjU2ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuGQlVcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuGQlVcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053251F000C4;
	Sun, 18 Oct 2026 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792325478;
	bh=XJ3nA2sQ0pEl4Fb6BEOWqphahqYtSNIpJfB4HenpQSA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UuGQlVcW0fGpadoQsDL9UznNN1Agio6sP5HIU8cvvvLyWi3QTo/ER2wPJsx2E3p6z
	 XVLjuKhHO5ovpp5NVza4TAXSaWJ0QJZfyKTjr3y6uHrONzn6pPL7Sc0jUoAJywxniy
	 on6vqI2oUt6NWrW/dOK3ZMCqlIQMiiZkqdhQ9cZM8thtjzhA1uXaqbLhWltUKCk5/7
	 LHM36cH0wvrf2G0uy3mzFcPLfbDuLbSSCxG36xivhuamw28qSHdc54cIo4oNSvj57+
	 R73ScwngBrkvvg9caosvav8WTE7qXghce3G7MBcX0R9SgO+VOeeSC6l8o0N+cVfDIL
	 X0kKRXlQ4hxKw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org, metze@samba.org
In-Reply-To: <20261016180901.3292775-1-jmoroni@google.com>
References: <20261016180901.3292775-1-jmoroni@google.com>
Subject: Re: [PATCH] RDMA/irdma: Fix PBLE_LEVEL_2 FRWR generation
Message-Id: <179232547578.20005.9821579536119545230.b4-ty@kernel.org>
Date: Sun, 18 Oct 2026 08:11:15 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 16 Oct 2026 18:09:01 +0000, Jacob Moroni wrote:
> When an FRWR is posted with only 1 page mapped, it uses a
> direct mapping, with the page-aligned DMA address provided
> in the WQE (reg_addr_pa). This address is obtained by reading
> it from the PBLE that was previously populated during ib_map_mr_sg(),
> but it did not account for whether the original allocation was
> PBLE_LEVEL_1 or PBLE_LEVEL_2 and just assumed it was always level 1.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Fix PBLE_LEVEL_2 FRWR generation
      https://git.kernel.org/rdma/rdma/c/9ffd2aa8b53b04

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

