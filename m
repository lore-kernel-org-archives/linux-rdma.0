Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EF33E7BCB;
	Tue, 14 Jul 2026 06:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784012023; cv=none; b=uPnkOSWychO9DRfQBSQM9ctlwZL0OyPfeKgP+pR2dgtgtbo5Az4Botf1Je2OLUWdYgd76BoAJT3rGndXqvUgQqOdLDMb3GzF1X6gS9e2TLKicHVvsxAS9PlCaIWAGiuxJjRmTUxlwT67AnjuXNhfSvMZnbvwH0cr+AcFyBi2SGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784012023; c=relaxed/simple;
	bh=lf+PgPuHo1j+SeFCM5FcURMjNi+6xQBgnQRCCauM8uc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AUE14pHTHhzAvRSEfy9ka2QNdiOpLnooKRWaCsfOEX0uWL5e5rAp5s/OmUcS56ZCKKYks7WtO1sdoTal9RzJ8OqfWwFL1bcOwGwycSp9/7IzhUZqWzHt8z3uXIamRqv1Jknkc3ypwBmTk1N7JFPxp37gkQipfSB6QwgzJkm7sMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mafphPzT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mafphPzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C75B1F000E9;
	Tue, 14 Jul 2026 06:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784012022;
	bh=iFOa7eutRJIl+Ny7NNDXXjWWk5fN/ZsVaSr6Jex8aL8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mafphPzTIOh3EJ0cjPF5x0wTv43Up+X9QQvs1+o+NNb+dULdyxR5AI9vrxCRdFVNz
	 VwbTC/d8/OrPfsmfY3rpqNnZi4Y0orfQECUrEci94qJfl0nRRA18rejMXz99AJ71PU
	 RyJl+Y+XE8BFqslvzShs6TbpWkgjQyzc+RyA8cgs3tO967vmXfZxeRzBHEqXNjItD5
	 PsjafSL9G6e+PQSWlj5o8zcyEsVm7dssapNpMh5CcHgDm6qaolii++/WYBJWx3yZ14
	 QmeK8RP0QYMv+5dX6JFwxcVTJ/MCd7c28nqhY8u4b3YVYAjEIQczY4UJ/C2wRm4/RT
	 tRrCXBnlkZfJw==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Michael Margolin <mrgolin@amazon.com>, 
 Gal Pressman <gal.pressman@linux.dev>, Yossi Leybovich <sleybo@amazon.com>, 
 Cheng Xu <chengyou@linux.alibaba.com>, Kai Shen <kaishen@linux.alibaba.com>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Long Li <longli@microsoft.com>, 
 Konstantin Taranov <kotaranov@microsoft.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Michal Kalderon <mkalderon@marvell.com>, 
 Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
 Bernard Metzler <bernard.metzler@linux.dev>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org
In-Reply-To: <20260713-fix-destroy-no-udata-v1-0-fcca2e34fd57@nvidia.com>
References: <20260713-fix-destroy-no-udata-v1-0-fcca2e34fd57@nvidia.com>
Subject: Re: (subset) [PATCH rdma-next 0/2] RDMA: Small batch of cleanups
Message-Id: <178401201923.6794.11952273321586348029.b4-ty@kernel.org>
Date: Tue, 14 Jul 2026 02:53:39 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 13 Jul 2026 11:10:33 +0300, Leon Romanovsky wrote:
> This series contains two independent cleanups. One fixes the problematic placemen
>  of a newly introduced in-kernel API, which should be called at the beginning of
> destroy functions and not at the end. The other removes a redundant memset().
> 
> Thanks.
> 
> 
> [...]

Applied, thanks!

[2/2] RDMA: Remove redundant memset() from query_device callbacks
      https://git.kernel.org/rdma/rdma/c/eeb9697db6c16d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

