Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFD443D4E0;
	Mon, 12 Oct 2026 07:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791791650; cv=none; b=hmyj0ryRPACpwXjoQAR+2N8BE0vZYY/4gInKRlDFeHWuGz4mKUQRIY2YhyRwfrjXNkcA9UDZRcfqt5vn6dmP7ATYWE2OOvVViSP1jcEN/hxHrf1DmfLaVD6hi+sQ1KSxoKXO6ofCBqwvcNTIBpk2S69Ve/epYlPAUEtEWyu64sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791791650; c=relaxed/simple;
	bh=RICJS5L7fgEBbcsbp1VayoS7jyNdG1TbJZ4vYw9VxrI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rKvI3vO12wNxWmsKkHuTwRvcOK0LH9Gt8/ood8aCfB14DZtLML8EpD6vFtnkGpokdI/uE6crmoYUse59rp5hNe+sNpG5ZDpkYVj+k4CiXMXOVRSq+tH8dsLGpssjoYHP8gU1Pduh03afaTqSRWJs4gc5hGGtFd8YbkoTGFX+4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSsvIO+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSsvIO+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CED91F0089B;
	Mon, 12 Oct 2026 07:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791791648;
	bh=hrIa+tw0BeRbnuHqnWzatAa1fb31tMYGMsKk6RZzgTM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DSsvIO+C0MPHwru/KpL8xzEcSkSpKZRQt1GDs552pWH/V0TFSvkzBIDwYjyS/BlXR
	 fl8+R3K9hKgULF098RFEypWtQZWhmOhOcsxhpRKprq77W6+JL1FB7kAYRWu5ATpKtA
	 i/FoGii2ZMjAd0RLyjtomw5kjEC84EC367ZTl3Yk+NR6s7qgVRd0s6tN6KW9NaKSrb
	 u84YKxl9TLrxTSzsVVQR6zjt1h9e/HuVV80DR9sIUuOOiXQB674sKX2aBsVjTfkMlP
	 iEuHNkSQnHZHSnnK7DfajdgXvZPWSYpD1Hz6EDn4XLfemprox2U9Re9pwtTp03A6KK
	 sY7ZM6FwMSZ0g==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Haggai Eran <haggaie@mellanox.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>
References: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>
Subject: Re: [PATCH rdma] RDMA/mlx5: Cancel software CQ notifications
 before teardown
Message-Id: <179179164556.55850.15641554474545643936.b4-ty@kernel.org>
Date: Mon, 12 Oct 2026 03:54:05 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 08 Oct 2026 15:12:02 +0100, Prathamesh Deshpande wrote:
> GSI completions queue notify_work to invoke the CQ completion handler.
> CQ destruction drains hardware events and core polling, but does not
> cancel this software notifier. Queued or running work can therefore
> access a freed CQ, or restart polling after ib_free_cq() has drained it.
> 
> Cancel notify_work in the pre-destroy callback, before core polling is
> stopped and CQ memory is released. Skip user CQs, which do not initialize
> this work item.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Cancel software CQ notifications before teardown
      https://git.kernel.org/rdma/rdma/c/a0ab2bb269e7fd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

