Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810633;
	b=qB437vzU7ybtVc3I0l2DhrDRaTf9YFnyx114oah4Me2oKFlvte+OlNL2DurLRTBSb+rB
	 LvsYMtFgZ8w3wQ1hjlu5+XAWAvv5vSvOFVAGXeYTzJ2/aKkZiQEekdww37082jX7GjSjM
	 zo9k7vfKPJK3VJjbv/cQoH1RFihh/ZVadgZ9GvIv+t7Q9SeGByl1lit+jO+Sb9tja34RL
	 Q6KpzR/Ao6gDWSeHwS5xpxFCpghvx36WUIikwqjehlA6lHrnBK3DC71/2qXI7+Pf1mhsr
	 LYCuUnJA5Hl+lyXX4ZoNcMty6EWadUkZY91i03Ovg6FtAgDeB7sxCBrFo3oqJ842zrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810633;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UVn9oPdy/AL7LraNfi+yUpQJA08H8ke4ppAYxCWCDyI=;
	b=ZWxW+ET4D0ZpnUDQ91l8wVfDLoczNH5pXgXfnPBlLlwYhfsJTXC2+ceLkIVxg0aANZt1
	 0jKdKSvdZCLLwqI2+VUj72WbdI0XwItETJuxSPqfj7zjA8LhgGxqGM2wpBCc2CD/bZDmE
	 n8b6GNyXMVRDtfutkRGdjtpME4vYFzF90V9UdFDb7+BsEBSy1BgVvrvoETo7G3h8hchZg
	 iPIwofV5XVgDPo4uMOolmLNc6BpB9ai6CZsXSRTy3cbWhQkgH50wJWCIjlrawZF65aHb0
	 4QJ8NbFpAC34DWbvDsdpJe7czXjF7LsTAL40/Vt/15aG0sF3aVfNLKbTJ3bkD9aSLsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0ukxo0s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E278606D812
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0ukxo0s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0856B1F0093A;
	Wed,  4 Nov 2026 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810633;
	bh=UVn9oPdy/AL7LraNfi+yUpQJA08H8ke4ppAYxCWCDyI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a0ukxo0s2uK3UwH+yC1wwHVryoIjKQqOO6UIXEY4mk/0AruNjzGEygZl0YPaQJ4B+
	 YnVUzcKaY7K0nby0tej0LikV+i6BpAaKr6Xt4cBpHmsh5rE2JETWMvkuwRC7u88ehI
	 Dc0yQz4inHoW0d3gToGoo74eTl8TqxcKYRnLHtt1cGLlvbP3/ASm9SlMciXPPia5gM
	 lPE2X6LpQ0WdBIb6WWNTBrw9IrK6uIvBnZbhPlUcQC2gOmMS5ga3zmZSZA0LXvxd8i
	 DMoEMlnE74bV7N8OJCVRwatqRe5EeIXe9lC//mUqtQjAPVmjiWZl0MdCqjCkRMiyPY
	 6nsqz58NqkQPg==
Message-ID: <sashiko-outbox-197673@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 20/23] RDMA/mlx5: Clamp log_max_* shifts in QP
 and WQ limit checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-21-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-21-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Several QP and WQ size checks in qp.c compute their limit as
> 1 << cap, where cap is an 8-bit log_max_* FW capability. An untrusted
> NIC can report 31 or more, which makes the shift undefined.
>=20
> Use MLX5_CAP_GEN_LOGSZ_U32() for these limits, as done for
> log_max_cq_sz.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D20

