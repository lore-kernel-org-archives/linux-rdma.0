Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4C32C94A
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784192101; cv=none; b=XXzh485YTj9OPSYtgcKrlVjSAwU6Sy3OSPTOd/Dta5UewVK+6WlGuU57YrfY39DbtZ59H8zW9KSCYRDiRGVlp2ehY8B3FFetsz2b67CZlonNdYyEwHhI1oIVtj3FLUA7qUKV0usLOxzesWTVeHMkw/PZqAeWRT74noO1XFLnb+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784192101; c=relaxed/simple;
	bh=HSJFGbcmou1oF1XHp1VSRVx8Iu9SIGL4nx7xjiSNgrg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=B310d5khBn6na1I8TvL/6EeS1d2igk6TYIzFXFgUge2QakT28xXQe9aC3ImSn1PnW2NoehDUdB269DMokx5SOFNvYCEebbQxvuR2ppKgof4I3/ZzsyknB/OMsDVjefR0XHGEuPoRb/miOeXDa0Agjb+/wVOZpofjx/4ZbzPKCu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYzoB7g6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYzoB7g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5F91F000E9;
	Thu, 16 Jul 2026 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784192099;
	bh=P2RxABq/SsR7Yrap7cZOSxnwjQtqbReYpvW9CNVp1uM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GYzoB7g6RXLouZfwxMrdNeABBVR90zPADMmXNXQ64ao2dGtJKJQEQLK6nm0eYhM8s
	 YyNegvLmc/k2HvquPGgco/pQbfFPNg54I2WlyqhsSafGB4DCCyBE6MKBUAHQ75PDgC
	 aqDhS5wK/D/txSKutjEIPEwdqgX9+O8hLGoOQl5dtVu461TonQo9Gl3bACuYyA9EW+
	 iUz5lra2LZhUyduwap4T1/Zpqdvpm0CgMIoBdOuwCGAalUyg8h9N8loJTUWbH2peSg
	 f5/7Tk9bzLBPAMPL1cYhP0RU0NED9V36bhumqg40OEZMGyeT6IIW121wDtihNj056N
	 xEe6/JiSvj0ng==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260713171257.3131493-1-jmoroni@google.com>
References: <20260713171257.3131493-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next v4 0/6] RDMA/irdma: Adopt robust udata
Message-Id: <178419209710.305109.17217540199424683841.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:54:57 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 13 Jul 2026 17:12:51 +0000, Jacob Moroni wrote:
> This series brings irdma up to uverbs_robust_udata compliance.
> 
> The driver has been audited to confirm that:
> 
>   1. Methods which do not accept udata input perform an explicit
>      check for no (or zero value) input.
> 
> [...]

Applied, thanks!

[1/6] RDMA/irdma: Add checks for no udata
      https://git.kernel.org/rdma/rdma/c/b73d60960e44a9
[2/6] RDMA/irdma: Clear udata response buffers where necessary
      https://git.kernel.org/rdma/rdma/c/09f1669bc0c52c
[3/6] RDMA/irdma: Use robust input copy helpers
      https://git.kernel.org/rdma/rdma/c/352cd4f284be25
[4/6] RDMA/irdma: Use robust udata helper for QP creation
      https://git.kernel.org/rdma/rdma/c/c424ae17c9ce19
[5/6] RDMA/irdma: Fix legacy i40iw compat check in create_qp
      https://git.kernel.org/rdma/rdma/c/a2ab0d286e130e
[6/6] RDMA/irdma: Enable uverbs_robust_udata compliance flag
      https://git.kernel.org/rdma/rdma/c/c8ed18645d2c1d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

