Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C70494818
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160333; cv=none; b=t1X8mRgBNfeZTIl6X/Q6QEfe+qzuAdLhe2jmypcV6DX+ZEe35wcFtqsntJfTnj+/Y8yvfDx5mVahhZyiE6v5DYKhSnm0ojVAqhBLz6QvBS3jVMNpJF1p5O/WNWghanxD6nS5r21Pp70U+RRQr8nx6DtUEj0yL6PMw63TSVMZVxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160333; c=relaxed/simple;
	bh=VhOSyYyHjJCrksFeAsYMZGmZ/lhYLx3LboCu/FdMkz0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jZc4YGFTCZs5dOXiPPWTEiWNKKTjBs+Xl53V3qlKCPSO3iCqtfmG/7k/tSRsCuUaAeVK92TZ52mdGy13IDQbb2ATLIhzxRuJ1EajR+RDVEn/v1Nb+l78jPwSIpBuA7U96vfy+SWkEzbCLU7jAeEMV661GUGppA6bdABd6IQRfX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qsx4gDTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qsx4gDTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0FA1F000FF;
	Wed, 23 Sep 2026 10:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160325;
	bh=1c6hH1UNeyeqAqF6p9o9mmWicklcDVvxzSeGmu8Kvsg=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=Qsx4gDTZBtuDJPLEsCfit+FCHshYR3rqiX9jnuIhXl6MQ6xAs6bnSlHM/pFuTWekM
	 gWUJ0UPsnzSHELv5zR7Np08a3ZhWa8S1kooID/iRAxXT2M06fiS8B2+HkGRMkLT0AO
	 24GwrMWAuJnAyJGBy5jF7HCnw32dek6pWkeSDyYT65GJALXzYj/Z0jeup/1lyxEBLx
	 /woxYS/n/wJhKYMSlbI62pLyiO1EHLIw1Qm/z9QN6Mwea8OgHSldSe7J+tcjCKRndp
	 pVlVkGk3COqr6ukJlUOqZxWbNgYE2pI+FcmsZ1UqiaC66sLuOB2ynCA51KjScEnuj3
	 pCz3LCpGoYvag==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Maor Gottlieb <maorg@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260917085419.1792-1-lirongqing@baidu.com>
References: <20260917085419.1792-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mlx5: Guard steering anchor resource destruction
 on create error
Message-Id: <179016032271.3400270.13842276572106342779.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 06:45:22 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 17 Sep 2026 16:54:19 +0800, lirongqing wrote:
> The steering anchor resources are shared between anchors with the same
> priority and are protected by rule_goto_table_ref.
> 
> When steering anchor creation succeeds but uverbs_copy_to() fails, the
> error path drops the reference acquired for the new anchor. However, it
> unconditionally calls mlx5_steering_anchor_destroy_res(), even when
> other anchors are still using the shared resources.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Guard steering anchor resource destruction on create error
      https://git.kernel.org/rdma/rdma/c/193aaf5b57f05d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

