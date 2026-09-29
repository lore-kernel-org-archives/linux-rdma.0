Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD95616DB;
	Tue, 29 Sep 2026 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708396; cv=none; b=cM5rHS2k3S8XP516tZCnerlPiktJikD558K6PyBjq14OeF5vtkj+BfYQHtPjpt/x0CP2AKHJBJcXyqqaerljy9eA/HjS4UNl0WnO9q62gfUmFWj5QASsOrhtVKiwm2fdr5P9IU8VDXDYuzESn95T75doci3JSueo1C7FUSI5QvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708396; c=relaxed/simple;
	bh=f/8VqpOspSjzPh10xcgPfSXSUj7rgTkzpvsDjYs070M=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=b7u1eLyKs2G0sjYWVIEaPHBytgN2v1sI7PyOjKxroqp3GXbnSdnOuzo/5HYduM35/5tVLuoLW1XqjtKkmlztTeXx2O6ab1PjHRa2Kro5YGN3R6GcIjaTZg0KOF4tEZNIGJNUL3wgDJlPOfsvr87KBKOPSfD03mXdm1Z5Nzp+sD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPafNVQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPafNVQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E32B1F000FF;
	Tue, 29 Sep 2026 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790708390;
	bh=SJ6Dmp79QtdjBGv8JysX7PZBUV6aLcf0s8zUw+ScRRY=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=KPafNVQ4rjP/7lrqMvUZtZhIvc/R3SEP+5460W6pZeXG05CKaIeeF6S06A45WKxDX
	 2dDwo3FBe24QEWEqEbMuln7GFK5LczJKDKhIrezFxqLtZv/Z327nBDOircf86Z9VT1
	 bpOhqGZpZz+uPDLCKTA7nbamtRNK9YJkLM8tKSpLeyELcll4elDKAixT6yo0mZq2lP
	 1m5cUiSgxU1m0oKFtzKwnfAJXY3TTGKk0ViFYSm1+UHXpayTpvm5e3Wss/Ps8eodG6
	 huC3Wn/kPWinpCBSoxu+32U4syVsIX6UYnCDurxJPPo/HEZnNGB6pH0yxJnL4GT2Rm
	 g7Vk2hpNh7AsQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>, 
 Michael Bommarito <michael.bommarito@gmail.com>, 
 Li RongQing <lirongqing@baidu.com>, Ira Weiny <iweiny@kernel.org>, 
 Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Jiale Yao <yaojiale02@163.com>
In-Reply-To: <20260926105927.3183294-1-yaojiale02@163.com>
References: <20260926105927.3183294-1-yaojiale02@163.com>
Subject: Re: [PATCH] RDMA/mad: Reject receive completions shorter than GRH
Message-Id: <179070838783.3976902.14064540367880322147.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:59:47 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 26 Sep 2026 18:59:25 +0800, Jiale Yao wrote:
> ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
> size from wc->byte_len without ensuring the receive completion covers
> the GRH. If it is shorter, the subtraction wraps before the result is
> stored in mad_len and an invalid length can be passed downstream.
> 
> Reject receive completions shorter than the GRH before inspecting the
> MAD header or deriving the MAD length.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mad: Reject receive completions shorter than GRH
      https://git.kernel.org/rdma/rdma/c/2dc2126e690203

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

