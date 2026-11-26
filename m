Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701474;
	b=aUc7kG5LmpLRoePgCK/Z5GLyYzFux4srDEJchllS6flD5xL4zBuzGU0VhtG1/6UorGOt
	 zBPRqjBjfG2vj2S8y44a2O20EJ3VjcVagYdwzWR5HhBWjh4dXkbeLau/JtvVdVLu8gV6G
	 cv06iA8nZvGibCNZvfFrcfUpFgwQrtzVA6aiikzUYb8LNiKQwO4nkOzCdH3/KpiEjrV5J
	 N1sRqsONdnqtubKkrNi+8XWq9g5qsmB60O4lCoYtV1AFcxLTteV7NOi+Q2oBUO6i5uS7E
	 5oVm4XlgNvbAMHfe5flE4RJwJnPnGzILCY4SEtcM6dGKXEdF9kJwu+STfOGG2DlK3ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701474;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=oFxbX5GmOwQ/mB0J3seWtRVSnrdoHA20aPgMXi8ZrAE=;
	b=45rmVMgEFfsH6Q1SoFRykFbkN6sHCsqjmOQsg9t8foxDs0nicjuaC2OfMqXY0FGDDt6M
	 TIJj/88igcIpvX3jTMrEm1cGxOJpv1Rr5L5QPVqXgQmJMxq85OHAT6lsjatqnHPCA+Y/m
	 yyie0WKgKnGbPTbA5T4UBHqCjX09UJragLKA9bOJgL/YN0qdLrFYrOBXCKidKzEotYjXb
	 ylinDwcG+aNebVrliZl644Sg/+zTNX6SjOV185UPWT7h2yUWe3UgwiqsiL+wJt252yrWR
	 iOfDdb5xFqkleLI5jJbSLbKQdqjZQ+9On5SOwXT7JPPDCLDJXHeI8mtPHNZ35Ql8xNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GuxfGXUW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E40A606A31C;
	Thu, 26 Nov 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GuxfGXUW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3383B1F000C0;
	Thu, 26 Nov 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795701473;
	bh=oFxbX5GmOwQ/mB0J3seWtRVSnrdoHA20aPgMXi8ZrAE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GuxfGXUWk5lu85fiRFsQvZzX+DoKoKavyQ0zBzdm2wPMzQ/GNDleLygUfU4xos1Ll
	 g7fsP08KMJ9dvEOdKBVHWHjFFoLN75ebB6j29ZK33J3C+6eUD35KKt6K5jwPmN6C3l
	 BgHu1q4WlPpn0hbWR0G4D8S+FAH0bimTVDfuVU06RQ8x+6jsMnf2L6nSME0GuwHgYs
	 QPQzMBYRFgJ+RBBrlrTfFJzMK9WgJJJepVhSTye+xjTbfvNXEHrQoO44Q09kG5ek4g
	 X4EMHOQFbbMDoGoHjJLeSOFiq2AchWmUtz/Kzc/JhAmRUjQ3cs9L/68n/16quS5+aO
	 48v7wAIA7DehA==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Li Zhijian <lizhijian@fujitsu.com>, Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, stable@vger.kernel.org
In-Reply-To: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
References: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
Subject: Re: [PATCH for-rc] RDMA/rxe: Allocate the MR page array with
 kvzalloc()
Message-Id: <179570147092.1268685.12258502184760865370.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 08:57:50 -0500
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


On Mon, 23 Nov 2026 04:26:42 -0500, Qiliang Yuan wrote:
> A user MR keeps a struct rxe_mr_page, 16 bytes on 64-bit, for every
> PAGE_SIZE page it covers, in one array allocated with kzalloc() when the
> MR is registered. Before the array, the pages were kept in an xarray.
> 
> With 4 KiB pages, the array of an MR larger than 1 GiB exceeds
> KMALLOC_MAX_SIZE, so registering it fails with -ENOMEM, and the first
> attempt warns:
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Allocate the MR page array with kvzalloc()
      https://git.kernel.org/rdma/rdma/c/80ca1d1f85f410

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

