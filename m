Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C72E8B98;
	Wed, 28 Jan 2026 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602739; cv=none; b=FX+EtJPjxv3cgFa5UFkk86o85SSRvJ9VpNsh34xUW11Xzy5MFgvMRM/w/u8sW93lZPyz1OFFlhSyFYFFg4+9rZ26r5k+YadQhK1ZXYKTfQbpCZAcsopu8cpW0PbBzQa/xrGljzNsrxYE0Iupy+4Z9h82o1G/b6lpQOzjvyNZvLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602739; c=relaxed/simple;
	bh=F5pQw1a6a+SIfvOfhXS7H2+dwAt6MCZdib2T/iPUi/Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gPU6HjkxsRcDTLvgWLqNxvY9JNgmEZwxQOgA5A3UWaUxFBEiaRnGUvZos9PuIe2fNStTYwspU+v19eQmhZeE4dnz9YdO+cGjiryVpGtZxgcltmdkJ65DYkQUPRT6LYrdIX052ieiZoniL+N2l0GnyL9ZrSg3DNGnBh9Hd1T1BAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBgxhgh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBgxhgh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A698BC4CEF1;
	Wed, 28 Jan 2026 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769602739;
	bh=F5pQw1a6a+SIfvOfhXS7H2+dwAt6MCZdib2T/iPUi/Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=FBgxhgh2Q6oZVNxrE8LGLmSt07AcCeGpuxr7w8TcNlm/k95qTLBen2XWrsXGetbZQ
	 gQOWwlshwpF2+t2pd71om1/uHTKAFZ4nkUeUCRqplS82F8Yj5W3JilMMB9GegtqdZk
	 IOn4K0F0jmyMN9GkoO2plN1lVEU51WdAP0aTHEyGvSEEGXihkiRnE73paYRaw2GV3g
	 M3/iB8JvCBNfQw3VAmH8etTuAj3vE8p8FWEMTMQfsFuGPUo/QO0YRY2rbqTpNMOatA
	 XzGq8VTamp4BaDGOFowOUQM0oSL/smRjqEwvl2TFYq1JT12ia/jFkzCTrpP/2SG9s6
	 VCt1A8Vv+He4A==
From: Leon Romanovsky <leon@kernel.org>
To: carlos.bilbao@kernel.org
Cc: Carlos Bilbao <carlos.bilbao@lambdal.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>
In-Reply-To: <20260128014446.405247-1-carlos.bilbao@kernel.org>
References: <20260128014446.405247-1-carlos.bilbao@kernel.org>
Subject: Re: [PATCH v2] RDMA/irdma: Use kvzalloc for paged memory DMA
 address array
Message-Id: <176960273607.35487.18087501676811274121.b4-ty@kernel.org>
Date: Wed, 28 Jan 2026 07:18:56 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Tue, 27 Jan 2026 17:44:46 -0800, carlos.bilbao@kernel.org wrote:
> Allocate array chunk->dmainfo.dmaaddrs using kvzalloc() to allow the
> allocation to fall back to vmalloc when contiguous memory is unavailable
> (instead of failing and logging page allocation warnings).
> 
> 

Applied, thanks!

[1/1] RDMA/irdma: Use kvzalloc for paged memory DMA address array
      https://git.kernel.org/rdma/rdma/c/959d2c356e32ab

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

