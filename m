Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705068;
	b=HdEneAqOY4aKEipe4Za5Z0TZGlCzxnG3cE9W7x27bM7tY2YopBW3UGY8AK5sqPF4tUeH
	 VIDWRVTc4XfDAGWbQ4IFIhVsWWLuzaNuxR1RW7b0JPTCUV0I4reHjNXTKCkMs0HoBvjBn
	 Rw7FcOEuPob2+nK9sU6fC1flXN9wYQSpIU/mZkhQKRQLKoD6VHpXoKekZvuAlzLMDWWqb
	 CJQiKtooOjazRfF4w2ftfjdL8gE+NMU8kFTkTOChrdU/R4rd/kyzJzspIIjzSHxPqgs+c
	 Z0ewvfIuIn9udwg4ugrCBC1L/sUBcoOKDYc8YXPMV9QkrIs8r1r8HOoMnELkEM+LkGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705068;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MozNAoJbhBGjSOT63QYzNm2XiE3ErMFUhHhgAD771Dc=;
	b=yG+0p32191N0IyUIUSW7q46oS8lvYQRBYNXqoaN+w5pTfsXyZm8/xyHd6o4B9sIt/DGK
	 WZIGV/Ip+ZGt4KARb1WFpd5APT67c+bUyO0TwZ+8Nd5cbmfBUaLKzFSkOZS4UBHiTUO6T
	 KLpC57ok4o0yxi2tPJtmMtxe7DtjpN3KvA+1sYwUZjXL9P02cETTk4QLhJrRaEeSxX3N5
	 gFFJJrBT70gMZxUSWPY04zO3/ZzDUIxwESz+WSS0Ldnm6VRARJVjGVxlkpKXmDdsW/+F6
	 ICOMErHKDVHP7KqZ59ZKP1zF7lY20GN/VOR5Wzt7KAfCVELHJVZdTSG6eErdAOH+Rgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NeSs38s4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F12606F7EE
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NeSs38s4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934471F000C1;
	Tue,  3 Nov 2026 11:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705067;
	bh=MozNAoJbhBGjSOT63QYzNm2XiE3ErMFUhHhgAD771Dc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NeSs38s4K03nim5C3nJz0CpKxzqyg8UJwGGBsNsatlY4lul2JdisTynE0tf9LuTEQ
	 PhLOETZhIUlow997DCTzvwxj1ot93yQlbCE57yL5Q9wZcvFC9SrrULA1i2BFB/MyYw
	 uqdd8ZEG/0F+J4QRlkvh5yPzy7eN55McU6MPFJ3o+5FWERXqtwNtM64wxkKbOBlyJU
	 LruRjph5UuxCW28KrYKhwbI/rMRHjZwmX2MPg9C3FYQRICsfJFEOx3gHr50PC63wqu
	 ngdhv2Iw0U49FAev+3mta7LsXBFQDrJzc1hpTQLzSmzRSd1K7EBPdyYajlYVj4Sw3D
	 owaIwCz2gi7JQ==
Message-ID: <sashiko-outbox-195141@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 1/9] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-2-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:24:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D1

