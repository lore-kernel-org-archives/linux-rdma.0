Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573989;
	b=W88oRV7Timn3VIgP6yrJJedkGdSJ93+S+yFZuz+bhf+kYJAFDMf6jmAYMA3dmgGUzHWK
	 SpDr4zl3vNxPJXV/5uEmmuX+FamQktxyUTcWN8oHUGQPUrtYxypgf9S2Fxt+PLAeyi7w7
	 0OpylSSgsKw4MaQ3OY9PJe3mQ8yEi3tcwr4IKT6L7vO8xVW0VHl3ry8bYJwdU+DWN8ccI
	 Yksrc0t3AV9xDOQWc/FSrZINa6vLCT6zIoWBiCq9cApncdoVK8Xs1jx93H1DtRgypCIg+
	 ut2hsj4/BpNB+cv2sDZE0rWE29EleKuEAPxyxS/iEq+UW1qavl/nMDqs/pBVeqSIV6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=js9BPM5BTXEqbQvq+DaKolUDKsbhvDGYOvQDZ+0m35+YJ57zOaujsp00vGnUQxwvoGXM
	 Z0HqjrCRULX5CfPj/XJoklCQHZ0NAFhf+slslhn3tqnwsPcq3LmHf2kLHEfwK6DRpmYMh
	 9+I83AP4noDL3va/HqSxg8qgQ32W+S00Pgibs+yiNCOGtoFhxOpZo7z4W0vJu9ZSUa2+s
	 xGZrUABYlVQsfKgFUcMIPrcb3x/+ZHqHvoeW+72LeQu+mEKKTs00GpmNEBly+1HgF4Jvm
	 p1En8IDfq4f4OnG5rAfuSnIZy7+JlfD87Qj0J9pD30j8FcfJ/NRUfYjhfPv8Tv+4h9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cM1xc3Sp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FF3606A321;
	Wed, 25 Nov 2026 02:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cM1xc3Sp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55521F000ED;
	Wed, 25 Nov 2026 02:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795573989;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM1xc3SpPk4qeF5Lil79/OyYyi56mtMG81SbPRxi/WvDzAUrs1cbHhNVuz9ervoDp
	 T3sK8a7CQwIRLp0AFt8sM8g2bp+On2CpYGEqxKjsGKMuq2q2owaNRU66VBbXYJdyVa
	 6FYiJ3+S+6oUv7LM3Ah/sWG3xDm+WNQcg0i4SDCRLEQ9LYV3nSM/HbDzag4+yTJI0p
	 dqKvLL4l2OiNO3QdgmyuMdGbilBwvLPhc9xAcIew1TnZuUED7kJMMp0+HEBcS4CW48
	 Mwq3VmPd4bAWb3WMrlfWDhQF6O1xEqu0mr2420RiSnns7p3WmYQTDXPJszuTD1fqld
	 Y6tPzNO8LP+EA==
From: netdev-bot+sinfo@kernel.org
To: mdshahid03@gmail.com
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx4: fix error propagation in mlx4_load_one()
Date: Wed, 25 Nov 2026 02:33:08 +0000
Message-ID: <179557398838.3294.6547590085823969218@kernel.org>
In-Reply-To: <20261125022913.205366-1-mdshahid03@gmail.com>
References: <20261125022913.205366-1-mdshahid03@gmail.com>
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
