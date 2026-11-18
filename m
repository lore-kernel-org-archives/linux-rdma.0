Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994193;
	b=1PNorny6aHf2/2sz7CBaCYHdbSmZDzuJnwaxWCSrBOKWx6OCfIntnmVvoiH9eL+XSQbd
	 KmMXd04WG5G7LlppLOmAF2F7Us8IKi6mHEvBK/hbvBcpDArl+xx8EcAtsrFN3gT83dDlB
	 9xLyplGKzmAjlrzJmaHB4yVNot9gBgpAGfuZnyPZiL4eoKbd3ydtJpApzbQ+9GTQfO/L+
	 SPfY57QQDmMN8k2qKAERhwqChqMTOw1WQ/STTbQeZF4Fe107VfDEV1VhI4CURbY3kGkyc
	 Y4GVPmDzeiXxlG2h9ktYM3PuTd/gOKgL31Vrk2YEUTUwxn/1pm6yw8z9tDAlhjjezdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994193;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FOQol5O1U6GhJ1VYtI8ylsy4SJ5t3hT2iiBF+lR6fU8=;
	b=n1zL44REpaVb/Yw/0NvEjPxB2826c5N1W3Yp6DteVoiQRPNAQ561lLMvyBWndXQMXhWO
	 UwQXdbua6cguYCRnntE03PRzePGkWu44PfmW3alSvAjMPnLEahxOLVAIFWm77vpCLlcbA
	 A+L17+C/6N0XazgkTLuOicLSgRyalP1n6z05QSlWzbEIy7+/91EROUMnSJLwUVIEmZDsp
	 yn0gciB7FSDRvDJmgIvODtR/vHqQHS8/DAKwTupDEIAVmVn5R8/tpg/Th7LWY1HABEyI3
	 xwFHe5Rn9iBad2c23czSmyBHr30oAlwEO6bOls2PDMFLDcnHsmbZPWGAZT+hkVh2XeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3D3WWrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD0E606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3D3WWrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95C81F000C6;
	Wed, 18 Nov 2026 09:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994193;
	bh=FOQol5O1U6GhJ1VYtI8ylsy4SJ5t3hT2iiBF+lR6fU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M3D3WWrLQXTkQN77VKhrUJllA5EsYHtxrzJbD9WogHofrDWQOnYkCrj2Sozbh/u2y
	 DHhOG6yP6PZrspdCL+kDQfG/1vT1t9PyAlfniz1v4IVMmvZtzv9rEmMydqxfu2yzUX
	 aWS2aY1ynwJ0PoVTY00ctONbY68GK4FKn3PHoZOycuADuBO/Ba3ow9wdSA098aDMR/
	 83XIra0fLNjIfrcQ3rC1rqAZGk5lPtOqO768KpqjZ9seYIA/g1xx8VKbvP6CcNmlLS
	 mGjOg7yDiORuVARteVrB+56Oka8UDZI64TEkA9HrWOzGdm0tpywQpVTc3k11uEZexC
	 +eauFVdbCgPNw==
Message-ID: <sashiko-outbox-220566@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 05/10] net/mlx5e: TC, reject a partial
 tunnel key with tunnel mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-6-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-6-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Tunnel mapping stores the matched tunnel key. The metadata of a packet
> missing in hardware after a goto chain or a sample is restored from it.
> A partial enc_key_id mask would restore a wrong tunnel id. Flower is about
> to accept such masks.
>=20
> Tunnel options with a partial class or type are already rejected here.
> Rules without tunnel mapping keep working.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Tested on ConnectX-7 with firmware 28.48.1000 in switchdev mode.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D5

