Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5B613B5B3
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 13:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724811; cv=none; b=pTFQOujRfN5qqtsRGDwJCj6zZ1MHy1Aywq8pJb50836BqvKXjdK+8Sndi6LbmbHehIzfRHCwYfieJE6PJHm5aWt5Jv2Yw56++fSgALNbB2Y8u+kxXdAlKB9Z1YOfe1q+NOkNywFyyd43F9Z2/ZEbt5z7SvcKRpA7kbZcCpAHzk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724811; c=relaxed/simple;
	bh=xfNhOTQfIHNl8rvdoCjh2TGyGqMUNgQZM4F83PK8XnY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VSNAibtnhFFiV7Sey/bUa9qXA1biZCYp+XJbBZIWmelO8fKb7OC/ygpG+i6OhvYzAj00A/6J+Etma+Mh9gRYDoeIXFyHzJKVrPYKY1PEnNtia7kDnVhF5BFuoY81CpvmW0ILO47feeqTX5kdDBplCvJriTIrRlN5rdbMaky05B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmBrfd8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmBrfd8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E28D1F0089B;
	Sun, 11 Oct 2026 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791724810;
	bh=mLmCtdWWS3L1aLaNcC8BVsRm8jtQLJifjJSq9MV0utw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RmBrfd8XcjFnSqsdIIlp/GdSKLBpC2tMt9Ttl2UB3r8ByzA7+YkQvuMFXywSZReSA
	 ZrbIc3RIV4LNSk5Pu5qObh8aZQ2rjXLzFxxolGE/N2ybDVUT+fLfR4923yPs2MA+sw
	 ZLzARJopRmjztUVKQiiwZvHIQE8KU0th8DdDG1hzeVbBRafPsVgZhJs8PUSks9Ad3X
	 DKTjLMq5ebEGIwBIFqXR8sJKyK8jPxdy5d/71T9Qnhz4JPB40M31wHWIQk8w4K2z3K
	 FydXluw8ZxWrw1zYNssdo13MDYbSKpuJd2Miq/5g+98bUmHk+UCJHriroVg5r51c+L
	 nR6gKqY3jmdTg==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006152908.888059-1-jmoroni@google.com>
References: <20261006152908.888059-1-jmoroni@google.com>
Subject: Re: [PATCH v2] RDMA/core: Clear driver_udata before destroying
 objects in rdma_core
Message-Id: <179172480700.3150335.10638168750363188058.b4-ty@kernel.org>
Date: Sun, 11 Oct 2026 09:20:07 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 06 Oct 2026 15:29:08 +0000, Jacob Moroni wrote:
> When uobject creation fails while copying user output data (i.e.,
> after the HW object has been created), it calls
> rdma_alloc_abort_uobject() with hw_obj_valid=true which then
> invokes the object's destroy callback, but passes the
> uverbs_attr_bundle from the original creation command.
> 
> The issue is that drivers are expected to validate the udata
> and return an error if there's unexpected content, and data from
> the wrong command counts as "unexpected content", so this ends
> up causing the driver's destroy call to fail.
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Clear driver_udata before destroying objects in rdma_core
      https://git.kernel.org/rdma/rdma/c/d37e98844afea3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

