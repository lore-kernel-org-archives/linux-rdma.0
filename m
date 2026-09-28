Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C172244AB9D
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576123; cv=none; b=KgGnUkCUWN7CHvpvhgdFQvfET4Z1Iq1poFrVPECvb0dH5Gk/BUB5Xlols0KORMSF2yrXPxGpsJLE/HXszsu/IoRqv7huFVTuCC/J3qYkuBUI1oIp+/auDBaOM6+lk9CbmRpgdm44Kjt/tmShcil/N/ypm7Vg8X9/CveGOxjFgwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576123; c=relaxed/simple;
	bh=PLm2s027KIayVS1+XCT2SwYviPWVd4uZhzDhKUbByDU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R+pM6d9DR3FwXuCToFjp58zZQCXn3OrVleuLfG2tc5AP8B5aUpX02djDeDviuUIRTxPhNdkNkso0zwOsS4o7il8EoyqQx4XirRpitVNsZ1N9DqhMZVQp4Padje7BwEHyH41FNiVWmXrSYPaIHi2Db/DKHpvMKHVoRcroY7CTc2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8BvdWTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8BvdWTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC03B1F008A0;
	Mon, 28 Sep 2026 06:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576107;
	bh=Q5dSEEd5pPbu0tY7N7MBiArnWaM2Nh/acdFzW9M133s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g8BvdWTefYiizlhDWYj4b+PDvpclui/Qbx5C1C5v2+pBlBPxKZG8kueu2O+pqt0TY
	 9R+XwvvLZmR7CmOiL/UdK2ys1NqmqoC4PASp2iBJwPwi+ZPMiJCb4Z19bFDpqxiww7
	 3NZQY2/yqU5ZwJALeupJfZFezKW6adn0T3P20rsyr+FUl+fN+nCtdsEudMNmYvtLnk
	 FryFdSycY2S4IsgfoapilOe2CMxcob18xhz//o4jdknJytW6q0dunpumR0xnppWGT2
	 OHixAJkaIdVE/8oBrHolb2yc5d+RQS3yu/ccotNXI+ZYEq8y0ui5B7CkhBD0iodcPT
	 xyhT0Mbkb8hqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 08/12] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-9-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:06 +0000
Message-Id: <20260928061506.DC03B1F008A0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by netns
> teardown or module unload - and every dereference of i_conn after that
> point touches freed memory.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> callbacks walk a receive queue after rmmod freed the connections:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D8

