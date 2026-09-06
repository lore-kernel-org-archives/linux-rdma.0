Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1884238DC56;
	Sun,  6 Sep 2026 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701630; cv=none; b=MOhKaZtO3XzpMIjBs1T0yPLn15s0z1hBQOgYoObr2QNow14kTRrBjPPPQ8PGa4iybEtykLZruMb8fA4cqWVsMq8lH+LpPi6UlTfIeJCNpXsY7oHlEC5O1Bij19TJuDnYFgmitwBlp2WMKzbOim9F7tZnRtmC8dd9CX4YDhOG5Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701630; c=relaxed/simple;
	bh=9dkuxWHmaQGXyY2oA/l27qAgx+kGjgdBMFEpE08q56A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGyOJuHVnODdbjjqI7zd5GzG+oEHTdv4EzzE6mYCa6VBvgsKsRVZRjdVJSqy1nxD7eDDC1ks25y9FyW2iUgFuUe3YusXgaNTI1wxOUA9yyzy5+pqDPqYi62bo79L3STKcrfVzGQuUdThofHwFmajBEhjHynTL0PCliNVvXfua7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kauv+GM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kauv+GM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682B51F00ADB;
	Sun,  6 Sep 2026 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788701627;
	bh=zkv1lyQQzGyFr4bISqDAsBQBAxerSdBos3QZkHjK3wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kauv+GM0Ime7iOSa4yn3G+E68OuZ3JnRi5/fV1iImgfZumtvq8BW4L7xg39saoW5L
	 r2ECB18NRWDuONI0ljIacetMU94Nsud7NqrRlue3Li2j4gaZseqwZqyLzlIJREW3QK
	 Mrm31DafbVGo+Jdy5zd0SySBursFGZbO5jZEx5ntdLi5P+Natn3YnsoH4pkihVeTIt
	 PttBXVEn3y7FUlyk5q7aBl9xJKFJAxtSDx43QRPxAQ78k3fQT06ekSeyEzPugOvFHm
	 tq0sRsyk+JjeKdsPldMsanA/30aOMyJZCucg55+sDiceZbGT3qc/K5e8+I1cReMO1V
	 VObVFxG1xi4UA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	linux-rdma@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	doebel@amazon.de
Subject: Re: [PATCH 5.10.y 0/4] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Sun,  6 Sep 2026 09:32:53 -0400
Message-ID: <2026-09-05-daily-reply-0023-rdma-rxe-srq-toctou-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903200851.566276-1-doebel@amazon.de>
References: <20260903200851.566276-1-doebel@amazon.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream commit 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in
> get_srq_wqe") fixes a heap buffer overflow in the rxe responder.
>
> The fix does not apply to 5.10.y as-is because get_srq_wqe() there
> predates three earlier cleanups. This series therefore backports those
> prerequisites from 5.14 first, and then the actual fix:

Queued the series for 5.10, thanks.

-- 
Thanks,
Sasha
