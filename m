Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8807A39185C;
	Sun,  6 Sep 2026 06:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788676738; cv=none; b=Fes2NXFbxHllxIEp6V4iTIzHUFcGPYuSLNueU+hAW8P4cV9vrrAuIgk1g2wWiaxUeT7XImSUT7Fko48OVWf+Y+YxwLaFTAGC/YGEYHw3A7Hj70gOHC7giq6h4xImLLbEgNWuHjj8SoK+G2QjhAKXfanYYP8UzQO6S6KNUX0msAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788676738; c=relaxed/simple;
	bh=m45387NOlg93S72RkEAR2aybkDg3Xe8CWqvHp1J1u4U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p10zUrF/7hZxWGn+ZSllGTUdrbpIBFtV0hJpzSiUGevdZPNX8dhaWW2RR4X7jtzG1NlwtoIq48wtJHhuMhdlHkZRnL22M1n4wQYUJQV681Pc0PwpjDGDTh6M5TeQ5Pcm7M2HZBlNdlzuUqJ5L81Fs+5eNwrDPryDN3qLewH8nKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQqoaAO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQqoaAO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAEA1F00A3A;
	Sun,  6 Sep 2026 06:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788676736;
	bh=vWEvNFhm7/hfrarsoZyyOlVi+UeYWz2Onc0lfW1h1fY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EQqoaAO7bPLH9YmOoa6ZhQ169p9b6vFXggXtk0SM5AlGrgTZo2ADp97VtahDbICLv
	 ceW8deiSbld7EXSnhRevRQBPoyLHTHbrGsld0A8PavkQRd8Gz+XIvYwoQkBku/O1TB
	 lcpSr9EAuXMZ/En45qV0nkthyNhPbGXWBMaAL3vxYKZaV0aK/x6sz4Pd/Y7kRaqaEn
	 Td6nWUCyGcKhkD9+1kQrGpGl/CLBv+vXBQAWXkmVhLMR7XuRxvNmzntwISb6/UoWff
	 ezzIzr+eRt4xW3wTzorufwebX/1JHWbz+czdgF82m6tbiErMqZSGNDpXKIntfnMmE0
	 6bEY0PZiwiM+A==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, 
 Alex Vesker <valex@mellanox.com>, Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Carolina Jubran <cjubran@nvidia.com>, 
 Ben Davies <ben.davies@gresearch.co.uk>, Cosmin Ratiu <cratiu@nvidia.com>
In-Reply-To: <20260902-avoid-rest-oper-up-v1-1-04fcd4916cae@nvidia.com>
References: <20260902-avoid-rest-oper-up-v1-1-04fcd4916cae@nvidia.com>
Subject: Re: [PATCH rdma-next] IB/IPoIB: Avoid restoring OPER_UP after
 multicast flush
Message-Id: <178867673331.3919623.1035318055900032464.b4-ty@kernel.org>
Date: Sun, 06 Sep 2026 02:38:53 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 02 Sep 2026 17:06:32 +0300, Edward Srouji wrote:
> ipoib_ib_dev_flush_light() temporarily clears IPOIB_FLAG_OPER_UP to
> prevent multicast joins while ipoib_mcast_dev_flush() is running, and
> restores the flag afterwards if it was previously set.
> 
> This restore races with ipoib_ib_dev_down(). If the interface is brought
> down while the flush is in progress, ipoib_ib_dev_down() clears
> IPOIB_FLAG_OPER_UP, but the flush path may set it again after the device
> has already gone down.
> 
> [...]

Applied, thanks!

[1/1] IB/IPoIB: Avoid restoring OPER_UP after multicast flush
      https://git.kernel.org/rdma/rdma/c/9a141d3dc869d1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

