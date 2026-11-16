Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830108;
	b=IEN87DFVxgAXoIXgeyiyA5pD9RvTzIryMLz05UX+P0sBgNg+809UeFBePfUtrvUG7oJR
	 GMCJr7EZuteXKGTA0ZrjpWCaDUcvX6RFGVzd2UTH2sPm3ZhDLcXWzwMv0vpFNDl1FnHIY
	 Lva9g7cAhh/683TsQyI0kkjjcdYngCjQcEMChpRLiKQUbhS0eJc3lsITy645inMgpkNjS
	 WxP8b0Ovyf4p+I2XRWSQfSJ9e7JlCQo01Kt6TyPZnPv2V8qCKanzRstEvTe0jEkllesE8
	 ka0+rKka2CCcr2u5t3iji5m5piMWF+esxULRzuO397rmzokTEqu2R4haN51PQ1FPy3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830108;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=O0vjiNS1GXG61hxKY5/0tSLT4xasjQjeJlpRD35HQwI=;
	b=w02AQnzERz3IgZdTg2xOak1UZ/AOJO6M+a5AiMFdXeR1SKGxmCNSff0hmSpno47MpeM2
	 LqfVo7p+PF3yNRyR5AMtLfwP//d9o3Bgzor02WJShKUsNjMWUShqzszvX2aSWgzBdv6RU
	 Oeif+QC1KkFHqFRjodGyq42iZ4iZBATBL8AlnshMWouvdjZ+ZiMM187yi+pzWd/j0+nkh
	 eJtxSHIsf3YQJqLCu2BImblNkz7ztnOuN52YjiSKHBtvl5Lf1RflFqKIFnxk0zwv2SAkj
	 tYvCK3sm9v9UwDlYRYEF/DsIWHaLsDapppQRvgQ9t6bJkobairx3uCOwxiWzoaZv0QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=enhT4I0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88109606A329;
	Mon, 16 Nov 2026 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=enhT4I0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E591F000C4;
	Mon, 16 Nov 2026 11:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830107;
	bh=O0vjiNS1GXG61hxKY5/0tSLT4xasjQjeJlpRD35HQwI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=enhT4I0kGX96T9CoqnYYrXP8AjU6Jt061bLq8TqNq1boYSswjCDsQRAqQXUbFoS1U
	 y1UTEUwXolKBDhFU4Vz2SEsUKGrHfKQ97arNvxy6OxrXOHq/9Mh0w9/vBqYxXr1NNn
	 FtKIb6Tkqygb36Ueyvf3dMfed9keEiHBhWjbb0ZaApZc3l3h/rSox5bdMFBHYoLupz
	 P/d9ilFiiilDi/yIUF7lGEiaBFCoX4O/mrQB0HJXAXGkWL6cWOKof5xTD5uZ4XGwxf
	 2qHSEii3LQWKuUzNzzDF42SgaM0TGZC/St2KUUeB8i3l2GKv4BTFV8EYFIzGZZUxJC
	 PA0Q8VUIB4VGg==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>
References: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>
Subject: Re: [PATCH] RDMA/ocrdma: Fix potential EQ table leak
Message-Id: <179483010461.1353587.17047440049211580824.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 06:55:04 -0500
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


On Thu, 12 Nov 2026 21:59:12 +0800, Guangshuo Li wrote:
> EQ teardown destroys the individual queues but leaves their dynamically
> allocated table behind. Free the table after all EQs have been destroyed
> and reset its pointer and count.
> 
> This issue was found by our static analysis tool under development.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/ocrdma: Fix potential EQ table leak
      https://git.kernel.org/rdma/rdma/c/9a2d5de81d15b0

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

