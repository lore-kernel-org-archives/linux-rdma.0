Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9D143785D
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 10:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985624; cv=none; b=hq2ZR3kDheiwkKGpTxVmb4egfa40vF62m6qHpbR4ZY9dELZYp1hWZ2AL1cv9RoldEVxueu1mWzbEvsIJsQvh9ALpMv2VSrvJFgoQnaKd1sDqVyTU5wMU5UOR0kWND7K3EvlIxisz7IhcJ142OxIDOLvSMC+jMWaDXe9JQvhBsGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985624; c=relaxed/simple;
	bh=nmUBqUSeR8hADJrU2npkj2J6eztBoUbEA5Q/ywBN6wo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qditAy/gWiJMyNx4sk8WcqzN/rJlzcqPzHs+sqyffDCOh0aERifIAnaVhXlOFxFpxV7D32G4i3Ev7wsJMXRJfjV5JD45FR+ZadBE7Gab8e8mjOV8mK+p5YhlS6QwbUUHf3u4bJLVOZbd4DBsvlIDlOhToZh3iIqxoggwJYbatCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5aL2CTC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5aL2CTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE731F000FF;
	Mon, 21 Sep 2026 10:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789985623;
	bh=nmUBqUSeR8hADJrU2npkj2J6eztBoUbEA5Q/ywBN6wo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q5aL2CTCaepl3JhEy2uwjSszfU80F87VGTvG0oAPynOBfPQPRwuEIGzOk6uw5EVp4
	 20zzzpm9I0mQBorkRHtuJwljTn27FpqKBbLhjZtTnj0wN0NzogHN6HD+wgQp0gNZyo
	 lptH42HsRRZMwNPNq1LEc7gSLpKtSrdGE/mgU0zE7616/9DmSsoI7uV9wG/6XlH22v
	 FcOksNdg7rSkVLzZR4uR0Y+21ssWV2fRSyibJ92+1/Ct5CAd3lkvigvNTYF3YFpzuG
	 0kgoap36Nz/buI0CMqVBoj8XF4flMb+FOGNnlb2lMRvWhdf+Sb4p389r9beqaI5zEA
	 eEMSpB/K/n6Fg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 5/5] RDMA/mana_ib: Poll UD completions and
 flush software error QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921095352.3524691-6-kotaranov@linux.microsoft.com>
References: <20260921095352.3524691-1-kotaranov@linux.microsoft.com>
 <20260921095352.3524691-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 10:13:42 +0000
Message-Id: <20260921101343.6BE731F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Build UD and GSI work completions directly from each hardware CQE and
> the corresponding published shadow entry. Decode receive length, source
> QP and immediate data directly, removing byte_len, src_qpn and cached
> status from the common shadow header. Introduce a WC-budgeted poll context
> with a cached CQE for RC polling.
>=20
> Match UD send and receive CQEs against the low 24 bits of the posted WQE
> offset before consuming the shadow entry.
>=20
> Honor the QP's IB_SIGNAL_ALL_WR policy together with IB_SEND_SIGNALED when
> posting sends, and mark unsignaled entries with MANA_WQ_NO_SIGNAL_WC.
> Since successful unsignaled sends do not generate CQEs, locate the matchi=
ng
> entry through the unsignaled prefix before retiring any WRs.
> [ ... ]
> Automatic error-list insertion and CQ notification on a successful ERR
> transition are introduced separately with RC support. Hardware error-CQE
> decoding and deferred QP error handling also remain in the RC series.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921095352.3524=
691-1-kotaranov@linux.microsoft.com?part=3D5

