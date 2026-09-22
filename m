Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE3870830
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086586; cv=none; b=TX2A4+EwC2mBXS9cSvRD3eUgFPZv1E8XCqjhdUNGAisOxMzwBvSeGd9cAst36oyuK3UWuXMWviZj7hj2rpT9JroCIOqjQs+RcMWjy0GK1GBpS+wXaF/2hbhaZxRjnEq6O2NjVZUGFde6oPR7oGHtFSTAvciyFXWyRv4LrgrT1n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086586; c=relaxed/simple;
	bh=01JTGftDqVpBMyh0WHP3Qln1IocgUUOSmkTUL/AzvVU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AP5m9m0/FsT+XdGivUBa7PxeGaavBO2qbGFKHUP8sAaV+USZvqavhzKgsXD/2EsnnW+twjtDQmjU71eqzcqkDTktOCa+PRKlfgPPEyFOoiurMs2akZa/ODlpSGuBrhuHYJwdYuhK1qYH17RauEBsKHRlEx7Te1TJpjCwriBhPy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVVSZsB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVVSZsB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5F01F000FF;
	Tue, 22 Sep 2026 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086585;
	bh=Uqf8evjW7f4rqV/R8nrgQ2sgkaGWwtM4IRsvQ8SuARk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jVVSZsB+AqeBX+gbs2l6zQ0I0ARzcYrj+0ooy7Rdwgq4UNHdnnAb8nEaIoSb8sniH
	 sSG2mYwj0tFhF+J2JQwI5Y5TPvX0iqerYoe3NcovkWJy/Dehpy0QWtwue2Aup1+hp/
	 iZpLaB0tI+kzhyzo0M74OisYs+jBNs9mwCAJXoVbonyUREbrRBR9JPwg4ZopUL5n+W
	 nIs2bIIYCEfqmI+Xv8voTPV1LE7xinuPc69m9qJlzctu2HmILA0I+D++Om+4qZFTwH
	 fN1Ww15NL0tKnAZDBBvm/WEh4OYwUwmKCaTodk87tDBIkxTbxij8OLXl6daUoQtgxV
	 H7IaJaSN5NcLw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jeremy Bongio <jbongio@google.com>
Cc: linux-rdma@vger.kernel.org, jmoroni@google.com
In-Reply-To: <20260916173203.2555458-1-jbongio@google.com>
References: <20260916173203.2555458-1-jbongio@google.com>
Subject: Re: [PATCH] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
Message-Id: <179008658219.3247775.1377373576895888275.b4-ty@kernel.org>
Date: Tue, 22 Sep 2026 10:16:22 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 17:32:03 +0000, Jeremy Bongio wrote:
> During VM live migration or when registering large memory regions
> (e.g., guest memory >= 256 GB backed by 4 KiB pages), get_lvl2_pble()
> calculates total leaves exceeding ~131,072. The memory required for
> lvl2->leafmem.va exceeds 4 MiB (sizeof(*leaf) * total > 5.24 MiB).
> 
> Because kzalloc() requires physically contiguous pages, requests larger
> than MAX_PAGE_ORDER (4 MiB on x86_64) fail and trigger a warning:
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
      https://git.kernel.org/rdma/rdma/c/9c40f13a63a4b8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

