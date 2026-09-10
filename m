Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA5D45A297
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037848; cv=none; b=Qejv3C1ZS+hBCh8gxZ0StEJbE3MlEq02k3uxs285CYuZc6iW93bxFcxwYD5HnVRPb4O7Eo4wzGBtiraxNPhcmxPCJnMCUL2cdxXdXpAR//fCOPoXcde5O5M7OSx72hv68F+pmeioZKE1jpeuaf62U0XJOCurHG1W0P7BEko0b2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037848; c=relaxed/simple;
	bh=c/WzTfImlfPcrUYTTxlkpk35r7AsSpAINEm5Z3B5Y10=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dYDrHCeLWp7TygZDlTU5REwI1gpcqK5qNMW0OM9x1M9dnaFfbguabGxUxty0CfSMiGCtlpsstzQEeylhwAENhLD3MNrgiSsOLo3i66a8hCbMKb8yyHOqYdT1ZWFNyVLtbL0IW4gCIojoz0znYqEBcDvb+9txIubeEk5MvbwHshY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilN3VrX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilN3VrX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD95A1F000FF;
	Thu, 10 Sep 2026 10:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037846;
	bh=c/WzTfImlfPcrUYTTxlkpk35r7AsSpAINEm5Z3B5Y10=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ilN3VrX8TgDD5M77IsQkwtgYhy21Qrnbdq7dBG9Mj4Mj/kUb8EcdYwVvwnJwDZJe1
	 E/LE4Qzvw/JBlYjJO75WDSfdfZ/VVc/tHL/bk7dZek09puByfhjGCl3rpaiVfUYazu
	 i211f4EL28gJjOGaIM+ZfzqolYG0VnozmxI+1CV1uH7lmbf1fW/wCO4YEQaPkeSFvn
	 xM8lYj/wy6t2PYnRr9q+Dd3ogOQpq1iPdiTG8E6DaIcs/oizJVPTde1Ns7ceFYwyzO
	 3hX2Hk/Guf4qSgJuFCNoPH1i+/1iZjrPL8Us9yuIMEy2qvpZ0JrYYYtbQQ1OrTJ8OB
	 MP/0QpMy2xd+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] RDMA/nldev: remove the unused dellink link op
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910104906.19681-2-serhatkumral1@gmail.com>
References: <20260910104906.19681-1-serhatkumral1@gmail.com>
 <20260910104906.19681-2-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:57:26 +0000
Message-Id: <20260910105726.AD95A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rxe was the only driver implementing rdma_link_ops.dellink and does
> not need it anymore now that its UDP tunnel sockets follow the GID
> table. Remove the callback, the nldev code invoking it, the mutex
> that serialized it and the now unused ib_device::link_ops field the
> invocation looked it up through.
>=20
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910104906.1968=
1-1-serhatkumral1@gmail.com?part=3D2

