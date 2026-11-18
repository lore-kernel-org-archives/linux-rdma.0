Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961206;
	b=uAzk7MXA355yRpXaxGUtLUIi3o73LNTL6OdiVl+dq00PqIphXr2UVdSGI9Zovw1dSW1N
	 XU/NBgzmzssBVap+dmfCeZxx1Ek/d7F7bPPKlPj/nppzrek2KzjPgHJJZjnOZkEua3QgI
	 mM+Fk25aPHVqkBP30GNMrij57IIRE8ksDQTNaHM68mOu99F5smkvGGOOSiIFgzHQ4erqf
	 XL/Imvn3nSVl3jJBtBCAVpVnERY4ymWubEE2NGb9wHA/8NjKCtFCDLZ3CFNkKzMLVKQDj
	 oRxOci7u9Tq/h/xZU7EbdWQob6MM2eH6pylbSGOovwYs446IPuCZb+jlKaFEKCdPOiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Yyp9htXtlrZQtTO2sEMjINZ4vkcpiCK5cmehF31nALA=;
	b=OZHUgedoC3Gm829019Kzwh3BwZn6X2CVGF1W4FeVbipJ1Hx8WmTq8tX5U89yO5lgyQiW
	 ph2CMbXDFmTvWmuI7qjKIbSHwBisy8fUIoG0ewNQGjGppjpHj1TTQ4zg5na2iu+PMgugF
	 ZPBJg7rNn1fXrG2Dl1Qz76R4O+UelepxwSlnV/kabOEiFr23XawoVlJZq4RJmfe3jnM9E
	 tywjymD2Qo1bRXVxj+/lDsDv2sDI3KSuCzQBPmGWPTd7D5WOUhqrSGo1S3v/JrD5TGxvZ
	 11tUiQ6iyzZOfn+Mtgj4olEAk+Vn+cI9z6V8yVrjXeJLLQC5TAqcjK/Wbo76O+UCy+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gD6LPNvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E1B606A336;
	Wed, 18 Nov 2026 00:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gD6LPNvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7356A1F000C7;
	Wed, 18 Nov 2026 00:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961206;
	bh=Yyp9htXtlrZQtTO2sEMjINZ4vkcpiCK5cmehF31nALA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gD6LPNvJzDtuapbIYq62L25qn99jxM43uMj4LswQHuurrmXL13DvjvtdFAiVJuEoi
	 vhSJm4WND28LdiVHyf65p8pwVuZ9MNzXyvfut4BiIiFPQvtSXk8GBYYQ1dOF4rj9pK
	 phwqxlOFzPvIUnicYEcX00rONHi/1fd6qq418zZ/TV0fostFd2CBSf3U8SRIJiqm3E
	 YKh8p8a84l0pu+COn00dSzTWM1iKv2M+vvIUOWExWVM2Qjgux3lyDC7V+2E0Qe3k1R
	 SER8ElDGc6cFvOWU0KKtF5dmDo/+GOxPXvxhASHBX221ll3zZsMB6tqJ8vRc8stFZa
	 G7c9Y7WQBJxPg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	leon@kernel.org,
	jgg@ziepe.ca,
	kaishen@linux.alibaba.com,
	Cheng Xu <chengyou@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Tue, 17 Nov 2026 19:19:53 -0500
Message-ID: <2026-11-17-1-daily-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117022839.23186-1-chengyou@linux.alibaba.com>
References: <20261117022839.23186-1-chengyou@linux.alibaba.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths.

Queued for 6.12 and 6.6, thanks.

6.1 has the same bug and is not covered. If you want it there, please send a
6.1.y backport.

-- 
Thanks,
Sasha
