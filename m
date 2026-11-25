Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795580821;
	b=nI15a7arSmGYZMJaYpHb+GaUkfzHTGi0EUKX3Osx8etpC0RApiSaVKuyuDncZ1wW+0XC
	 65146KTQL/smB/HDDujbFFRUx9P8LtcYWGQBkDjqjrXovehLiXsaxP76lytFvD2+scXOi
	 uj458czovSBVfPKBsViOXbrLmb95PGxldYSiWf29g2uGVxa4I0v+p6rVFtk3YCETDWRDG
	 EiR0vKZc4IkG4tXtWaVcTKs2K89vFGx4wDkxk34Pv+G8Wfnw+d2moXj4HHQcaaflgBL94
	 5FGEzwxVwfIjsHruzvES5w3dPTyRpGpwQFM7JG0QLfAeLpBdKoBAh/DOKHuB27rIk8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795580821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=e78M0hAWs4AXyy0FAF89iDFDRgCJxEzujt5ZqNraYHBqa4gr6v5erHIWRnV+uf3WhEK8
	 mRQbY491M036b5eFJlw97HFQqDPFO0bIsIZtjY0T4mMYFWSjTiyzPaFoVJq4MoBOcs0Ax
	 fvn6ra23klTabQnJV0I93eWWLr9/ETm54yGWBh6xal0WVbO5dCTrSnZOClKQSxgew+599
	 GZo042voRTpr4eyCHbRhzGO/EYj585oOjID8G9PHUn6ehluReHaeeU1nVTp/Z3hRsh9Wl
	 U2TggRhi9tA3yK4o4Z8FohT2xOiPhJ8wcWDcqs2BFkJCzKC/qe3q7E4/qjUADHLKyyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cg8GVxw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33844606A31E;
	Wed, 25 Nov 2026 04:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cg8GVxw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BCA1F000C4;
	Wed, 25 Nov 2026 04:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795580820;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cg8GVxw0vXNERVu5H03nZ5SGWGXUfS+8Z8Tgwor0XpZzirEBmWGSa2MHp1/HkVrw0
	 1ZshAqoOUDR/k7wnr0lIZfWkFQyZ/2j8/bqXVvGnjNRRQbP3Sbcde9L2J7VkPRZZis
	 LuElyCdErt0/eSWkdpikYfX8wuGSxOimv2+rQWt5NzOGiPlPSCSOK9q07og5w45GHS
	 FOi3uIQQ8J+sA2LPuMCKSrnZCs1MVM9P0Wx5R59Hdrl5dEdq6F+tpMUJP6NpBzmDow
	 kl9ezb28yuxdPj2N5odJ3gBJhkbIbCg51gVdI/4ZsVlL/K3BNSjvnD8BCMaquWZg65
	 8dLpUdlhU3dbQ==
From: netdev-bot+sinfo@kernel.org
To: Ziyu Zhang <ziyuzhang201@gmail.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, roid@nvidia.com,
 baijiaju1990@gmail.com
Subject: 
 Re: [PATCH net] net/mlx5e: Fix deadlock when parsing flow actions fails
Date: Wed, 25 Nov 2026 04:26:59 +0000
Message-ID: <179558081909.3294.6309023646562728639@kernel.org>
In-Reply-To: <20261125042323.88050-1-ziyuzhang201@gmail.com>
References: <20261125042323.88050-1-ziyuzhang201@gmail.com>
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
