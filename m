Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793004628;
	b=kO9eR/MFOFoWRXUVExmfbQLrlefD6yxtNGd4nmtQnSkNISy0VO5wS3hm52i9pzwmYiPJ
	 QzxE8C4ausn8TnzjxXulD2G8pHgLO4U4u4Wyxx3e1BjYG6aRai27P1Ikkh9YtHyKOX0Lv
	 B98IqzEklpiVju+CbHnCTllooh3z9KMBqiPqeWE/WOmaO4D6giiOJgobjrwgf8zEAIh6D
	 IN0NfK0k2SU/0r3uJsMNWu4jXE2n2N0NAg5jd7PFbOZrczI6z76+kLT37z/eUBs5MNfI1
	 HtIxdi9LUyjqnIi0jvp4CIvxINF19h2ft9qVAmLvgvAJpt9c0f7flwwGafSAlZADIkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=db1gn0PX5W60ryENuYSZgm3FO/zmb427K4oeiteMsEQK+IQKlTHnWUaAh2XWUkR2pewT
	 uoiMEIiuYy9H9ARAnCO/VQnCPj+5+QheUbP48kgIPAWsNqq4cAqqgfs6048w2D5nLCyh1
	 Y4Cp4gEPfrCtuVEZoIcjMElCpxVKdKJk4yiexyNYErXDOh+i6x1VnUjswN8OsP6Tc6WL7
	 dIeEFMNT+YdjJz60mCPDUSc0aKn9qjGaIyGXJj9ont8juWg6JpMkIsXEO5jL42GIhmbNl
	 3lrC6XHudaOHinGMyt6fkaL4//RnWap/bOlum9LdrK0ddgLBpbU7/7dVyS/A5fZgc6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E1jm0Cc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B74606A31A;
	Mon, 26 Oct 2026 08:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E1jm0Cc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CCB1F01825;
	Mon, 26 Oct 2026 08:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793004627;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1jm0Cc25sYmSkB9DibXJ/s350fBwygID0LtwH1PlTxiuiX0+NS+J8ysVRodHS3oj
	 /YdXu/XAb361q+/OivW/0Ii31cBDExdH+fFDV7deVK9OCpRKx3KBvpAJmNPYPe+DI6
	 j9BTAaaZhOPOs45MMXKncGimzgAMCkmkGoAXcGbCEl7olxUjUaniHJdyuCk0IHF1zo
	 xPd5I+6giTyxBcxFO7OjkhDqwgs8sGr3mamcTlizofj0ecUwv9TdgcLsL//y0WJeFG
	 0H6n6O+uFjII0DwrKa0gUm+Ezi72TOFO073aYeXUyZl1AwG6u2aBjO6DWA7WhPoOaF
	 FePbV+AWswPnA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>
Subject: 
 Re: [PATCH net] net/mlx5: Only set num_doorbells on a fully initialized SF
Date: Mon, 26 Oct 2026 08:50:26 +0000
Message-ID: <179300462647.3327.12553481287889944518@kernel.org>
In-Reply-To: <20261026084503.4122732-1-tariqt@nvidia.com>
References: <20261026084503.4122732-1-tariqt@nvidia.com>
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
