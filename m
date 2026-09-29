Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBC439B978
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 08:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670900; cv=none; b=LJM7zCzrxEz5/WxAVAKso5yssgUT2AFadCURQoFNVWAbcEF7hLHRu83jhA6OsLYTqkoSbYo+0Pa4cjbsXwB734tsbnb3WKHoSyDo6KUDupgE+3TacgyoRZfDGzqR0HCTMuQNcc4hqSNTlDvWNnxLKmLM16HKr8ZNj4FbPgxiQx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670900; c=relaxed/simple;
	bh=lvPrTC9lXsKgt/0NC1tNe6dEo0j5hYsU66/Pk+SfRLw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MMQuEc8aUa1Q3F9FdoK+ZLTr9MlmkYYJtQhnC/9l2wyY7vhB5sXQEENsXeOpK2VXN/bTMqQz1LOQ7Si1lZObH0VtXrptouQivtaEzum5iDNUMmsC1l+1dCpsNWx8cinFP23b3jGZ7hi06eGV6lci/rrc8NkxP5KpUHBgC1PzwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2F41F000FF;
	Tue, 29 Sep 2026 08:34:58 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: leon@kernel.org, jgg@ziepe.ca, 
 Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Subject: Re: (subset) [PATCH for-rc v3 0/8] RDMA/bnxt_re: Fix input
 validation and
Message-Id: <179067089623.3953143.16571748181447593391.b4-ty@nvidia.com>
Date: Tue, 29 Sep 2026 04:34:56 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 21 Sep 2026 23:12:22 -0700, Selvin Xavier wrote:
> This series fixes some of the bugs found while auditing bnxt_re's
> handling of user-supplied values and some generic bug fixes
> 
> Please review and apply the series.
> 
> Thanks,
> Selvin Xavier
> 
> [...]

Applied, thanks!

[1/8] RDMA/bnxt_re: Fix integer overflow in send payload size computation
      https://git.kernel.org/rdma/rdma/c/2cb09585a33dd5
[2/8] RDMA/bnxt_re: Detect wrong sge_len passed for inline
      https://git.kernel.org/rdma/rdma/c/30fb34c69bd3b6
[3/8] RDMA/bnxt_re: Validate SRQ max_sge at create time
      https://git.kernel.org/rdma/rdma/c/ebd9388a1180e3
[4/8] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
      https://git.kernel.org/rdma/rdma/c/41c2d60d7fee40
[6/8] RDMA/bnxt_re: Serialize dcb_wq access against async notifier
      https://git.kernel.org/rdma/rdma/c/9254983623f7ff
[7/8] RDMA/bnxt_re: Fix the PD and DPI table size
      https://git.kernel.org/rdma/rdma/c/a99861b65221f9
[8/8] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
      https://git.kernel.org/rdma/rdma/c/856bfaa78cce2c

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

