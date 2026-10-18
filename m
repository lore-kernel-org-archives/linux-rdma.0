Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B22D21CFE0;
	Sun, 18 Oct 2026 12:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792326519; cv=none; b=JeZnXNnEjxYPoHIr7PFCpZcgP7L47dOW3hP69kHxWgRFIk/PsxHm3bEIv8Qd/6/yfPppbpHzVqfQi/h0fglijL46j/+4YZ//ao4YUJmhF4bSxkLG2ckBk+2BNM2ObdDJeB0S7vIpZd6z7Fl2SiOCVS02uyV+LRJkFuX888bhiEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792326519; c=relaxed/simple;
	bh=8V+3JaDxwIueUC9+PzYQ22UhuKSNzB081+XdpSVwxU0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TXIbXZy5p69j6UFCmEvNJjLF3kJ4x31LTrctQJPielFVP6wFu+JdNW3QvMXPhVtq5EMeKkV2CpK/Y3ea1eLpy7ycgcoSZWVlxhop+2Jo5nOqC/MHt/J9iHm9iK346SNzfaZsA2k6XFcUWCv6iSv//G/+tP7MJxtY9St7muccIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlDPNHwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlDPNHwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C64D1F000C5;
	Sun, 18 Oct 2026 12:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792326518;
	bh=cEzVAhemV27pVH2vmmmpsqNzypg356FuX5ZtNbkNPYA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OlDPNHwczCc0OG9Vs828+pqTqwePbTDVOOOMYzKC5tRBTBe51ttAD1dxx/c7qOD+C
	 AfbFwkviivOBF+PqMY/EJ/+rGx8eeoPmGZxoa0BNgXGiv5KL3IjTRRRo1V1FN5FiHQ
	 W8hx/VYUcw2BGKGs7bXy9M9XbTRxmlk2PyoaH7Q7W7RLF/RLVQCa0i1Frz4yFIt3VW
	 +ghb5MhFxAu7IdiEmJ59hDUUhEtHE1Y5RhlmASx9Q69lOr3PK4E43E62ZoiY0XkRD4
	 R7DIZs1Q0WBVy7hNA6qIMU6/vRgoT7FRTnbouaZG4Y2WdI+3SGuqrNW2Xf+ZY+61a+
	 xAsCVw4nHB4Sg==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Zhiwei Zhang <202275009@qq.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <tencent_FBB0EE9F592FD21FD4B0F3BFAD3336765209@qq.com>
References: <tencent_FBB0EE9F592FD21FD4B0F3BFAD3336765209@qq.com>
Subject: Re: [PATCH v2] RDMA/rxe: Clear pkt->qp before the early drop exits
 in rxe_rcv()
Message-Id: <179232651585.22051.2025466489740178827.b4-ty@kernel.org>
Date: Sun, 18 Oct 2026 08:28:35 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 17 Oct 2026 09:40:21 +0800, Zhiwei Zhang wrote:
> rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
> uninitialized on the two paths that take an early goto:
> 
> 	if (unlikely(skb->len < RXE_BTH_BYTES))
> 		goto drop;
> 
> 	if (rxe_chk_dgid(rxe, skb) < 0)
> 		goto drop;
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()
      https://git.kernel.org/rdma/rdma/c/7d7214b39b14c9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

