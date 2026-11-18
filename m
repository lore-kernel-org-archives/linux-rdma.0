Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961370;
	b=Sqas0gzT1tMP9GIybHO+85fzpAoPX2+eSsGikyhQE+sQWzu3zejLo6cV9lsu/mk8CGQb
	 ENrv27SxjC+8e7f84nz25SRYcz5WSeQrZyzOr9rh83k8B/eAqWWPoTigT14yDhEtB7udi
	 iddCUmHKNZW+cGa73+h3s/Huizo42O1MsoBM7tJkD1Z3IhKemKMRM1Eu2REdqG5fIWEJb
	 5m12fWjk0Shmv1mhIOseYBPwV4kDxA3jBRyzL7iulrZoMPf3NIFJGpcae+AhHy8zs8YHH
	 xBtdbh0clbub9quyi2h3AzvVXc2NOvNiNB/rPTQtoBj2y2VMHajJfsmPQT7+z0aE7/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Yyp9htXtlrZQtTO2sEMjINZ4vkcpiCK5cmehF31nALA=;
	b=UqRvEVHRGw4zO2cztHTomYIVj0tfGmELL4uQC0yvxZnWXvJTBs8xbikMMVBjWIyyHCqr
	 ZlIXvT5ku87L2x40u9O9SaIY9DGEcLmhVXz5l0yLv+9R26bowB05I2puqb2iw3GPFbzVN
	 eHxJeW7rEWV8GA6+55zrU17cqP0Z0DXe8Kv/PDtr2QXviOX3/6j0mskikWoCVgU+MPGLO
	 vb1SfsLH8srnmzL1kwSDFolW0RyAwWSHZ5yVF7oEOLG7FqF1LMSfNBMJSU54iM0tbwAkz
	 25sClfTt/kY3L5BubUA3RMnnijFiznRR41cBE2lT0OIrBZqVkg80yUI6HwYMHmv07IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cqBKZAkM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC9606A31C;
	Wed, 18 Nov 2026 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cqBKZAkM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73B81F000C4;
	Wed, 18 Nov 2026 00:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961370;
	bh=Yyp9htXtlrZQtTO2sEMjINZ4vkcpiCK5cmehF31nALA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqBKZAkM4ZnJNd67kl1NTTRyMQr44qicC5vzQ+/sWcidrWU2DfEM8cgRRTjuWBEvh
	 +iBIgsnCkWo74WOBoEfBbzAWNy1hzdlvyTDF1XPHDg4wTzwX8KO5xe8gtrj4Q14CzX
	 DtnwACOnI8S8xko3HcInWVZwYmjikuKOTpDd2+blISTHsLErgMp3dYagVrhnhW09nd
	 biDRcn7TqfCv3Utittx5ayxVRDlxab6agY1KwQHS/y3bAUUWWLauOf/vttA3RJ1vR6
	 8ZgYzqDIt9nGVGUm7g2n1xQ1GzCi9E7/U1K7N/Tgx2c3B3fYW9R7rxPG/C0O38KIB/
	 wp5GDc6Up8low==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	leon@kernel.org,
	jgg@ziepe.ca,
	kaishen@linux.alibaba.com,
	Cheng Xu <chengyou@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Tue, 17 Nov 2026 19:22:48 -0500
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
Message-ID: <20261118002248.wu4HjsFdDot26oHEK0Mwbq8yEcqH9lsR8E2s7HSq8Hc@z>

> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths.

Queued for 6.12 and 6.6, thanks.

6.1 has the same bug and is not covered. If you want it there, please send a
6.1.y backport.

-- 
Thanks,
Sasha
