Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148354;
	b=QmxjCbwSVTpWmzxdM0QTCPexTHqMUJ3pJJgZlxLCKUhprU0FRxs3fHHMUHIfTqRNXn9h
	 cJw3uGc0p/JwJLsbTKeCV1x4aFDIEhpUmUZySvhVQGpmVFaHY/p9PgrTGW46xom+8hDIk
	 29sptL6onvyzB0Q0ZRrjN3zzFZH8Mrip6uWPaL5Kb3GMd4XVviZeek3B149Udv2CIQZSQ
	 /L69k/uo8OtsY4HtxjMIW8b2ZV3LXLRkFYtCZ8TsdqHIwFdDPMejRkg3H2lsr9ygzpQpd
	 q0CSXDS+QIrrSUjShJYnlFNoPdSOPBkRUfbpya0MuLINDYfbE1gTvbiEnwJ26FvXtXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=nvGC0z4fP87Q3DNdC7jZAtQrTk9sOxwklIjxWNv7DB+FsIENx33CLDNTU2NNbUW6Xsee
	 T/qF4iticnRkgmtWvgZHgYVi6+0aeFhvXnetHi3Fus5PHzAfV7MaV+u6rr5Cjaq4XFcw7
	 P+durMGsL5HajgJoRvLbsIk53JnUdRQszQFcDlzAOgoy3bmIT36AwEcsQ7lwphViz9liG
	 mHfkn18LDuZy1Dzo7o0GtXW6qIE+qpZATR6T9z4E5dgPRLuHORkYvDqCXZaDsMjSkBbkF
	 x16f2KODdVDB4k4SR9zsH+4VfWjW2d6L36GsfMch61OORoxtreloPSagRwM/nBen0LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LP9W2yxO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B755B606A31C;
	Sun,  8 Nov 2026 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LP9W2yxO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26A01F0089F;
	Sun,  8 Nov 2026 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794148353;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LP9W2yxOa6pPb9hHHkWjSbMzRpX7dUppXa0DgOK73S3SS3UcwIwIqnzhslVmbEZOd
	 b01uyadKpH/rztQ5bNueyzPvOtAUtBYKFOXtSnSh6aZ4SpSgR7XBnp5votWcE82ZSE
	 nX7VWrn0omDdcb+qUliVb5NaZogqate61DI4FeeJUN0r/6IFECUVN/jA5wqF5Y3jsM
	 GjdOyxTJ/fBVqu/F3Lod1kdxT6tIkCxvZccSBfECxk3aXBa6c6ddlOdeXK+mEEbzXC
	 cGT1tfttyEsVKelMV7lqCfYOt05a2lAV92NCNtr5+VK4uTj/jGRkRqP7EabF6Eby3j
	 gFi1zpXh9xzLw==
From: netdev-bot+sinfo@kernel.org
To: =?utf-8?q?J=C3=A9r=C3=A9my?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Sabrina Dubroca <sd@queasysnail.net>, "David S. Miller" <davem@davemloft.net>,
 Boris Pismenny <borisp@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 
 Re: [PATCH ipsec v2 0/7] xfrm: fix ESP IV generation and ESN authentication
Date: Sun, 08 Nov 2026 14:32:32 +0000
Message-ID: <179414835216.488859.15220784201816281188@kernel.org>
In-Reply-To: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
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
