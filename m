Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907024;
	b=CJanC/dCV0HHzEGLPF2Y/r5iksRLEGT+UsXcqysVWsDGqC51GH0u5iRNh0VRwuK/KkhU
	 ibF7gq96VXW980v8+YjwdcoAaJe5orBL9seEi1uHygs3MAreYNaSrsfwP7EjRz0mVJtMR
	 iH/ETpT0Nr/wSazTtMcqO7+/XxIEDRh6AVlS3Gvcbj0Jr5R+liuVH6X5ZZNFQ3BDSpZ+s
	 62OwlwqixviYgTY4LV9SEG9tI3jm9WZ3SdKN2utd3/5YZhpUE06SJqhOErfY7BjT3q5fN
	 vLZZNVVZ7ZRdDGHSCwDAm4fJMOIgkD6Uic477MC/CjpXOS6ao8WAYJ+h5f54fT6sJRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907024;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=pMEMtxyuK3+HRaY44/pvazcCGljjnGE2tNKvXpoZ/u4=;
	b=RLk190eVNrGcBVxzuOlFdM8551/Xie4LPWTAKYmOhheiOMi2DbqZfo3ZY2wFIwtDUj+R
	 14jlX6alAjcRGqPQOmgPsgbA9afn14K7nnpfi9OrxHWrUGsvoyzI7m8+JapBTAFAkVd4c
	 1cbieWf0XgJ1cnnrOYJUJYPCsrx1JortMY1mp7Gyk6MYS2UCTkaqybJFMcg8lfgiAHXOv
	 ltR+XIfSbDpJMD7k2x4KzEtt0XMnGGL90wwLppqCxneEunMQ9bDb71P4bzCQfjrY/X1I5
	 cPB1/8WLnPm3BBMi3YC4/xeHmiWX+hllZau/etGwb3/bimfV27PbYjOzivfVGo9bJ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Adkt0KqD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE39606B07A;
	Thu,  5 Nov 2026 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Adkt0KqD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2061E1F00A1D;
	Thu,  5 Nov 2026 19:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907023;
	bh=pMEMtxyuK3+HRaY44/pvazcCGljjnGE2tNKvXpoZ/u4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Adkt0KqDWgMzrDm8+MPoQhdBeLqzCa/8ErQx/Oxjx65v/35NY5l0/5ulmnxqV72Fd
	 Xa/B3zhIfRrsvSfKsLWCTSEfScD1XuM6kVVVsrT6XFvRqCKWtxZo2+IWY4NoGYud6D
	 HJSykQQUFRruviEsG8ktW8tekyIm58QnGGsPx7wyRziLak3Tf5va/xArvKAl3ph20G
	 TcV3Hv/piOHGWdWsm2RWo8/DXQbSXDt/MfuiNaq1SAp1I7crOiW0JVnlCJC14Q5lyp
	 euXvV+XAKGGVD96GEgfMTn7CuIoojQ8meM1yyijDmSHlu0WUsUSFtLKgzZHt/iqe8J
	 E21ysAXKmTdew==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, 0z5a <dezhen.lu@student.uni-tuebingen.de>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
References: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation
 for pages >= 4G
Message-Id: <179390702044.98181.15076173312140750474.b4-ty@kernel.org>
Date: Thu, 05 Nov 2026 14:30:20 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 03 Nov 2026 15:28:04 +0100, 0z5a wrote:
> devx_umem_find_best_pgsize() computes the page size in an unsigned long
> but returns it as unsigned int, and devx_umem_reg_cmd_alloc() stores it
> in an unsigned int. When the DMA mapping of the umem is contiguous and
> aligned to 4 GiB or more, and the umem length is a multiple of that
> size, ib_umem_find_best_pgoff() selects a page size >= 2^32. Since the
> value is a power of two, the truncation turns it into 0 and the
> registration fails with -EINVAL.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Fix DevX umem page size truncation for pages >= 4G
      https://git.kernel.org/rdma/rdma/c/b5c11bf9759834

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

