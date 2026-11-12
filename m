Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445020;
	b=tswdCq46qDLrrwxA8C6j1JLsTKXZwjQH7OsGQGmE/CfImiMbAjaMvGu0MFLRPo61hEVA
	 BxeuNCLadTd+L/s1vhELXxkQBnLmV1NcgTKoQIfHHyhHNZ4eyRf2UTxaB0/F1hyKpW9op
	 7c+5Fk19VGipzureRiLD3d1+da5j2Qqia5ApRQ3ZXxmF0yqJeYape9HfOa54EIRegVzrD
	 IbwDiAbsKKSpjL8nUSE3yUb1ObbiQPwou0mnQACUKgNtNMPOtDkO6c1dztD1mE6wNuLMw
	 HroxHQKKIFjH9InC/28OBNJWREoPDd3DU/7UBkfa1rlhzeqN15wcfyLJ3FPniisMqBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z9hGb+Fso953WwNsMOxHt/F/Gol9jKYxTsQGYSyuuUI=;
	b=ejugFtLN/Z8srJrnB/isGWLaQB8rk+iI+d22ZjT1Q60RPOu9xYKu9WzxeKEb6v++0498
	 fM82yvnZax0D9kPqm7NcrJCD3ERZ9HczX+2m3W+PJNrCEA8Jr1hm26rYHFPYJ8gdV0SsL
	 cBMeiAcMZxNb3QO2OtzaCoufMcmp61GMRyslQ9W2dNZ9SLtBz+3ruajULLAFwDoQGjnhV
	 nnjVUjRSIt7K2sXOAzDEY+9+OZVHYS66hfbTACmo7g6otmPqaz2saMHLLof5USUOAyeEm
	 w09KiWDGBtLtCYYabn8ICPIpq3rZ0Qk89awC3WnYWM9VZE0gJR5BHClEUZEGUraUnLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fjh7cl6K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C7E606A32A
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fjh7cl6K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CFC1F00A05;
	Thu, 12 Nov 2026 00:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445020;
	bh=z9hGb+Fso953WwNsMOxHt/F/Gol9jKYxTsQGYSyuuUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fjh7cl6KN9hyfGCcptoS6XcBUr4hCXvnUsp9i1karpZdHN7fAsBoCZwtXgelW0uqW
	 YVbKRhnlnojhHcDGbOBb1sG1+4o3T03UUZhTB7r9FHLAy3zCP9g+T5dxOGSJ5HM2h2
	 i4NW66GwQuWuc3I2dgmzcr+TIQAmRDrqZ6LEdG7VG8i+SogR4Uf4p++C9u6M9D5Yd5
	 +4rZl4H17AkTGeYxW2NFfRZhXdwQqhSqBxgKiILRl3g4SaTsKpJz1xip7XkqyKQGTK
	 FBmBSVm/Benz47f9sdl81iWU4og2OmHtBpt5zpX49NoB1eIsTZ2MgSHThtk3NFUURz
	 ZB++U3nhHjWQQ==
Message-ID: <sashiko-outbox-210006@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 03/15] psp: declare psp_assoc_set_tx() in
 psp.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-4-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-4-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:56:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> socket-less psp associations will need to install a tx key the same way
> sockets do.
>=20
> make psp_assoc_set_tx() non-static, add a declaration within net/psp
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D3

