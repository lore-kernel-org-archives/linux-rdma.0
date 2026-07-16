Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400153C416B;
	Thu, 16 Jul 2026 08:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784192005; cv=none; b=FW4mj4lJs7ThKUwHJIFpn0YsS3ml4lMvtbwvX/MYFOYnHs9qCri8qs4NjXkpqUwHxcjHZpWcq/yIMCuEmHu2OwYrMMlmWxvq3QsYNnzsA6dP/isZQKWrqBh+F6ytJ0fw8Qzu0KDZrAPmjjEENh7I0bVmVb6Rs9JFr96oVybRVg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784192005; c=relaxed/simple;
	bh=EVm31dexMYwY2QGY198DYOMgBvXdo7szMrwS94wm7yI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WrF9R7fyHA+hnL1AcSHD8eMJStuUE7/77+iWHVgGYkQO6sS7o06/A5X7JxSaKXIRyT32axnrFAlCd0Rdwn7uUgz/d4LKEurXfBrCo8lPe3bTsPxDdCudU89LimHfmmW8ioXYhqKHHOWR2qSEVoeGbvxOYe1q1BtYToaumtNmUUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKMCiL+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKMCiL+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32D81F000E9;
	Thu, 16 Jul 2026 08:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784192003;
	bh=sUPFUbTmZGh1T88iCoaUHfo1J94vjllQRsd4DbZLhgw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=lKMCiL+Gf11IGJU1DkMnLijGxRS/p+2LRuK41PzKtDm2cf2tCaRtD6xy82Nw4ouw2
	 YVxbGvXFj6AgQcygzH97N8WnJ/RulBsaoqo3HCyqi96gJeSBjbqpshhoi8E1QeOaLs
	 LeQupkeIJiHIN4xDrQdwtuQ1Ml4wmLO4Tles5OTGgqhSqL0NZnQKA4R1UdczHfHkdZ
	 K4rha1p1eDsTGDt5nPFB4AAx62s/ngn/FtiVpORLwAhibtGVcZfpMCF57//g8ps357
	 yOYwIFKhNZVRjYqNpF/XyHGo8gxwQld7k8UH2WTx/HW8hU5ZrvF5KTC/7VxO4mpzuq
	 lQiiyTCDTiOfw==
From: Leon Romanovsky <leon@kernel.org>
To: bvanassche@acm.org, jgg@ziepe.ca, kensanya@163.com
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, TanZheng <tanzheng@kylinos.cn>
In-Reply-To: <20260715101550.45345-1-kensanya@163.com>
References: <20260715101550.45345-1-kensanya@163.com>
Subject: Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
Message-Id: <178419200060.304431.9176776050308942193.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:53:20 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 15 Jul 2026 18:15:50 +0800, kensanya@163.com wrote:
> When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
> descriptor, the unwind path destroys RDMA contexts but leaves stale
> n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
> sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
> can then subtract the wrong number of send queue credits.
> 
> Reset the counters and clear rw_ctxs after freeing the heap
> allocation before returning an error.
> 
> [...]

Applied, thanks!

[1/1] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
      https://git.kernel.org/rdma/rdma/c/91997e188f68af

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

