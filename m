Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DD276050
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711790; cv=none; b=PT/NTKSgej02YRAMeufaRXj6vgPVN83Fzal/frWWEBViol5wcV21W5NbWAYvG5R1kUM+WoS2NRYmFdWdCRd1dd6TJ7ZzJIl9h5wsJxf1k520pvojck2RjDnfPDkMzgYWxqqZjoSXtAPi1sXrZIUYK/IvWdV5QAUzeE9Mq4vsTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711790; c=relaxed/simple;
	bh=X+hXKTwPWUP+DuftlT3dMtaMhLqas1vRko9ccGcayxc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aZl19Pd79bkJD9cutFmN3eE4bYFA7H6xAqDR2asyQScU0SfZ6dxYC1JeUXLg4LiEUG6xO4OsXHlSo+pLe3jo7IQlNrpFZZ29c/x7SQKwS6/13B4EDV6eYqWY5jGQq7Ts93Gh/1Ghu1VXkNdVLIJ0EI584qb6IHB8tQKC1upAHdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P55O0Eyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P55O0Eyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D941F0089B;
	Sun, 11 Oct 2026 09:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791711788;
	bh=X+hXKTwPWUP+DuftlT3dMtaMhLqas1vRko9ccGcayxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P55O0EyyPGAMqKEJ24o6eORoekZJ9AL4iR4HefiCbDU3pi9pfd6cqfJLBPj4qoBgr
	 zhY0D08QBSwqPFBstNCC/M0MXDklzvTmbkWUgJZCI7HBdRGHq17c8XfXJudftCaFEX
	 T/XsqSVWeLMHfrb6Y/4IB3oNbwJo88u4TJzcfdmtyyv5HCwGsslc+BoeNUK1nEhle+
	 H3Cn9mFJAfPyqp3qco9Iq7Jcjyt739X8OEyMRNUj9mqBEF+ZAb5DxQjRF1kNQhMpUt
	 wDteGk1p2A8gGRwKUr2abVbRxGXR0VyAmVvnIC+eRiuZl3b8MkQTZASLxOFCmDMFea
	 xCBgWq6J5o0eQ==
Message-ID: <sashiko-outbox-167143@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Remove max_external_SFs device
 resource
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011093828.784454-1-tariqt@nvidia.com>
References: <20261011093828.784454-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 09:43:08 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> The device-level max_external_SFs resource is redundant now that
> per-port max_SFs resources are registered on each PF port representor.
> Users can look up SF limits per-port directly via 'devlink port show'
> to correlate with controller number and pfnum.
>=20
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011093828.7844=
54-1-tariqt@nvidia.com?part=3D1

