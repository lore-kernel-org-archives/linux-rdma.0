Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAEE3DFC72;
	Tue, 31 Mar 2026 08:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774946124; cv=none; b=gvxrX8Ur+6NCqdu7DoK56hp5TZnDJNIa1lnqdM4yo74LvsVy7kayPUojMcMnOCC5KLQwV5EnZ1n9OyPRpL4rlK/YL1+Pj1KXMgzkVyGg1Ys+DeQvUxU+9qARTOUOvTUbMNF3gHrwe2r2aQkMtvj9UenyEvSNM4zGureZh2RgJwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774946124; c=relaxed/simple;
	bh=4PxGJGHThb4XA2T2D+sB4KkxVzrAmQWcMhgkUx2dkh0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ESquyYwbip3kft3M4FZqBheNCbTrgmATVBYPYQkX/NvoD5WWk3JEaU6uPxXce+881vrnezItukU+KVjiVlYl7ufDOKgTZ0chORQevOWcehXqtfaMPu7KFtkWvznOs8kq/zY3ooNoY+HBn58s+xks8vaJPth1kZr4SZZEqc2uvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inH7+CYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inH7+CYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FE7C19423;
	Tue, 31 Mar 2026 08:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774946124;
	bh=4PxGJGHThb4XA2T2D+sB4KkxVzrAmQWcMhgkUx2dkh0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=inH7+CYTX7DG2DDaly+qKAdgfh+vFtWcQ8PaZTxXVKfvakF5RsC75qOmR82y1sipZ
	 JrvpHTtlGmieqvX1nhDvpCuz1oJfph3ygqao+fP6fS3UOhHbZB03tdky7GCSMiY4rb
	 N08P2ZFd103mkviNdo7Dq73bP8jRVbDc/RVMuamAxvm3LNYHzkDUqElldtod4h2+JV
	 OmzGbi6DYG4GOoTsk9KbTtxOE/8xKzrTj6OsB7RMPLWUOpNQdAK18dEIUhJ2cvJibH
	 2UdeqSbj0MvAX+OT+kg+6eLle8Girz/+AJafHsmK6hP9FlAP31vGiIjWcKa1t7O3t/
	 7RaZGcPaewTQA==
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>, 
 Allen Hubbe <allen.hubbe@amd.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bernard Metzler <bernard.metzler@linux.dev>, 
 Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Cheng Xu <chengyou@linux.alibaba.com>, 
 Gal Pressman <gal.pressman@linux.dev>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Kai Shen <kaishen@linux.alibaba.com>, 
 Konstantin Taranov <kotaranov@microsoft.com>, 
 Krzysztof Czurylo <krzysztof.czurylo@intel.com>, 
 linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
 Michal Kalderon <mkalderon@marvell.com>, 
 Michael Margolin <mrgolin@amazon.com>, Nelson Escobar <neescoba@cisco.com>, 
 Satish Kharat <satishkh@cisco.com>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Yossi Leybovich <sleybo@amazon.com>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, Yishai Hadas <yishaih@nvidia.com>, 
 Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Long Li <longli@microsoft.com>, patches@lists.linux.dev
In-Reply-To: <0-v2-f4ac6f418bd6+12c5-rdma_udata_req_jgg@nvidia.com>
References: <0-v2-f4ac6f418bd6+12c5-rdma_udata_req_jgg@nvidia.com>
Subject: Re: [PATCH v2 00/16] Update drivers to use
 ib_copy_validate_udata_in()
Message-Id: <177494612145.4056125.9188398247456851629.b4-ty@kernel.org>
Date: Tue, 31 Mar 2026 04:35:21 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 25 Mar 2026 18:26:46 -0300, Jason Gunthorpe wrote:
> Progress the uAPI work by shifting nearly all drivers to use
> ib_copy_validate_udata_in() and its variations.
> 
> These helpers are easier to use and enforce a tighter uAPI protocol
> for the udata.
> 
> v2:
>  - Drop EFA patch, rename the field instead
>  - Fix the mlx5 mw change, userspace doesn't use the udata struct at all
> v1: https://patch.msgid.link/r/0-v1-2b86f54cda42+7d-rdma_udata_req_jgg@nvidia.com
> 
> [...]

Applied, thanks!

[01/16] RDMA: Consolidate patterns with offsetofend() to ib_copy_validate_udata_in()
        (no commit info)
[02/16] RDMA: Consolidate patterns with offsetof() to ib_copy_validate_udata_in()
        (no commit info)
[03/16] RDMA: Consolidate patterns with sizeof() to ib_copy_validate_udata_in()
        (no commit info)
[04/16] RDMA: Use ib_copy_validate_udata_in() for implicit full structs
        (no commit info)
[05/16] RDMA/pvrdma: Use ib_copy_validate_udata_in() for srq
        (no commit info)
[06/16] RDMA/mlx5: Use ib_copy_validate_udata_in() for SRQ
        (no commit info)
[07/16] RDMA/mlx5: Use ib_copy_validate_udata_in() for MW
        (no commit info)
[08/16] RDMA/mlx4: Use ib_copy_validate_udata_in()
        (no commit info)
[09/16] RDMA/mlx4: Use ib_copy_validate_udata_in() for QP
        (no commit info)
[10/16] RDMA/hns: Use ib_copy_validate_udata_in()
        (no commit info)
[11/16] RDMA: Use ib_copy_validate_udata_in_cm() for zero comp_mask
        (no commit info)
[12/16] RDMA/mlx5: Pull comp_mask validation into ib_copy_validate_udata_in_cm()
        (no commit info)
[13/16] RDMA/hns: Add missing comp_mask check in create_qp
        (no commit info)
[14/16] RDMA/irdma: Add missing comp_mask check in alloc_ucontext
        (no commit info)
[15/16] RDMA: Remove redundant = {} for udata req structs
        (no commit info)
[16/16] RDMA/hns: Remove the duplicate calls to ib_copy_validate_udata_in()
        (no commit info)

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

