Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17FE37E301
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260053; cv=none; b=tp0mGhovh7C+RxiizuC9KTjsZ/moi2hjvL6a/sOB9VmpGzDYKglRuImo/53PLDw4DW9/hXeZsdvXmQGta9bz6rhIPCGqpTKRUWyP69gzwW6A8Pk9168gVjR+c33quQizh6qYqBZvziXiGuWhHlp3Xvcq6/tigry8UqZRVvH7uKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260053; c=relaxed/simple;
	bh=/ulckH4rilkvkBPQjpnfN1QzqqkGizYF5HwfU+wLLC8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KDEw4fZ9bHZWZUw9ZTwPwuePtIKgMt6dZ2Ycb5MLEgp3ALtYtFYiMMAJORMAabWelpfriXhBtt/ATnYdPgjuDxiUWbl7WvB+vpG28Ai2+J+I6LQRIGpb26vI49hChWqGVRQ637EmzZWxcUlxUHdEQiU7Y9eUBC2Ckh22Ky6Z6D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4/tOJdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4/tOJdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3C11F000E9;
	Sun,  5 Jul 2026 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260052;
	bh=QMjiKqu6kLPmdyoHGdkTb4zB7tK0oF29Fo9GzEDmT+Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Z4/tOJdHTeXfgTzIabQ8P/T7pEdcDhIDA2tpoYhgzNtOwe8JJphVA/ags1rKULjB7
	 wrN0ky9ektUEIn+o97YEIvARASrMFjyzYelJbpuWWxhOkkUlprHS6UbOu5mjljMPMs
	 k3eGC+ZxcdQPiG9W0vwqmjiZZu08iYk3BJTGkZT/TITL44xZW7QdGBKpfz9yl2SnCQ
	 GxSaebnXUZcdJ+u5JPKNqoDLJt62001tOs7npV8v5zDOTbUWBRsSPtpm7tMqd7P+7w
	 b2/sVEgBWKpHtCxGoQ+3ayB9qllzGmSopP0uj+S8Hwa5NKmPHsQXcxcVyiKsbcB8VO
	 BS01i6lHuIMIQ==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260618201458.875740-1-jmoroni@google.com>
References: <20260618201458.875740-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 0/4] RDMA/irdma: Prevent premature
 deregistration of user ring MRs
Message-Id: <178324830896.903355.7673142526387836159.b4-ty@kernel.org>
Date: Sun, 05 Jul 2026 06:45:08 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 18 Jun 2026 20:14:54 +0000, Jacob Moroni wrote:
> When a QP/CQ/SRQ is created, a two step process is used where the
> buffer is allocated in userspace and explicitly registered with the
> normal reg_mr mechanism prior to creating the actual QP/CQ/SRQ object.
> 
> Even though these special MRs are internal to the verbs provider,
> nothing actually prevents a custom/malicious user application from
> manually invoking dereg_mr on these regions. If this occurs, the PBL
> is freed and umem is released while the HW may still be accessing it.
> 
> [...]

Applied, thanks!

[1/4] RDMA/irdma: Deduplicate the irdma_del_memlist logic
      https://git.kernel.org/rdma/rdma/c/097f50384e1877
[2/4] RDMA/irdma: Add a refcount to track user ring MR associations
      https://git.kernel.org/rdma/rdma/c/a7d0a6b58256a7
[3/4] RDMA/irdma: Add irdma_cq fields to track pbl allocations
      https://git.kernel.org/rdma/rdma/c/971e99623ed7a0
[4/4] RDMA/irdma: Add refcounting to user ring MRs
      https://git.kernel.org/rdma/rdma/c/f67d8a08f60c92

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

