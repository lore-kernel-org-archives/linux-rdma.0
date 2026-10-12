Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA13CB8F1;
	Mon, 12 Oct 2026 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800678; cv=none; b=Y5ZGjS9f45njREqq2+nsMzzmWsWopGa/6amLDE7elbpnUKxEwaaLnRW0+sNrpYcO6zPhtlSbUjh6+55ZVidAIQp1cjPqCWv5xXjQwXqdrCMJRn/WQW6cnMhcSJ+CFGLOkGMAjXzaXcQrgot8R6wnNQczNas1t76S3zZDCqAsrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800678; c=relaxed/simple;
	bh=Frc+ADQTxRwKDWaoqMQMlUJQ/gCXB8qyIs31/48aD70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QMucuOR2MMp9xGZZzhcXHGPV0U/FxRjQ0fiE+BbFxvy86IDoayYpvv9m2JNco5eICOw5MFadMzJAgc74Z/yMBk8q58yqGrGNdo/fJGMVVoCiq9e+/bQsfLuf68RbJ9mUDKoT1UHsMnTJaUcsjYlG0fee2AN0+OXF7KkAh44VMYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSBFVxer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSBFVxer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9106D1F0089C;
	Mon, 12 Oct 2026 10:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800669;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSBFVxer3CLhhERLbqG92AhzyKE2zeFTYQ94NorWbPGdMvx/0WXKMZD9lNpjRsCkS
	 iCjlY7YTwiIA+xX5g9jXGWDLZl9sEYaVaLz6F6fZWRHbm3CrZEagoZZIAbFiIXd2bc
	 GsbnzMrNX55Xx8g76hHW4LCuQ3Pn1pZc923hfhsNq3v97VjvdvrYBd68tzwDDK+GeI
	 f2Gm4x5Y/WeJtsuYvttVJxblzxcrPBQ8U8OYtbvAhg4+hukE8rmBQ0ltlRhfsmckUy
	 5HOuGuGUzSQTGRez2h/z7NoBI1HK4wwpZT+9JHg4jiQVCVf50fOh6/fsH+9NkxKEiS
	 6rQelr0goOaNQ==
From: netdev-bot+sinfo@kernel.org
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, Hamdan Agbariya <hamdani@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net v2 0/2] net/mlx5: HWS, fix modify header pattern compare
Date: Mon, 12 Oct 2026 10:24:28 +0000
Message-ID: <179180066813.2527009.4759083074035124601@kernel.org>
In-Reply-To: <20261012101937.1335231-1-acassen@corp.free.fr>
References: <20261012101937.1335231-1-acassen@corp.free.fr>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

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
