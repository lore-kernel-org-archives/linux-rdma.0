Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795871717;
	b=1R2nKmKrWWVVGcvYhPKqnBe/DG1fnFhGFqygTjpeSdzYPSqOxWNQq5kXLKeThpvEOHHS
	 WTQpcKiKoLOFi6bp+O867doiNj5251y9eYio3U+tTkTgZUSvwQj+EFjpHmBp73YUxN88G
	 J8d6lvKBdInqbIkKtPrXHf41EdEmJfJpqitRbQaL9Z1xEwqfVknLhGTt3Hy3UZIBC8VJQ
	 w8RS7iCM1nhjDd2UlOMHxcIIbTzPECQdyRS1kfwkcxnAFhV/smXjbxGYiVBSjKc9kX0Aw
	 t49kpQU2tCyAzTzOMoL7doBCdG9i77J+moNzQ4MzObc9BylVXScJbqJrlmw9CE9RsLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795871717;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UAqIYhvAdt8r9UagKhpI1oee0zFiHU8hjJACEwO5vWI=;
	b=ZV3AvCDhQyvUOgrHR9QJafNubGM6qqghrwZh0fo4XZeH0Bopo2/nEzS2W7J+shLCdz/g
	 ngbeP4NyJETRQMDsLpQO+7puegT4nQ91K1do60GRcAWzcD6ZT+1oyZXS/L0NsEJ5x7QfG
	 z0s78x5Nr+mprybHpR7hPhfzV1HpYWtCsVVu2xAW76YBKkzscTPqgF0wDVfK0fgBIymo5
	 nvka6R+s+lURz9GGmfKLA+7yQyMX/oOgBmU+f2wb2dx+fMGZfV4Dxi88C6vSGNwXv3nsI
	 dgZX8t+gIU5U7vw94kaHI6bD81YbxLa/BscQNEnlFP+oqsUv3xN4nqNHVLi0XE5cTZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgE968Bf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F303606A323
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgE968Bf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4031F000C1;
	Sat, 28 Nov 2026 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795871716;
	bh=UAqIYhvAdt8r9UagKhpI1oee0zFiHU8hjJACEwO5vWI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BgE968BfpGz58hRO/whzW+MHzTomGUIaC3rykWcZR5cKU757XoKbQ9agVXnPSydAo
	 yYCO0J74gBvvxVKEDvgzi23JdXKGc3VMQPCDSBJj3eYqKpiQv7i0VuPKqWiMqpN7PR
	 oQ78lLbpJ6kznWLSTUNoeU995hr3x4OUDGVk3emAjeaa3Z7oGdCm3p6KG8acHZIPr1
	 9PELjQ2IrVh1/AgrN/utI4TyPdjpLkQB3DNnlQqZ4FvSFPvS9eMW3wKGXyNP1b4GEJ
	 p4dyMnhQpIYRRFZse4CQQ+ZPme51LyN7KNqjUaYdnWHfM+TC7mdKYlvH813YVOcPB9
	 LABrrq2f8AxQA==
Message-ID: <sashiko-outbox-238719@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 00/11] RDMA/mlx5: Preparation for SD
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 13:15:15 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128-mlx5-sd-pr=
ep-v2-0-751878123711@nvidia.com
