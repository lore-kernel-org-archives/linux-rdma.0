Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932178;
	b=1YEY6CU3WmZMSKjfH06MmdQkF8+uSn+ZGPoen1rNcjDNMtMn203DQfZh0jZPHblOAmj/
	 If7Op7jKrCIkw6LzNfAlkpnOnhBoZzq6WjIY/fiWq+BHiwOisRjHtkJooUQ7ZR5LcmGQi
	 EhL4Wa2PeMn2a58cqWORh3ig/GWgH7XTpI+n1Y0kKsHfNyNun3uE3t7pXHsLfil4rjEJ+
	 SBZA+1OQ8xnFhwwpaGeXQ1BTFF31pUxHMI2X/9bwyARLDBv1+++1dMWa5PNdKlCQtLGhX
	 1K6Ya+3SrSF4FBsLcDyMKj5SbUoE4PnqFAjmd3KxQHLK6HcU3eY4U6OSQDZW5IDT3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932178;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7YVCyutoNgm+nP2l0kokCwQGsJzoK6xTklgohHGs4uA=;
	b=ZIpYIXD4RV3pN0fnLPKXUaRfaTaAG8eJG+qMU9K5DAiJp7Qf8Vvof71NMdJoccRPwuuU
	 nVqVHZkxsBARCxgJgpHR8JkrIqEUQdB7uvGjKwgiA/mrk5VO/dB4xaCZw3LyzNxhTZiS2
	 UOoXEYynOV4CR3l6LSlY6qn9Ss4Go39ISveRtXwJBDgBU3ihczsW4+f4nnJjKrT+056jF
	 qau/+wQ/N7t6Iejofofg/rg3WH1uUA3QeTDdvwFyvUp7E2bTSQx/qqjiKyWHZ+Rx+ZLO6
	 qrZI+b3jddxqBK9z3Q/VcildGfpvtCN6+ynWe/q8OWNGmIdv9z6F7cwavivFFwuVFNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H3GVLdAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C94606A336
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H3GVLdAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE321F000C5;
	Tue, 17 Nov 2026 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932178;
	bh=7YVCyutoNgm+nP2l0kokCwQGsJzoK6xTklgohHGs4uA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H3GVLdAgJgkShhat0BzCYXRlc/MUZIQ2n9GdFLzUKlw3UtkUdfJTdS12iL2U1yG1V
	 57+h4soc7NsQW3t4P5dfiFTUIskbpbQCs0zB9EQCvhfTdbBNqxMLoBjNSlEc5cmHfw
	 p2gja+4SyH+o4roQpsAARhMtGz1nat1ntvPruDTdmKpQt/y/L5rW9fx9W6Rcp5YsRI
	 P0B0js9OLSgs9u08hdnv+QRUZizGlSQF8c9oz4544fby9PpDfBWis9G2BAy4pC8Xom
	 C3pD1Bk6FMyzBZs2hQIyH9arTVeW+XeojrY1Q9+/ozCqNbB4F3MF5rme3sAixuEcAy
	 je+WozT3PbeFw==
Message-ID: <sashiko-outbox-219150@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 3/5] net/mlx4: factor HW loopback DMAC into
 mlx4_en_set_loopback_dmac()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117155353.2250540-4-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-4-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 16:16:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Extract the code which copies the destination MAC into the WQE for
> eSwitch loopback into a helper. This helper will be used by a follow-up
> series implementing software USO, so USO packets between functions on
> the same port are looped back too.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117155353.2250=
540-1-joe@dama.to?part=3D3

