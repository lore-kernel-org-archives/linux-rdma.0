Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286BB386425;
	Mon, 27 Jul 2026 06:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133351; cv=none; b=XtLxKTZ8Xzm335jszrjQcF1kUIZc8l+P8Sb3LrNCs5ec9C2XgCu/0NMAmUTXQWNEghJ4TwHlGiYa4nCpsr/nNArJFTlMspBjDvwPkp1fan0WpG1EAcs6qSxag/NBGugPGwZd3KW2+fqClkyEIV1oo6cS8NrKt4funiEoBa7i3oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133351; c=relaxed/simple;
	bh=sCKr+Yr/qKP1sQD2uzvHexNqOYgIoG+7W26EoWklmHo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mQlKe591buZ01Mv7zU4eK9wOHp6pKJ7LAHWdUoU4L/lkL0189BN0kIFCpb/tlKw9FUyUtOSVW0+vDVIrSRrwe2O4mfGHl7Yxx31h3SJnzEM5nygL5QOeGyvdLyuygfihnY29pAszTCEphIp0kfawzfH0kGE0Lz2IhQ1h3PmI500=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3BC1F000E9;
	Mon, 27 Jul 2026 06:22:28 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>
References: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Make sure that UMR page is
 aligned to PAGE_SIZE
Message-Id: <178513334663.574619.16589078535934611662.b4-ty@nvidia.com>
Date: Mon, 27 Jul 2026 02:22:26 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 22 Jul 2026 14:41:13 +0300, Leon Romanovsky wrote:
> The UMR XLT buffer needs to be aligned to PAGE_SIZE.

Applied, thanks!

[1/1] RDMA/mlx5: Make sure that UMR page is aligned to PAGE_SIZE
      https://git.kernel.org/rdma/rdma/c/c715007b21a4f6

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

