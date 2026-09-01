Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92063603FB
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 12:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265850; cv=none; b=h1SoBg1xDBv3pEnQfhp0XdMsF/cp47bIqeV2V16H7vL9QePCsso0j9L6AgEsQkWkMMmh7IK7DuPtTr0B5nV+8ruHiPTWonN7vzvBOE+0qFG6l1La0FG5wli6HH5DLBs37uH96iZpEwd54cMaT6/S8UxQo3KzWgH74G+tVZYPMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265850; c=relaxed/simple;
	bh=PKlSPwkl1f4GRz+KsBflgznyl9s4C4OSh/QplTE38gY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pDsfXZri61hGLeOq1LwgxyoGLqttH7PK5duK/30f/38Vje1qxVTrXnsk/5lS3asMacDOAhsYycmx1OmmhrRCBxsxEmEf255YjVZzxyFascdPELjrjtOvoF0nkkd4Hcpwe+dGNU47aX7OcG3GKvVvwmb4ZBeIDUzEIh83PfGvxys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJ1bjCWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJ1bjCWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95471F000E9;
	Tue,  1 Sep 2026 12:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788265849;
	bh=5eWRrkLDg2uHC2wgQFPeB5ouZPEe3ZemKA2c+LLnPQo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IJ1bjCWgrZko7hds6+MBKFGgyESolJ418K9NhO1Gv6dJjRqOEXyxy1T9ybMjhSsCT
	 ALFN4QD3boXMHjEHbLk4i34S3Tg5cA/FtkJwHybuk3gf6BRvglXoHlG5Up4wKaZde3
	 HCWwasQDyA9FQMLIL0ldLxzYHAfgCHDRiRPhZAjphbm0maXr5MqVPwNXXQCxayRr5j
	 QtTCB6tGTm1EhcrF4kIJv5ukTHNYGOabsMG/vYZ3WFl3Rw6qcHV8SH7e8g4WwMO4w0
	 jmClg1iXbwkLKcjxZoo4zEPzhflu2vNuujkdTAfKCmiiN70PLkVC8t+1hFXlFCtAnZ
	 yr3t07QHoXzOg==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Weiming Shi <bestswngs@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, Hongqiang Luo <wanbafv@gmail.com>, 
 Xinyu Ma <mmmxny@gmail.com>, Shaomin Chen <eeesssooo020@gmail.com>, 
 Rui Ding <threonine42@gmail.com>, Miao Zhao <muel@nova.gal>, 
 Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <20260726111533.1037819-1-bestswngs@gmail.com>
References: <20260726111533.1037819-1-bestswngs@gmail.com>
Subject: Re: [PATCH] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write
 paths
Message-Id: <178826584661.1269032.15690045668135890983.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 08:30:46 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 26 Jul 2026 19:15:30 +0800, Weiming Shi wrote:
> Commit 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
> pages") dropped the access permission test from rxe_check_pagefault()
> and left only HMM_PFN_VALID. A page faulted in read-only, for example
> a page-cache folio behind a PROT_READ file mapping, then satisfies the
> check and ODP write operations (RDMA WRITE, RDMA READ response, SEND
> payload, atomics) modify it through kmap without ever breaking CoW.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
      https://git.kernel.org/rdma/rdma/c/769001ce838d90

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

