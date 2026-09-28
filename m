Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D241F427C
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597945; cv=none; b=A6vkJnNX48FpUt+O3eOI+a3eFVPrd5DwdGXtGXFWA546PCOaIVypVnNKj18sl9wMqmlML/ET5rA+DGIgoemQrS0Z4jxDMBr8eMjg4IrZXBHlw/gVXjieDHqnegn7wAH2GhLluDfOYpBU8TaOz3RtD78hNFShprg9bb5VPPvoRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597945; c=relaxed/simple;
	bh=xJWu8EKg69+u3h+yUQ+HiIdumjNKk8jFH/0gF/yZ1Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgR8J39+GHXYmzfXtlRQpzlXm+BkuXXzL3mfL1PKIQ31ZVr2/R6T9PoUSns4YuNFHAmgwoOxcAChliWhqH/0QHrg/wuejGd/QQXrPfQ9qsU9z4a+UxTABMrNmOWussg2ui3YXnfgf7i7KmTy309s1LARYJ4wwQ0i3s3o3wWklSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WudS1dLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WudS1dLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935311F000FF;
	Mon, 28 Sep 2026 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597944;
	bh=GTauEuCqZAetA4QfoNiz91lXPMlW5J1Ikaa5DpqrrYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WudS1dLJQiIDddzUa5MANt6/vCacY5qQiMu51jfBPHS7C7W3kX7AFSqudJ9Fc2aTE
	 aacfxo1No6ZvzQNtjrY8UfKF4WQtAaSs7Po8MBp+xleWFM/Kp6R0yR0jDgTJbOw7zM
	 S+yIxIBRPRVNLg99qAU5uW9JI118cP4yZHskM+3KP1pLBhq4entHhAs/3gocIlEpvB
	 B0V9F8jFa/g43pyqOmTQn1K2aBNppZo01reTc4eLck9DSqDBULFGYM7ivqf7V9RVb8
	 4N8zap0QcQ2OsjhXcRj4mIhAeqh+A3fi0EwfFZvyWhLPsvm4m85PzLctJ1Pe0Y8iV/
	 4TC0s1n8kSTEA==
Date: Mon, 28 Sep 2026 15:19:00 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com, chengyou@linux.alibaba.com,
	kaishen@linux.alibaba.com, tangchengchang@huawei.com,
	huangjunxian6@hisilicon.com, abhijit.gangurde@amd.com,
	allen.hubbe@amd.com, longli@microsoft.com, kotaranov@microsoft.com,
	mkalderon@marvell.com, bryan-bt.tan@broadcom.com,
	vishnu.dasa@broadcom.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 00/15] DMA direction and mlx5 driver
 correctness fixes
Message-ID: <20260928121900.GW563127@unreal>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>

On Tue, Sep 15, 2026 at 05:09:18PM +0300, Yishai Hadas wrote:
> This series contains two independent groups of fixes for the RDMA
> subsystem.

<...>

>  drivers/infiniband/core/umem.c                | 77 +++++++++++++------
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 ++-
>  drivers/infiniband/hw/erdma/erdma_verbs.c     | 19 +++--

erdma had a few merge conflicts. I resolved them, but please review my changes.

Thanks
