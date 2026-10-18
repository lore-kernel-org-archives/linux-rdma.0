Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866C03DD532
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345881; cv=pass; b=sjeuR1ruCBzVGqDv53KIRojQ9+IdPfpsqYrfbAkqUMWr5NuF+k8edQkSfBelew2W5A6tnT0D41lPvnmLbbGjIDYHgcEhXZXvLVjsXALBzCqUyXecy/AphE5bk6HZf3a4jVYPs3wKl7HaKRXWu6a9bFHf6/A8jfHkHk7NUgrHZ8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345881; c=relaxed/simple;
	bh=HJ7jCLw2FdEx8ZSWU4kyWZlj4e9ArZJhEALqSqij3gI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OK8hhQ8I2o83+nb/wwuWCsr+YxJ/EUZMhsRec77kjmRZwN1/di2itCkkeNoZIYfaxy8APcN4ffEJgvpbr4JLVCFdudmzUcpvDkqc+G8LygqvoWKa2fmg+6zaS7Suv+BbMOGwrM8REeUUO5moz7HMNxyaQh3J7ZMpJ/3ayTYwYmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c1nYoBWr; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1nYoBWr"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3a808f09021so8631271fa.0
        for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 10:51:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792345878; cv=none;
        d=google.com; s=arc-20260327;
        b=FpbuADbu6E0AoCZgFapi3sOF0TEk5xp07wws9iC+NQzUOLiKVu9pxUrSfmVIXYlFIp
         bVrzxs5Jh2EB9O1CITkwkZLWhImswrkx907MCl2FoyIZTCSOB+pIIhicdjp421Z7gvQN
         lVkB+ZxEVqskiOBK9WzSHH6p0gk+Z7fuig8Q5FTYzuT0MLTIj9Yxzaji+01ausdyRQ9P
         fk6X/mNNDLqqLDPB/hfSBYeYEbQwZ4eZiXkmyxGHbmU60DA8lbkpPSCal17IT49T4mBn
         EuEMdcPs+4g3pWGx2XgGMjDZEH+kZFEVuYCQRGtyJqvB4a3c8SJgggTVCbvq1fa2Dkpj
         X+qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HJ7jCLw2FdEx8ZSWU4kyWZlj4e9ArZJhEALqSqij3gI=;
        fh=ExipO104Ga+KyNp5OJJmZ+S0IZ4KWUkuQcDR+veNFOc=;
        b=htMybngDfYaq/Cp4+hLP0iZ61eq3Cc6wYJEDcYLPu09cOKZ9Ehyvjz9241XhxaNVBI
         Q/leMqSa02KkxHJyieehIjAq27JLpeJi6YbC51UDKs0+QXp5R1PLLqTdP478h+yvj5x2
         GOYMhA0F5R0d46Vq2Wgabo3VSrc+qD1tIpiHvnOOBNvM+emLwPE4Oc+eqE0XAfBW0tR/
         5y7ipnROALyhb9qC7y2xxI1f+Hx4rmZXDBDp+V1QRfqt62YOZyF93kNBTGuAUP92Esi0
         ufixCBAVCDn26Bv2V9OjPWZ/h69rkB4c3SlwRQkJ/BlkqNIvnXU1HBVsnUB83vyzh7ac
         dMmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792345878; x=1792950678; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HJ7jCLw2FdEx8ZSWU4kyWZlj4e9ArZJhEALqSqij3gI=;
        b=c1nYoBWrKJY2+CLJeXf06moOwiYUv+ca63JF3b3TZtUuo989bYJ/pd73DCPBKtPObH
         /PYjIkEF7UcIZRV777lw3Rvi0eJd8UByvd4FpADF4CR4JfwFedGYRBGVoukXSycm0U+D
         w/8cydt58Aj5ps2S6ZPTotLqQL7QCM3v+ahDVquZvQg3yv5LCxOW6zES1LIhqYGaJyBV
         1XqhaWrLjUlRkjV5oPDo52TlnYktnN9R3qRfm9PZXy2EH0Jx3u8MqUDy1mL7NH+H4XCT
         pWcJxhal5fsN4zZxqY8UPIRc4VXHOIPCDWHUJVO6EwR29E0ckrdYJfHtwPaRxsIDMKc5
         XcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345878; x=1792950678;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HJ7jCLw2FdEx8ZSWU4kyWZlj4e9ArZJhEALqSqij3gI=;
        b=BGbUu833Oo1bt1G7uHTrw8wlNr3W4553BYYthxRvOEmtl3KG/iONGyM2NPU60zt4Vj
         P2v3mkMp6ItoR2abX4z+e25QCAuZHW0FrDNZ4Y6FZFpgU2pEIfPciY75MOLIfl1AwJk9
         3TYCjQRbTqj4ytfa3TCLwObvv/id3kbt+5XBIHQUJmnPDTywNXZMUDwwuRQro+JMjBmg
         e9q8f+DXTq60dnaFr27Tf7JE3GRYI4AaFQ+pgxI+JbyrntDAZEljGL/5BgSk42YpBG7n
         K+gBZ+44mdTI4sGFTR42lFssk2+f/liUzjL5xJx5axkQ7lUErIplZkETFPmgI2vDV6OM
         Kd0w==
