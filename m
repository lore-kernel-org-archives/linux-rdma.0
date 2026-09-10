Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9960845A28B
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037189; cv=none; b=LxtC+UTfMDIkqp6UYtYPXs1HOejvnL3JJDyaITLk5I5BpXMU2Wk+twgUeFU1ZYrsthdo0PmqmrmR1sSlRrkfXz1G96b6X1WUi6xCJ5QFDhRXT8CZofQV5p1+AXEmGsTLTgjhnOMUSs/k3TPOTWAoHoEdTJooXLH1eckIC1itJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037189; c=relaxed/simple;
	bh=oyZUUdwsW4sSlcCg8ECU3cqGNhFsxOv6EzCwDhYdoLw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Up4+z8WAhLogQF6tlygq5jTCLCiCEgV6VSyTFvNAT7RcpO6gF/Ml1BFSqCn9BkRwVp0wgpzgD8oDO+ZNMxMBXbOpYF6b6bhYw2MzzGNE2elf2nUlD0VYQu+Sa9STg0CWsHR/FU2yret2JHn0jjA1+I0SpoWnREwDyfLpek6J+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpWhzK01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpWhzK01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8A1F00893;
	Thu, 10 Sep 2026 10:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037188;
	bh=oyZUUdwsW4sSlcCg8ECU3cqGNhFsxOv6EzCwDhYdoLw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JpWhzK01+knfVTrgdPTFgZj2vB/bcUZOlKPjSJYU15FDBVLTlVxWjl+iUTJr82U9Q
	 mwFrGHXblsw+ZXv3uFXjFXHrbTrxj7uMIGDysUjX/3rO+1llSWI6ZEhNAoCVFLDdBT
	 fh4u9HiBQH9HslsGpVpQmxBHxSl4LNt6ongtIkf4PuZzAXHpxSOgWB/OV1HKXz2bu1
	 WpzwsagzXYS/RPsp0ci49We7kCqDwOQ3ZCT9D83fFdow8UfNp6V48ZbzeEXcMyPgfh
	 AJ2g499czLJXN5vR+TzUqsp49z/uAt7a8QM7+l2tSnIQT2GQPimB5cbozLibCo023q
	 gKPk3Zu0/3MQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 4/5] net/mlx5: Lag, limit aggregated TX speed by
 PCIe bandwidth
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910102432.3845360-5-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
 <20260910102432.3845360-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:46:27 +0000
Message-Id: <20260910104628.44F8A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> FW initializes max_tx_speed to the minimum of the port speed and the
> PCI bandwidth. Modifying it with a value computed by different rules
> changes the meaning of the field rather than updating it.
>=20
> Limit each uplink's contribution to the aggregated LAG TX speed by the
> NIC's PCIe bandwidth and reset max_tx_speed to the same value when lag
> is torn down.
>=20
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to v=
ports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910102432.3845=
360-1-tariqt@nvidia.com?part=3D4

