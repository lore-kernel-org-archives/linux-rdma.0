Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794762107;
	b=hyepSGgGgWl/0CpXUaikXsccrmk71nhsoCBWL15oYmSDmCppgmw3IwJGexQooddQzszN
	 vflxThI7cWIvQdLbzz+1NqCPXLpM4ZqKJRF6TISWD3IXiEVHlw1ZGambitTjDqznT/P0P
	 Uxka2kFVu5z/pIgoMcIMBkpGeFaGGx+yL1AkrtkmQt33y82exS0z/2zXgxu5675Wnvy58
	 XWDYctgoO/9c/M0kpowW+XLHf7JN2UqDVbPnSBSGEQaytOkmGb9h8NHG1yrmI84nvDZhN
	 hKtq3gcwMUdom1B5RF8F6iNgu6kAgL0qKABcPZz12UwnbrwUl2ElmW8CHKNzLG8wKvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794762107;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FBYw2OTDocN3V3jlu8Tyt2v0zqEKVUlOOyIQsT+V1kA=;
	b=jVpQ2Gq+41yL+9DwnIG05NsTMwdTcqsyrJrl+ZYNBNCajNLS9R7Y2+2N8eDxy6RV7uQd
	 qtmPFG3eKNLMlRrD4uGxlc4cGBe1/x0v45VgmSTfIf2/Jn8XDd3ISSNgOnXzHY6rqX/z/
	 Hsn9L0ZfHblizJLPIPcdfSVeXdHS817O842OZcvkRrkymkHHHLMjzKXXGhN81BhSvaHY5
	 +7p4rfSOqhUWS3RNLG4EYXhP9oNcT91TSE0tG4Mz/2/MavbysD60IFIzvExnzg+vcLe8v
	 hkns3WoB2XAcq5yrT4mts/43UNHuKrz6sEdhSmeaILWZ65oIvEsKg1o25rxZG8sVzVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dilw44+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA61606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dilw44+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B101F1F000C4;
	Sun, 15 Nov 2026 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794762106;
	bh=FBYw2OTDocN3V3jlu8Tyt2v0zqEKVUlOOyIQsT+V1kA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dilw44+5m/sNhdOw6S8/MmRYcOJiv8yB3mfnY+qiVhGeZQrco0CgkXVjnXiW3AysG
	 vnPFt5D5dMlPMlM4yvCpfC8x3FPiH64TrzPBWZzO6XLS/inWbfv3DL9gzT0hF/TLQ/
	 lbI90dbGyDMBHM8Uw33oRq7Dp1BkXl8/vdimPX+u4TDag2Sv0U86Bl/P5wDrVe8COs
	 KsbUBkrtjrxifA7ZHOq2LQZCoixMNekkL/F7tikgoSDtISw2xeOllhcNJIp6mIuZrA
	 OdxINvVOeA1hMeedpkXQ2AA/XeQQmovPgsBkL80G5osgSBbSWQLYLzamXOGigGJC9I
	 r2zcaKjnMajvA==
Message-ID: <sashiko-outbox-215664@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Validate the DEVX command length before
 setting umem valid bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115164658.88420-1-dennylin0707@gmail.com>
References: <20261115164658.88420-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 17:01:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> devx_set_umem_valid() sets the umem valid bits in the command supplied
> by user space, at offsets that depend on the opcode. The DEVX object
> create and modify methods only require the command to be as long as
> general_obj_in_cmd_hdr, which is 16 bytes, so when the command is
> shorter than the layout of its opcode the bits are written past the end
> of the command buffer. For MLX5_CMD_OP_CREATE_QP the modified words are
> 232 and 268 bytes into the command.
>=20
> The command buffer is allocated with uverbs_alloc(), so the write lands
> either past the internal buffer of the bundle, which normally lives on
> the stack of ib_uverbs_cmd_verbs(), or past a separate allocation.
>=20
> Fail with -EINVAL when the command does not cover the layout that is
> modified, as devx_handle_mkey_create() already does for
> MLX5_CMD_OP_CREATE_MKEY.
>=20
> Fixes: ba1a057da2f1 ("IB/mlx5: Set valid umem bit on DEVX")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115164658.8842=
0-1-dennylin0707@gmail.com?part=3D1

