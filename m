Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABC1373BE4
	for <linux-rdma@vger.kernel.org>; Sun, 12 Jul 2026 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783845821; cv=none; b=O3cv4N/tM2obWKNY+CzNeliigS1JkFTY8bDIiUdpj8nhVnJpGLp6194PQMd9rw58ZrBugbz8DVP4P8FUQjuZHhDjPTaql3XOQst28FVwq3YN3drGqeimkCl74yp7GxtzEzPoWsJ9oO1QfaJGIhzAQuKLHIA/JQYrp8VwgHYpdSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783845821; c=relaxed/simple;
	bh=iO01s8rO+5FubkEPTSkvjgvY/ZRbmfnyxYp6sZtiOqo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uw7oESq/yusjjkDVbJiJ5kkQ5Mx3u9SkX7xqB1CNDsjWNs4SN8askfgr4Tp9QwUSAO271QQRZaszfftI0pWShMD9MN5iXoxthv2iYeM61QOzc6dMNB/ZkgGGq4UtVZeWs9DhUPd07r46Xy7UK3mM93ABp8URZ0av5A3Gspo9Ebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJ8PIrmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJ8PIrmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5951F000E9;
	Sun, 12 Jul 2026 08:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783845820;
	bh=eDYu56Sw+bCJkulxc0kFyvOhguLoJG8P3ofoG+eZY5k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DJ8PIrmRTNvhWtJ50yM9czeKh3R4ybb9ovIeF9s1khfMdj3KV6Sy2udb+KWZBtvRK
	 v7yPFhToGUfjCzaxjVjACN5WB+Ly3DH4dvqQgN+SfiWTTCts2ycBx+NKziXQO0sGzD
	 ynsxfIOeqqf5vGhK52uD1tW70CcGLda55bMWhBoWPNFiFKrkxF3fkbL05pBReEPL9G
	 lz/aVVib5sNoekqd77M0uxkG6nPkZeQm1KO0h2V6EHUQ/dYUBMxmpaaLn7Y0zw6ZRu
	 1tayi5CITfXzCpIi1K5C26sUCqYkiie/1c/p/ELe5EMU56jzOsR9cf4TM4w6FZ3Eln
	 q4op+xH33PSGw==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yonatan Nachum <ynachum@amazon.com>
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com, 
 gal.pressman@linux.dev
In-Reply-To: <20260706170008.1039417-1-ynachum@amazon.com>
References: <20260706170008.1039417-1-ynachum@amazon.com>
Subject: Re: [PATCH for-next v6 0/2] RDMA/efa: Add AH cache for AH reuse
Message-Id: <178384581763.1549395.570090183709137588.b4-ty@kernel.org>
Date: Sun, 12 Jul 2026 04:43:37 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 06 Jul 2026 17:00:06 +0000, Yonatan Nachum wrote:
> Changelog:
> v6:
>  * Remove rcu_barrier and kfree_rcu since all hashtable operations are
>    serialized by the AH cache mutex, no concurrent readers to protect from.
> v5: https://lore.kernel.org/all/20260628133422.523230-1-ynachum@amazon.com/
>  * Replace the single refcount and initialized flag with two counters:
>    one for entry lifetime in the hashtable and one for tracking active
>    AH users.
> v4: https://lore.kernel.org/all/20260608071620.1909543-1-ynachum@amazon.com/
>  * Use kzalloc_obj for AH cache entry allocation instead of kzalloc
> v3: https://lore.kernel.org/all/20260607161753.1607559-1-ynachum@amazon.com/
>  * Address Sashiko comments in:
>    https://sashiko.dev/#/patchset/20260512061121.2177521-1-ynachum%40amazon.com
> v2: https://lore.kernel.org/all/20260512061121.2177521-1-ynachum@amazon.com/
>  * Zero-initialize AH cache key on cache lookup.
> v1: https://lore.kernel.org/all/20260510083035.458081-1-ynachum@amazon.com/
> 
> [...]

Applied, thanks!

[1/2] RDMA/efa: Add initialization of AH cache rhashtable
      https://git.kernel.org/rdma/rdma/c/97ba15272e8e03
[2/2] RDMA/efa: Add AH cache handling on create and destroy AH
      https://git.kernel.org/rdma/rdma/c/234895fa8be06e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

