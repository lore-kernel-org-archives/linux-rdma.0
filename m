Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302A8276038;
	Wed, 22 Jul 2026 09:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784713235; cv=none; b=hyxdbAI3aDGD8OTRm5R9y3SofgVcWc1XLLK+GrK/OCv3HVhTsTYto05H3WG2GufKRnLOD/ZJE9whA1FyA91r+vt9iK4GMNCiLW5ZhY6exoKvH9nFBee1LKSn20+1MbmycIpEuXjcMHMx6JAoyXRbSce3FjuEMNY9hLuZcAnCYrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784713235; c=relaxed/simple;
	bh=k2jr80htufF+3CJtIUcmyRHnr+fNBfJkzBgdPcckogY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AXYrOQpQFAFE6SGs8Uq5gvt9Y17hME9jIAdgvFq3X8TnJGSEqrxtO669j7oocMeyTDTQ2y9N9enUCCuDRR+gu1NsJJGk5zcDNwwjhYnbnFpl/ns/UdIy8RFft21u9GZjnmFCBU9CDYHAbuC5PIh9SVjaQ3XYs7/qVGkNEMJvXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFu1yDNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFu1yDNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A951F00A3D;
	Wed, 22 Jul 2026 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784713232;
	bh=s7tchNSi4xLEv9CKx2n/7oPdA5UECMu5NmyRgaDEh6M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=CFu1yDNr0q82OEWrfy99l86Pxw3nxWq1S4xXyNt/81Nkpx8pYac7qMuDU1XFBenls
	 p3g1jhNu34WKdTLVxjW4Rz94H95Kc7sy7mm/w6ha7Odlel+c7vTUzeuw0T5isWzYYk
	 FW+EvUMf/+hr1qQNPdDTz9nZMNa+TnTtVt8VpwmUX/KwfXYTQ3HEPJ/HNc03fxGczv
	 KBVFsQ0vIWzV98Zjtj+ZK6oAjxSHhkq4Ptt1sESwJ/+MLLkiWRxu4XyZvU9vjUmsZj
	 UOl+8H2vJR/e5A5ut3C8is7smKFZn7FgQJ9qaH3Nc0dWi+o7U973hyNhu9f78eUuwD
	 c6+wJ2jKWF+ow==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Gal Pressman <galpress@amazon.com>, Steve Wise <larrystevenwise@gmail.com>, 
 Mark Bloch <markb@mellanox.com>, Neta Ostrovsky <netao@nvidia.com>, 
 Mark Zhang <markzhang@nvidia.com>, Mark Zhang <markz@mellanox.com>, 
 Majd Dibbiny <majd@mellanox.com>, Yishai Hadas <yishaih@nvidia.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Patrisious Haddad <phaddad@nvidia.com>, 
 Michael Guralnik <michaelgur@nvidia.com>
In-Reply-To: <20260713-restrack-uaf-fix-resub-v2-0-bbe8bb270d51@nvidia.com>
References: <20260713-restrack-uaf-fix-resub-v2-0-bbe8bb270d51@nvidia.com>
Subject: Re: [PATCH rdma-next v2 0/8] RDMA/core: Fix restrack UAF in
 destroy flows
Message-Id: <178471322971.2834918.5524383712332668395.b4-ty@kernel.org>
Date: Wed, 22 Jul 2026 05:40:29 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 13 Jul 2026 18:37:59 +0300, Edward Srouji wrote:
> The resource-tracking (restrack) database is the back-end for the netlink
> "rdma resource show" interface which pins objects with
> rdma_restrack_get().
> 
> QP/CQ/SRQ/PD/DMAH/counter destroy paths currently call
> rdma_restrack_del() at the very end of ib_destroy_*_user() (or its
> equivalent), i.e. after device->ops.destroy_*() has already freed the
> vendor object. A concurrent netlink dump can therefore look the entry
> up, take a reference via rdma_restrack_get(), and then dereference
> already freed memory - most visibly through ib_query_qp() during
> fill_res_qp_entry_query(), which produced the crash logged in patch 2.
> 
> [...]

Applied, thanks!

[1/8] RDMA/core: Add rdma_restrack_begin/abort/commit_del() operations
      https://git.kernel.org/rdma/rdma/c/bbb475bfdaaa42
[2/8] RDMA/core: Fix use after free in ib_query_qp()
      https://git.kernel.org/rdma/rdma/c/b027f665a1a1f0
[3/8] RDMA/core: Fix potential use after free in ib_destroy_cq_user()
      https://git.kernel.org/rdma/rdma/c/06d2f10ba8f7f4
[4/8] RDMA/core: Fix potential use after free in ib_destroy_srq_user()
      https://git.kernel.org/rdma/rdma/c/fb392e7746a25f
[5/8] RDMA/core: Fix potential use after free in counter_release()
      https://git.kernel.org/rdma/rdma/c/fb538c8aa2795d
[6/8] RDMA/core: Fix potential use after free in ib_free_cq()
      https://git.kernel.org/rdma/rdma/c/06178024942778
[7/8] RDMA/core: Fix potential use after free in uverbs_free_dmah()
      https://git.kernel.org/rdma/rdma/c/f42597bc8ed68c
[8/8] RDMA/core: Fix potential use after free in ib_dealloc_pd_user()
      https://git.kernel.org/rdma/rdma/c/a8bfb98690fe18

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

