Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF5489867;
	Thu, 10 Sep 2026 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047325; cv=none; b=StEb36etwn/cG6zff3fI9VBwV0Edpz0kio6O8aGxKJiqxNB2veNT4cYJyXjnubpFTGVP3hoUW0UdSBfz+RHNEwMd6nMdtXMD4IOnOvkx31hhqufd7gYhKyRjSc98MVf5uh9f7QXxXku5bW3Zdy2NKmhRXvoOM9HaoQOsTLW/neE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047325; c=relaxed/simple;
	bh=gWhAzw5qaffeLzAPX75WxVmZfAxmX7TTNhGWpGJaPqc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BkADKPa0Q8u9oHpeoGGaoWi5/saZLO/MZk6Xfoqb4TD5izxzqIyTuYbcgRvjavb9F7FoJ6MJ/fnimqgGzpQV4DB8JgmmJ7boWwl+g9CVG/AieAe0Tfoaz3uvO81wqSXKodpuPgl2K3Esp5GYHmOXgDkm4rjKibw86MvszOcIYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59A81F000FF;
	Thu, 10 Sep 2026 13:35:23 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Michael Margolin <mrgolin@amazon.com>, 
 Gal Pressman <gal.pressman@linux.dev>, Yossi Leybovich <sleybo@amazon.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem <shiraz.saleem@intel.com>, 
 Steve Wise <larrystevenwise@gmail.com>, Firas JahJah <firasj@amazon.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
References: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] RDMA/efa: Synchronize IRQ before freeing
 admin queue and EQ
Message-Id: <178904732156.334243.8319094980001099761.b4-ty@nvidia.com>
Date: Thu, 10 Sep 2026 09:35:21 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 07 Sep 2026 21:44:45 +0300, Leon Romanovsky wrote:
> Two similar patches for pre-existing issues.

Applied, thanks!

[1/2] RDMA/efa: Keep admin queues alive while IRQ is registered
      https://git.kernel.org/rdma/rdma/c/e08aca85c02ff2
[2/2] RDMA/efa: Keep EQ resources alive while IRQ is registered
      https://git.kernel.org/rdma/rdma/c/e22a3627b71517

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