X-Forwarded-Encrypted: i=1; AKwUvBxeHJPG4onsUxDztgckRHXNJ95r6HESOcCP4rk33fs5qbYRuRP+BaFucyizxvr7kf+kHflKOSxEAr3g@vger.kernel.org
X-Gm-Message-State: AFq9FYJA87ev6P8blq+aVL15zXfjN3rlUesdwxYIw5kdKgP9sx9r1PQg
	5RJPJkAYo9hX/UroAqc94cd2J2yfOwt+D+1HFSuXg+9/dpsI0QSXmdA0P+Y9IvF+W1ykp0VciFQ
	/9PcCH7aDu6mL6resjkc0iPqK96PzzDs=
X-Gm-Gg: AYBFou111ER6BtwuLT1EYKzLxxppN0i8rNYKBAQ/LwMPG+Y5+cFkxhJ/fpJivfgCruR
	AeztL2PohKArZ6VGAAZMu4n80Y9WdXkYFXkNAzhQXWTUhaNds6e3hPtSqawahNH2VVy1/GdXhZB
	312O893p4CiKYQKA445pn62lPC0Gbtv52SJ8eVFXboFiKhvd062xz0K+sC/a6MXKTWzNIlpstTv
	y+EQ2nrBirUGQNvEzoUDt/vhATqR05GqJdz2KfuyUfq2jS6YDVFfrk6WrGMDJDI1MCPPlezDIyw
	l+rnGshzsiyqhSKNDiZMqF2ul0b/rcN3WduFvTcTakD1ZtB31OlMpkE=
X-Received: by 2002:a05:651c:a20d:20b0:3ab:2517:6a6e with SMTP id
 38308e7fff4ca-3ab292d34a9mr8826631fa.25.1792345878330; Sun, 18 Oct 2026
 10:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016045849.813696-6-oss.patchbox@gmail.com> <20261018125520.GE64621@unreal>
In-Reply-To: <20261018125520.GE64621@unreal>
From: Yuho Choi <oss.patchbox@gmail.com>
Date: Sun, 18 Oct 2026 13:51:05 -0400
X-Gm-Features: AclHuK9VhtPON4CZXI1t-EARaMx8fGG5lLL9rRYVGDPs8VyZqR0bY4J0-Y_FAtc
Message-ID: <CAGG=RgAjY-TFDq4+rEspF5R_dTC=6jjHfS3cRsG39fi_LKVN0Q@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/4] net/mlx5: Don't free CQs whose destroy failed
To: Leon Romanovsky <leon@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ariel Levkovich <lariel@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Alex Vesker <valex@nvidia.com>, 
	Yevgeny Kliteynik <kliteyn@nvidia.com>, Itamar Gozlan <igozlan@nvidia.com>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 18 Oct 2026 at 08:55, Leon Romanovsky <leon@kernel.org> wrote:
> Please drop this series. The flow is impossible in current HW implementation.

Thanks for the explanation, Leon. I'll drop it.

Thanks,
Yuho
