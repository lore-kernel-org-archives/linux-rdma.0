Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383904;
	b=kGvNLaZS+fyjlIqVTIOZn1uUl0wsEBgZFfwi+iGkAr+BUpTVxDw7JmuR55IQ12vVcp6W
	 Vf5geOMnfLYNCzJk/s3Ey+Gul5G8pASM/6JojvOEPhhOgutqJpDaF7WK3Z4fEcEVavWCU
	 aDvMurH8lXOLJOc9si1Jmmzpf89TpikmnTkI0bgOCNiDvHKLaiCX6aF8ihDoUbiYd4LBX
	 hrvSeZQy6sFJalja2hqVkLJhLIovkLEXTxUE1ukLTt/7dgKfPCuVy1C6NzwXM5v+7HQmg
	 UFdYToQILxkn2oA3ykvpXuLWLos/zKZlVxRfzQQCcoIKaID+zExUQhn08lNdcBPCXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383904;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hj7exSx/wU+wrmvW1UvVx6ag6wPIoatbUnhQK7bpxbg=;
	b=O+27wDLWx0rFMRi5ilWFO+7ZGKT+tZOyVCtSw0GbvH8HOmTCIohNkIlYClNBVHRLLyFI
	 7Srbtv0YuxCUHnm2pWaJllYBRnnZQBClrqIxV4r3Jw1yMCPne622WxbHp26gW1NwMDUzO
	 SCxHh1r3dEif+D6Gd1ubq9YYJJh8j98mUQuEG/YRaR/7U1w1WKf/Hrd/5vf+DWOUBYVAn
	 fcbcJ6JYJ1Q66q1E1R+6ZhHSN5NAumHhm3VkejSGBx2jTwXHSipyEL08tPUu3KoHj88fO
	 eOd5jM0sU3RDfEUvoHCEGGFFJqmLnLHizgxCyHqbowz94ATREJGUSO99YPhlTV7VrYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IiE3NQD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E7C606A333
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IiE3NQD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE8D1F000CF;
	Sun, 22 Nov 2026 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795383904;
	bh=hj7exSx/wU+wrmvW1UvVx6ag6wPIoatbUnhQK7bpxbg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IiE3NQD+bgeKff09+khW9ArFKgqO5EzZLArQ01cSDNwXCEk6sbbKIWHFiUUwNz0nk
	 Oz8e8MMxQ4ejvmng94HRy8nzZpFW5BEC1MdJbyQUJHLOcPQcQNXNazsX6B87R004mS
	 LgBOINz+xH4gGEyD+0x7CABRnUERI+RE4sTdB74tVcTdZ30AZyw7PHmD13faeANrRD
	 C+yV9JOKBgx+xESuMqloE6lS9eOKzs9GDyqyfyubZiY58F1JtDRqSIiOPVpJH/wmPl
	 O9RCLzAW6MKCvsBoGhxA07dTdwxnFwufdjCr20dw0zItFjrb68w0ZoKbeGHs2BZJKu
	 64IUr0OAibp4A==
Message-ID: <sashiko-outbox-228375@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 00/11] tc flower: tunnel key partitioning
 for RX queue steering
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122213200.3207385-1-acassen@corp.free.fr>
References: <20261122213200.3207385-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 21:45:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 11-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122213200.3207=
385-1-acassen@corp.free.fr
