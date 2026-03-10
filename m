Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A46012CDBE
	for <linux-rdma@vger.kernel.org>; Tue, 10 Mar 2026 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773171030; cv=none; b=j4QkPvHpoTZbGvufTTyij13cqDrsiaHx6Q2mNvf36nbKkmufUZ/fBEvnkJGfVX0Udun+4Y2gUu+ezUcCz+Qw525Yri6upynRJU/r2yjxR06uxW2GFb477TPu6MRMPZlzwDCVxO8RLVBoofF/r52qX4WHAHsmeqlVeoNkefMcfGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773171030; c=relaxed/simple;
	bh=AxsGAJShiFmYEgIJGwA5cLZ/6qmxku6zfERljgpqgaQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OCiyAmxLHvZnlPf62DXx2h8XP9DNrmz0EZxmgERB2+TobDMXV/PeCuCDc0Ofrj9zraOBpG73ofIkYNIWVOtns+xLO4WFPESx0Sn/Qg4J5c34c2+4qX34RNxnxVOdckzyTfj19lsL05IK3+wXQUfY9PYnbZyt+Jyq8FYwwfzcQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kJeVOR6M; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kJeVOR6M"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773171017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=plJwI+8nzhuQRSmtRc0cV74P9cmPPneeAq1m85TyRJw=;
	b=kJeVOR6M0qJO2hZAdEBURTknzjO+CMBJfhMjuq2DDeoBH1m2Z0nhcAcSk5QFhRouBPtFX7
	UtNuHYK2ocFayfoCRLfHq7yMv93N74GLHvtmJqw7usxMCbJY/6KKFTVJZruxQTaZiOeNsu
	7con1/z5u+S9jvXY88UVGEQGrT/0L34=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] RDMA/mlx5: Use clamp() in _mlx5r_umr_zap_mkey()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20260310184744.GI12611@unreal>
Date: Tue, 10 Mar 2026 20:30:02 +0100
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8CF104A4-D411-4C7E-8379-F41055B0EBD9@linux.dev>
References: <20260310145727.236094-3-thorsten.blum@linux.dev>
 <20260310184744.GI12611@unreal>
To: Leon Romanovsky <leon@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 10. Mar 2026, at 19:47, Leon Romanovsky wrote:
> On Tue, Mar 10, 2026 at 03:57:28PM +0100, Thorsten Blum wrote:
>> Replace min(max()) with clamp(). No functional change.
> 
> Are you certain about that?
> For the values to match, page_shift must be guaranteed to remain
> less or equal than max_log_size.

Yeah sorry, I didn't realize this conversion isn't straightforward.

I also just realized that clamp() is defined with if/else semantics in
linux/minmax.h, but uses min(max()) in tools/include/linux/kernel.h,
which seems confusing to me.

Nonetheless, in this case it doesn't seem safe to replace min(max())
with clamp(), and I've learned something today. Thanks for catching it,
and please drop this patch.

