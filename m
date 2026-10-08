Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AA24349B4;
	Thu,  8 Oct 2026 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791492323; cv=none; b=V3AckUM4LG5+QNLcTvzZcBO63OhtwAy6WKQ1m9kRZ3sgzNHQB+wd/I4D1eo4M7VgFMbceSh2bacM1hnfHGUubHmsItG0uTOO4AGuCmpZcxrtPqtcmQw5QJ7QjOyU1tST/JT+QrA/q8kfP1FS7HnaXV+/rMYtdIt1Y+fsI8JeTI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791492323; c=relaxed/simple;
	bh=T80pmibn7aSi6N9hDzJvCBDoLXDCN4HDH9fhrQVJ60g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QLbEUR8qxJRP51tSwrqJCLaz5YxRrHFbJPTH80ffLNDUK9ggm6qprz5hbL5lc3coLsJ6Dwn5U9004uhLTH57TU3cQDQb2MDtByIJJyIDb9ZmqoU/ofCeEDdTaIn11iNzt5waStw0Jhi8BPlnEv1IDuok0bCyZeNeDxUMHxQYWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvExe/nI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvExe/nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C8C1F000FF;
	Thu,  8 Oct 2026 20:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791492321;
	bh=ZCAoLYZlSrLohEk+mBrzJi43HvKosm2TxiN/tMhp9/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvExe/nIGjPLEZEmBUtyMGhrpnAg3NAlJRuazkG4sSf1Z9w6NiwqJKhbTnTq20Y5s
	 U7dqDQRKelJKqBKd3ptZ+QwmkgYAeBBlWyXCFG7Rz+w4iw1/wSvAX4Jx2kEcGBstQ5
	 NLbdsmDfdtqExwxEuwjp2Vk88Pxa75DL9NqE59SSUWPwJaOtUXr14qc1mRJC2DSkhD
	 R0uLZjoJW1A0boDlmizWYLAGvUWejk+uHSSK6r7uJDZM4KzWuxcypUL8FhP2rJKb6E
	 sAHZQt0hJevEK+/pxbsstq6ZHW6v3YMWYUG5mhTgD/qMKaBwkgoHKqi1wwswQxGFVN
	 NvKuPBM2nsqvQ==
From: netdev-bot+sinfo@kernel.org
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net 0/2] net/mlx5: HWS, fix pool creation races
Date: Thu, 08 Oct 2026 20:45:20 +0000
Message-ID: <179149232042.2527009.3758196040830567037@kernel.org>
In-Reply-To: <20261008204230.3222198-1-acassen@corp.free.fr>
References: <20261008204230.3222198-1-acassen@corp.free.fr>
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

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
