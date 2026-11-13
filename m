Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794562287;
	b=NLsTL1q5Wf4BcZ87H+xXuvOMgmtsvehiWgD9ZK9JFE9yM8m1VKEYx+H+yTn6uuX1OYC3
	 bM7BFCSxe+p0SMJwno/JUyMTAV7EAXn7xuL+AEVWSM0YhvTqZd4Dy/y8kwrMUXz6uEnAJ
	 4wssK8sb1UsqrpEl8Q4h/gUkc6brah8IjM0zN6smCCIBm1eDJiyg1sX4fA1zMK1MlqBK+
	 XOQUKMTOum59OqlS4RC8J2TZvY1tW2lX11ANLker4Gk3zk3IXlHQhEO2BdelHlP7Vz/Qb
	 yXE+raJrLbt0EfsfSN82jluX5BU5/8tEbR90SfjosjxeHufLijZOU6wgTnnHcorTVOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794562287;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xmL4magUuu9lMMl4lPwJ04KD2iJrGSSaK3xPvUsmszI=;
	b=y1kJdb+Sv3pznh4jtWJ5wyhlmA3SpiThH/mSp/jiqS+TVI/u9PYvC+TDY9rT905LujhC
	 BioccbKMUBJNjMF7RPZQ28W4dKwFnfvaKuzJOGMaYss1vadH2p87pgJOCL9X14y/ASoPw
	 +9UVQ56XERIOPGgOpLNpbHnVK1mx7CEWHMRAkd2a5/kebkrDilGz/N9deYnJwDJMUTulO
	 xNRx6i8bf8yu/w+g75YHvUJ7hIfK64cY1KH8eDFB/ekxLKiCm0NS+yFcihI1b76hRXeK3
	 sKZQyiS/CXJhltH9F3dXXztGmoIRCVdugzsQWZyfzu4V/9yg7vc69ILwmLX0EhE2TBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WPZbXx7m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89133606A32E
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 09:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WPZbXx7m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015791F000C6;
	Fri, 13 Nov 2026 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794562287;
	bh=xmL4magUuu9lMMl4lPwJ04KD2iJrGSSaK3xPvUsmszI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WPZbXx7mdKikpabFA40SnQzMUrtM3tUSkS8KiOFk1hC02yw0LXcKniGGIsRcMDKfy
	 CyUAVXADoBRYq4l8aQjxRyaDnLu5b5JLzCYDA3etmvscMcRB5taPCDyhfzPbChbki3
	 33JtdcdjbE5KBaVCQMiWFM76WMo0eSk6T67Psz+kIdXK838DLvst/Pp+TVwzMCvOAw
	 YpnpggYt8WRA6TULhxJKwl0fDlhXV9hJJbRKc/YA5I9rfauqNwn9T0Prj69P+3d8N0
	 DWPb52WtaAEmm0fysghB/rDJzgu73TTAyLQSI10jQEiSpwAAHccXhClzAzuDg9PN+0
	 whHFZeY3ALz4Q==
Message-ID: <sashiko-outbox-212548@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] treewide: Use struct_offset()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112-offsetof-v2-2-276ede839967@arm.com>
References: <20261112-offsetof-v2-0-276ede839967@arm.com>
 <20261112-offsetof-v2-2-276ede839967@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 09:31:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Generated with the following simple Coccinelle patch:
>=20
>   @@
>   expression ptr, member;
>   @@
>   - offsetof(typeof(*ptr), member)
>   + struct_offset(ptr, member)
>   @@
>   expression ptr, member;
>   @@
>   - offsetofend(typeof(*ptr), member)
>   + struct_offsetofend(ptr, member)
>=20
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-offsetof-v=
2-0-276ede839967@arm.com?part=3D2

