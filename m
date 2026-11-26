Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795682917;
	b=YNJKxa9jmc2Y2jEncp2lbp5Ff6Osez6Pz5UzGyICqoh4lNtDgTMYMh//eZT6i7MHJmvq
	 2Y5TJCzeEg1Ih77VWnH2HKyzuSqAQ/IJcPGpDdfEyS/iF2G0g9gUyiDVmeqSevMjtcHmE
	 hkhtFoVI2YfmC07/NI5XV1G8lEtThlbcYrc+JFajH1G1yuBe9T0WaY9+2Z2ASYnQH6vhL
	 YwhlIee7bvuuYrIQrC/d6MaEuefKUTj7A7ziOSlYPuw+5kbZXg/ukZMHgHictieaHN1LW
	 qhWEoHnY7uZCRIuWj6ERwaoQ3Tgof9kNtaNqlSR3prHiYwFnTm3jZkRl1vGjxFNBG6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795682917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Uwqp7Bz8a5D3/B2xkBHbhP2Bh4hQYQFs0RxyAqY1Gn8=;
	b=gF9H2f66+LRFbZfXpbkAiZPGbBkOw0OVHBKG6adX1uBFT39iaWjw9tVo5FfmU7yvZaei
	 E9NdPUwvor/vlG2SlNyT5fHLoZmkS1N2NoglteTHSUFBEbI5wVE7PXk1yyw6GHi97BWUW
	 xTZj9JgjChYMt/YVcFnAGD6GDT6hFDYh18oWE73wWHisFaYt98wBj07QmttFE2J4+zRTs
	 z3P8ZQ3yav2Z80CUG630M/1Dz8dgSO1sJac9Jw7y6NzbOQc4nfNPOe2w461v8WVJ5/rL7
	 3HfuslJzGCo85UmdBAwl+Yx2+tuLxemT10DO1Vn3E7wVVVR1ql+A0M4UNv1/J1rGVAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxV+nw9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BCB606A31C;
	Thu, 26 Nov 2026 08:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxV+nw9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B381D1F000E6;
	Thu, 26 Nov 2026 08:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795682916;
	bh=Uwqp7Bz8a5D3/B2xkBHbhP2Bh4hQYQFs0RxyAqY1Gn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxV+nw9mt4XB7ElalLSumbH5DmwrvTX6gf/y46Or9h8jTLwnH4ugXOUKq5VZg1ju+
	 g1pnvNCqPlxWAEnRO5Cc0qM28OljWefIFnSOtAvsOZ8jg06KXnjI7YCLm9zWa+5TAU
	 od6PCFwC6tbbhEmmcOTu5zjvgpvEtrWH3XNvyTfgLx7vlnQqs+U2kZe67c6S/ufpk4
	 /q9yLW8QndWw/a/sIM0DRcczx6lIZFzFATVfSae1VkfNgdhTzo5rdbemJ0Ay53kYD6
	 bhAVFxQ//U2S4GiDY/FTI3ev6MAB8HuGQ/0QbPrvVlaNUnwbugiaKxf7uVMxTI5KFU
	 IYzTvVDBYEXSA==
From: netdev-bot+sinfo@kernel.org
To: Ziyu Zhang <ziyuzhang201@gmail.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, roid@nvidia.com,
 baijiaju1990@gmail.com
Subject: 
 Re: [PATCH net v2] net/mlx5e: Fix deadlock when parsing flow actions fails
Date: Thu, 26 Nov 2026 08:48:35 +0000
Message-ID: <179568291524.3294.13641799270688860582@kernel.org>
In-Reply-To: <20261126084216.26436-1-ziyuzhang201@gmail.com>
References: <20261126084216.26436-1-ziyuzhang201@gmail.com>
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
