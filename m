Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5C2175A7B
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 12:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791116597; cv=none; b=ov5+c/csA0eqqKyP44YEcKhRaa3L3oWT2VBg5z9x0AiclwkEu0P0w0pF6sFpRlHv0eE5Q5ByTKO5V/Apwi3EimpxgliyDCVmmoex2myal+jtodQVR+H3UpJrkVdWoosOUp7/5Nii39pCWWAqkdVPlFn2q43A2VpUOwyeVBCYY8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791116597; c=relaxed/simple;
	bh=fTXEVuf6mHmXOwUFU75rgnrLPROfZRkuUAL0Gz45tjo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ad6yAMD9yzpjGA4vD5eRiU2YohS9Gx9LkwwfjxYm+I8uw6p20ZJedvp4/cuUxDHVjamOFjhMj60YE5b6d3Eso/TJ4zoODxQ7kQgvUbcf6OgQw2W1GfQu80OJPmE0xeQ2xYo12us+fOq3FFq/X0/wnHs70FiwRekEVSiWj3Hpi2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxBdztaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxBdztaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC1F1F000FF;
	Sun,  4 Oct 2026 12:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791116596;
	bh=fTXEVuf6mHmXOwUFU75rgnrLPROfZRkuUAL0Gz45tjo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TxBdztaz5XYVTUlrEVwy44sRgKxvtjVElV7JWdCTGS/HjQ+/q50cgPokQZnQ7X57z
	 RBtPF4Zc8e83I1K2Zl2Q9BtNXl7NPXd4x6zLSZcejFCCov4/ZbXHGbF7SaAkBmohfW
	 N+DhNgbYQtvqEcAWX90b45YOhh7FvHFim+SnNt1Xc4Zwk1eMKvbldqCBwFS4NqBMB/
	 5iDhRiL1zS6MbA90jIcoaLgBeHKfo3abQd93Hx9HbPTWNAZE6sVf7nHdWDznCiu8Oj
	 3iRqw6GEsr95lr1tRDv1xdl+BD1mcZS0PMcPAf+q/aXP7cot0FMvG/NSUWtndeJiDi
	 jIYQnU6qQ4RrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx4: shut down catas recovery timer during
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
References: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 12:23:15 +0000
Message-Id: <20261004122316.6FC1F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The catas error timer can rearm itself while the device is being
> stopped. If poll_catas() is running when timer_delete_sync() drops the
> timer-base lock, it can call mod_timer() after the deletion. The delete
> can then return with the timer queued again, allowing a subsequent callba=
ck
> to access teardown-owned MMIO state after it has been unmapped.
>=20
> On PFs, poll_catas() accesses catas_err.map; on VFs, it accesses the
> mapped communication channel. Use timer_shutdown_sync() to prevent the
> callback from rearming the timer once teardown starts.
>=20
> mlx4_start_catas_poll() calls timer_setup() when device registration is
> restarted after reload or port reconfiguration, so the timer is
> reinitialized before it is used again.
>=20
> The change was validated by source review and a target-object build.
> Runtime validation on mlx4 hardware was not available.
>=20
> Fixes: ee49bd9397cd ("mlx4_core: Reset device when internal error is dete=
cted")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004121259.1245=
171-1-runyu.xiao@seu.edu.cn?part=3D1

