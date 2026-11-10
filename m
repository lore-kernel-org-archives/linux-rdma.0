Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306155;
	b=08k1BApLTCez73KG0Ldbw/4pG1S8/XSsRHezZZs6lC6uVQY+jX59QQeFVBk+ov3NVTb2
	 XMGLttiJTiYDGq/dtbH39N3wTbkyXaMCfkVoEkBLHTQeeSMH3qunpV7MYZJWmWVPLZ0oW
	 LAG+71xtvN/07bt3wZnc9G1fYCk9WnJouR+YKBaIZ2YTaB3IBNZp0gzd0ZI8SKqoGeXcD
	 81l1u24eedAGJczFd9iOKO/lSoJkR0IGru2FWyq4Qfh690yr63N46N4RE3sbSghOeX68N
	 1DC72LjwGyTfURACgbOfS/gABxeCJL+V/PejeRwq2aJEACk2u+hGKL8E5rWd6Ttb/TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=EPADnBjwBCfjzhl4W+yj5D/rkulyeFrz+JboDinCFGUEMQ30VOchgydqrvVOi4otfOgv
	 crIIQjjcb0vULf08bPZcNuqCUABYjNzt/9XnQiztXH27Y75J//gKGYXG0nTVm2H38h4TB
	 G4w1pEQuHzAel43Tk7ypEt8pKy/GV7OOsh1PQv5CJPRapdijz1bVDMza3doYGatVbiwWs
	 6aNKu8oY2VdJKdpjisfUiPomnBNYAniXCn68iBVOYKEhgojCCItHSAUgl8SzN+Bd7DZ4z
	 dJaIrRiwKT4vFAWK2cWvL+9aUVKVRXhIBMGMl4DER1nIYV11Bmzzb00BnFDSeD67UrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="b/gp5SIr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FF060710E1;
	Tue, 10 Nov 2026 10:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b/gp5SIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A261F0089F;
	Tue, 10 Nov 2026 10:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794306154;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/gp5SIrSHk4En+pltFbP5PRS6dkT4J2ZFB7VQ2IDO/QUmDhb9aGFtxnnPIQjT0V6
	 gdYoW1kS+aKG67uRt3iei1rYk/0ONbTlEGkarwYH3H34F6WDqb1QDAMPVft61tIVTz
	 cmlTNUQhivRiIKUTirDybO4k2aUDdu7tR9Lxq2WHtsWqccfbkfJ4YpgpJkdIdGPpXo
	 CQoA851eIO8u2MbfW3uty+se8fm7YKyCfRwJL9S1lyCd6RSSlThaoZ5XtwMcYOWDyQ
	 PyPsL/htSlPrMifQ66EdCroc5KWSiCNqWndDohxnicUL38yOAAWvs8otzbkEnWLymR
	 UEJQVRB3JPQIw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Boris Pismenny <borisp@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Simon Horman <horms@kernel.org>, William Tu <witu@nvidia.com>,
 Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: Re: [PATCH net RESEND] net/mlx5e: kTLS, Fix missing error unwind when
 enabling RX offload
Date: Tue, 10 Nov 2026 10:22:33 +0000
Message-ID: <179430615346.488859.14108137500474713442@kernel.org>
In-Reply-To: <20261110101709.2589088-1-tariqt@nvidia.com>
References: <20261110101709.2589088-1-tariqt@nvidia.com>
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
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
