Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD90311597
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 09:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428773; cv=none; b=BkfxiJ4cHDRLXduhleSAUMBVk6ZgYiTzp2Z9SX4YixDZ/47WS0PliY9mV+7rnqf/qCxtHL0aTJfv0ctaGqLs8Ugq+A+jnwOq6Q+P6Q34vQgks7u7H9AXiXlVvUnUhNt/6TpbhKZYpCO3Bk2dkd9ak247NjR0YNeIolx9vsNjvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428773; c=relaxed/simple;
	bh=dPvZK+beBAVQsmePvU2pD/0JbmI32Cvw9xhTffmhvC8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p3EU/NcKcT9r3ZVTMRYE3vk/pcP5I+9E7/Gv4A5Ze10Tv0uBDBf2Z/YbyOxqvfrlCdCdNCC9balRQe2NiIEjl+E0g30VA4u/3WOPgMBEoqX3b1WpmFEiSdynOkeIoob+YQhJmmj3uYm1XG26q51LfKDcP5raPuWiSBhDac6WUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJgyFZef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJgyFZef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9F01F000E9;
	Thu,  3 Sep 2026 09:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788428771;
	bh=nz2T6lElOGpPQ3M3P1OOTWb/b5s84qBHqU8q9IUN64E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=JJgyFZefBp/lquDVNwAIVNsqotLQUNsYcqEQeh+I1oFyIuN/nfjKJH6LOmf2cfPvN
	 3nNNZ6DNfsyO6COQHLxBII55SXQyfsYDmyTiwK7cbZ8a9efhdbH9jVYgMbuGTqZlSF
	 tRMDa50hre9hxcclChBgQ9TtlMhzXSL4T3jLG303dejMv+e/OlkULZwT0BQY9TZ8Pz
	 twgYSrOQhlCDXFFqqVI08BqmfmkZRYfsglvJ3KJQZonTBW1qqL+EUTw8pRk/X+JNzZ
	 S9V9AwN5OmiZkqMnS7VhbcS7PA3J3IctihVn85blwftkNvFYTzt64xlIzT/DsxDK8q
	 wqOnQnFktYhJA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 Junxian Huang <huangjunxian6@hisilicon.com>
Cc: tangchengchang@huawei.com, linuxarm@huawei.com
In-Reply-To: <20260831020324.3540901-1-huangjunxian6@hisilicon.com>
References: <20260831020324.3540901-1-huangjunxian6@hisilicon.com>
Subject: Re: [PATCH for-next 0/2] RDMA/hns: Workaround for CQE drop with
 multiple SLs on HIP09
Message-Id: <178842876852.2689485.112622801437992895.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 05:46:08 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 31 Aug 2026 10:03:22 +0800, Junxian Huang wrote:
> Due to the hardware constraint, CQEs may be dropped when a UD QP sends
> with multiple SLs. This patchset addresses this issue in two ways:
> 
> Patch 1 pins the SL to the value from the first post_send on a UD QP to
> prevent CQE drop for regular UD QPs.
> 
> Patch 2 provides a debugfs interface for GSI QP to set a fixed SL. It is
> allowed to set only when the device is link down.
> 
> [...]

Applied, thanks!

[1/2] RDMA/hns: Fix missing CQE when UD QP use different SL
      https://git.kernel.org/rdma/rdma/c/566cb59f636236
[2/2] RDMA/hns: Support setting GSI QP SL via debugfs
      https://git.kernel.org/rdma/rdma/c/6ea2157ce8c749

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

