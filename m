Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E783B3C06;
	Wed, 13 May 2026 18:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698283; cv=none; b=bMGRbQBcRQsE/MwAYpKjzayMovaP4FLB4O7/BmvipBVU3yMOBvvX5zMUsgGy5hs+RJrwl2ZEwV2tb0BzZjSnOIlXw1VOGFb1YWNwSkl9qEpQHa87pnWlF81NZXAY3IUdbexj/G+Koxhh5PkRl/ppHGklCZCLgVmXLWcBbzN3Kfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698283; c=relaxed/simple;
	bh=M2ksEA1v6b/Rb0MrVuOptDeQ8yX8VEHPHAPll/Wxzi4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rvN73hk2VrpkwZwA75wv1DN85e5TyVyCpmMXAhJJYGh/5F9Nic7Y8kstg4QCsjX6DAP3edd4vHuwqGmoPWJ9okOLeO/lAA/LQ5ROfc7TxSEY1t9xpePCmQnbEC8df6QLiroYu9bzn3FzDngI1I9fLC4KHw+xvC7PMK+Zdz5py0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRV93xL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRV93xL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3417C19425;
	Wed, 13 May 2026 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778698283;
	bh=M2ksEA1v6b/Rb0MrVuOptDeQ8yX8VEHPHAPll/Wxzi4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jRV93xL8WpT03e9aWfTLUCQi0kbD5sWjqZy9FvYueW3uI7qK9xMokPOFlfF5jQpER
	 75lGSiPJi27OW6XKrEeJTlqKw4vuoD9flhSvEg61gsH/Ftz6sNOwfPc9OMQUfRN6X5
	 N/RFOuI6GD79/Bo4n6o3rdZivQYwE7RU3id/DQitg0t43dOP69+Q5qFBCNqagVrXK3
	 DAH7NbYQa42FdD1KLVk0EW+J8f83FALhCJNvuDLmj7Nt0q2yGE9OfHh68R1ah9/z53
	 VEGh4K7/If7Ow8QFzIBINGabP+GcGnCjn9yLFzw5XHqgKfo54GU2auGOq6LJAuuAMd
	 Tcxe1PPscSI/g==
From: Leon Romanovsky <leon@kernel.org>
To: Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Markus Schneider-Pargmann <msp@baylibre.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260507075437.2669363-2-u.kleine-koenig@baylibre.com>
References: <20260507075437.2669363-2-u.kleine-koenig@baylibre.com>
Subject: Re: [PATCH] RDMS/hns: Use named initializer for pci_device_id
 array
Message-Id: <177869828038.2371282.17935591061454741759.b4-ty@kernel.org>
Date: Wed, 13 May 2026 14:51:20 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 07 May 2026 09:54:37 +0200, Uwe Kleine-König (The Capable Hub) wrote:
> While being more verbose using a named initializer yields easier to
> understand code and doesn't rely on the two hidden zeros in the
> PCI_VDEVICE macro.
> 
> While at it, also drop the explicit zero in the terminating entry.
> 
> This doesn't introduce any changes to the compiled result of the array,
> which was confirmed on x86 and arm64.
> 
> [...]

Applied, thanks!

[1/1] RDMS/hns: Use named initializer for pci_device_id array
      https://git.kernel.org/rdma/rdma/c/9dd3e17173bfb8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

