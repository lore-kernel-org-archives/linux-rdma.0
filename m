Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795631268;
	b=EaEyw0d59zmxV7hlXJCzTNm0SHZnJezoVk/cIOljRwOptNy4KweUu0+7hp5+0ewbnCUI
	 +7twUTwpNIIUZG3RZkinatZdLxY/50DSjqFceglKj1Tw8tfHzlexT1mBvs3HddQuw90VB
	 kSojQvX4QJiktJrsuN5QncBYsHmnBb2lsT6qU940/wIAHnFl5J0D53F2xDgUuNPh8ZKRk
	 Qs71TkgA43Mk39d0c0mCWnIiVQCrdqfKmhjXVxw8E+RCGjtN9zDmYJiye5zL0CbukEuHM
	 wyHbn7885d0+XJSCbUZzQATwnMUXLRSjBwpMjHOPme9xqgI/lt7fHtRlarZaWm5/eHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795631268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=lSqpudJJLV4OcxmlgHr2zzQeGtD8eworA+l7bIBUbAPvnuB6pWrl9TjE3paIAHs92Brj
	 wAQB/XKdOb0qEv+5iTn1SJJrn1cdL7t5jkPAnraDsgN78C1R37QrhXzFM0PlbSbxqi8Yw
	 BAUpOsrWKIJjLg89AcRy4bpCUknjnhsEbS6Ysgw0ijOPI/KWYSatO8wUNzUUjnwTdJbd/
	 ofeGQoxxpyDR7sHVP88HWrFGEHSksgeZSNm/M6pH00emvbfVI48IFRw9XDR0UeYt466X1
	 V83NlSZ78sL66KNwNC9behRbj8IrMadli/Vbb0ZoFVkqUBbj74vBLMusyETXVUuabcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+fSYpZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2110606A31E;
	Wed, 25 Nov 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+fSYpZZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2AE1F000C4;
	Wed, 25 Nov 2026 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795631268;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+fSYpZZBs/eeVRJDFwqCsihZnmTAGcR6or/lmdqDck1ZuhKBrmpQIHjBNUzFEsMU
	 XTevw5upN/bgiCwSQmHhnt9NcgvEsBi5NMso3LCQTKIGzUX/SP67f9xucc8HobG29O
	 PWSwNXJMKlilcDdLr9BMPmYTSxgVRkStwWj+Wht2xK3u3zzGYGDJM8+w6i/88I4rI8
	 jgdphiEAzMaxRiAUlUQULqfEePI7x915jI04ggeA0IOle2dY3eXikZJFLKxBW+ZLI9
	 GgvPX7Ky1wND6eaye0czrkCH7Dzh6N3CZ8HdhGSFHPc2xOKkG/xYK4w5+j8Krk+vB2
	 TE2Kuxx3E6xUg==
From: netdev-bot+sinfo@kernel.org
To: Etienne AUJAMES <eaujames@ddn.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, Feng Liu <feliu@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>,
 COURRIER Guillaume <guillaume.courrier@cea.fr>
Subject: 
 Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in rx path
Date: Wed, 25 Nov 2026 18:27:47 +0000
Message-ID: <179563126757.3294.7703649268548084983@kernel.org>
In-Reply-To: <awcn1-LpcFgzRKgq@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
