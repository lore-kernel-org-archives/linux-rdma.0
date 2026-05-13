Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D85282F34
	for <linux-rdma@vger.kernel.org>; Wed, 13 May 2026 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680314; cv=none; b=GS8AAV6wSr1+08bOP81R7v0bDznVpMiOqS8nwql9BmGc7dLwDkgDe7ezXpz2odOYfLxIaofwJ6VrquDMvc804rwlrE4YTc/unSA+jEpGUyAJbxw5vUo9UxRClhAEpf9l6Nxk0vJ3uQyo/Q9jDSEWidzROREDzOo2zvLme0JS7I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680314; c=relaxed/simple;
	bh=qcKfecleHTduUs0ntp/uc1xBPVuXFPWClPwpCFdXRbo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f1v2RNFF8XBlbeR3C6/w+QIHNCFE3dX71L9KhXzlXQGQPwgfiDB+jzm9w8+s9TH4ZuIusWp7DcF9n8DvFmPidy02zXC9kqjEewwo8pk3hO5JOMmDJpxirFkMqsGnUXpTof5j2jBtEJHc0hD6ROKIWiPUAauIUOtV584qrMk8qvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNVhnO78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNVhnO78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03BDC2BCB3;
	Wed, 13 May 2026 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778680314;
	bh=qcKfecleHTduUs0ntp/uc1xBPVuXFPWClPwpCFdXRbo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=CNVhnO78cPxzV70YI2YoY/NIQxSQNwRFw7fSdQcDgm9U4F7UhkpMArhtcQhwLmUUB
	 VCwJkhT4/yyYJjTgSWtaC1f3naE/oSs7xtKwuOyJHbbxrtI5bqhHTaXTEaWloHSVFm
	 RPArPpzIb/93/b1EWdFv9dMfmJoV4Wv917/irEtiUJkHTW7YfCsp4K00Ce+rcjrNDl
	 w32F5qopXnSu/6D2nWDEeuOSdYIR+n02qXO9we0ajohpVsgZGt3vdy1yrejuTfshls
	 rP5IV5GTXu+nfPX0N4qL+Ijut7LFAVGDhjbCgmuZFChA0KI52NootssNApjAuNrLtM
	 ZgM35/721o6ig==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Junxian Huang <huangjunxian6@hisilicon.com>
Cc: linux-rdma@vger.kernel.org, linuxarm@huawei.com, 
 tangchengchang@huawei.com
In-Reply-To: <20260507012148.1079712-1-huangjunxian6@hisilicon.com>
References: <20260507012148.1079712-1-huangjunxian6@hisilicon.com>
Subject: Re: [PATCH v2 for-next 0/3] RDMA/hns: Support congestion control
 algorithm parameter configuration by debugfs
Message-Id: <177868031111.2312230.3184039384666355404.b4-ty@kernel.org>
Date: Wed, 13 May 2026 09:51:51 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 07 May 2026 09:21:45 +0800, Junxian Huang wrote:
> This series adds support for congestion control algorithm parameter
> configuration by debugfs.
> 
> v2:
> * Inline init_debugfs_seqfile()
> * Remove delayed_work and related logic
> * Add usage example to the commit log of patch 3
> v1: https://lore.kernel.org/linux-rdma/20260206103110.3414311-1-huangjunxian6@hisilicon.com/
> 
> [...]

Applied, thanks!

[1/3] RDMA/hns: Initialize seqfile before creating file
      https://git.kernel.org/rdma/rdma/c/06e00315ca7392
[2/3] RDMA/hns: Add write support to debugfs
      https://git.kernel.org/rdma/rdma/c/ac1c5387287939
[3/3] RDMA/hns: Support congestion control algorithm parameter configuration
      https://git.kernel.org/rdma/rdma/c/d0c4051a6830d9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

