Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365253A6B71
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 05:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791524081; cv=none; b=LF1Ok77aWqnTbr6vlaW/cRW2a5fxzDt/vPN7inVQ6Qeu7GXIyklNc6/cZFAJogYyFn2d78fKQX5lrWxkpJuzeDX6JlWMskL1kzSQpUxqK8kEDpzfBD4qkj+RfxXTPNDsSfIKD/5dYbis7ubQx6F+G3OHoBwFCf66bzJwhqkeyo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791524081; c=relaxed/simple;
	bh=5V8GZEBMFiL7mToSsOiOQVusAlLWgRik76LHr7UTVzA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kJNwE2Zqffm3lS4d3Ofv5To9uiOTfE+I52WWjZN0JyEgdZCsJw1VhGecop+R5cgQuu0YWdQ9YJBVuouiqmiKL8HXkfMnDLzcCI/qyGoqf8dTwroqZa41oJdFTAuUImyvKkdIfgpXPQCVxC6dd/AdpmXTlvIJ9modK2WilagmMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmKbfdMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmKbfdMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97AA1F00893;
	Fri,  9 Oct 2026 05:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791524079;
	bh=5V8GZEBMFiL7mToSsOiOQVusAlLWgRik76LHr7UTVzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GmKbfdMX++EnGC5tpFS+FrNjz6BIPJJTOKG88qmIr00bw9dmQPYVmFFVWHBC94L3w
	 U2OzwcNWb+j6ZcJdWcgxs8nXGHfKwQuS/QT8WDQdcahsm67kACc+YRDq6PYzjsGETo
	 zuk5l8vIHQlXe9AIThbmjOgSNkwjFGmg1RKyhPwqizUdoye2mMONr3qTo8oKWdN0GI
	 /ebiFPTD+GHyKg979oNhQlQ5D/z0xoto62RQ4ZPYRmMTIBMWttWto3ZT1UAw8f3T3o
	 Kk6TPQ7fzqwkiWnG0ApusWW5zA7sCg87BrHbYbDFwpkzS7kChT/YyyI0TT2YDGfw57
	 NaoWzKMsiixrw==
Message-ID: <sashiko-outbox-164902@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] net/mlx5e: TC, free NIC flow parse
 attributes after offload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261009052103.3621855-2-acassen@corp.free.fr>
References: <20261009052103.3621855-1-acassen@corp.free.fr>
 <20261009052103.3621855-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 05:34:39 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A NIC flow holds a 4 KB allocation for its parse attributes until
> deletion although nothing reads them after offload. Free them once the
> rule is in.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009052103.3621=
855-1-acassen@corp.free.fr?part=3D1

