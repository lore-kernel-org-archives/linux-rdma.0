Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55D435A39F
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 07:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753076; cv=none; b=A1AIt27CGYp15lNfDPvH1V9vkZq3a+NT/OhK7qEPndn7a6fkFqYt1ew/jOjPgRPJdFg42GXjQy8JdHJMyRsk4yPytpFtUattBYaCmhD0CZCPunb4Y0a72Xx65LmVi5qn8cBdK4dnG2epcnFGhcc+vrdUUCyQFMrBSC+WKmej1XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753076; c=relaxed/simple;
	bh=zSHbLZ4ObveDaPDNp4P0jsSI5h+KUZWhDdWqMdhkOVk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LKUMbCd97oJ74lwnUN/+PbBd0WmfCTyBy0jxnUiHHqHegyJGhBNxqiQuhU3eIJ6JkI1Y4FhzJZUn085Wh2RPdfc3Wz3EXoR+dNb0hWnB0axwi7eSMBk0yvJuBsyIcnDGne+6bjFVg/gPcVFccjYXrDre5UlXdxtdpE3SP2J1uDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Si6yWxs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Si6yWxs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857601F000FF;
	Wed, 30 Sep 2026 07:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790753074;
	bh=zSHbLZ4ObveDaPDNp4P0jsSI5h+KUZWhDdWqMdhkOVk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Si6yWxs6DJIqsYcmo8FQ2+bVmxRk3BPBwyHYRtLyZLBPmGabCBYrP9l1ez71xvScF
	 SunAMVx7Rewah17JMqeJv/pUpPw37LY8lFOX1I6byu1cyUhv1HplI+tuVomVcQzzsz
	 50a9GYPA8TGybZfdNHTb9kJC7wObB8DeF3TanIjk6b1AvPjHXAwYB/uYAVWai/2pqR
	 9objDmiUI1bI9gmlg7UZVvGJsTHjWHeuK2WQAFbSUWbaWn09YOMoPIsx2RGZbI6AIN
	 lAYXO7gWfTaQrUUGo4pyQaz+CnnHMJrcqit5hfsptIbFoqnaXJm37PhoVpWLFbfW5V
	 /k1bLgbAkWb9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/hfi1: Shutdown self-rearming timers before freeing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930070455.2934286-1-runyu.xiao@seu.edu.cn>
References: <20260930070455.2934286-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 07:24:34 +0000
Message-Id: <20260930072434.857601F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The HFI1 receive error and synthetic counter timers rearm themselves from
> their callbacks. Their cleanup paths use timer_delete_sync(), which only
> waits for a running callback and does not prevent a concurrent or
> subsequent rearm.
>=20
> Use timer_shutdown_sync() when releasing these timers. This prevents a
> callback from enqueueing either timer after cleanup begins, before the
> containing hfi1_devdata is freed.
>=20
> Preserve the existing work cancellation and workqueue destruction ordering
> for synthetic counters.
>=20
> Fixes: 7724105686e7 ("IB/hfi1: add driver files")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930070455.2934=
286-1-runyu.xiao@seu.edu.cn?part=3D1

