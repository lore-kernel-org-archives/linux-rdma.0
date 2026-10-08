Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527112F5A2D;
	Thu,  8 Oct 2026 08:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448790; cv=none; b=rMWyS8vwyun25DPv4lwLf1Vj7QYZUc2aa3Xvp/AYatCA8DZb8U6mtr5k8F/JSG28OLx9BbVm54JSxTGCbP6mSGkqZQeBBi8n1QRXWHlFYtnKMRdj+RFbI2y17a8gfDOyBEZLg8FojRQuTrhPNzJyf9SZ8aur0Zm+6HJvey8apjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448790; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rn/lVLg2PywFppxmDRReRGIOLn+I0TgZOXBSz3SIPyKn4nG8c5Fk3UDO5u76aYecEeQyuApKMJylryQxy1BKfvejsnzxe9cB4KWHIluAio3iDUcx+AHJb0Dj+e6jE+Ay6riKWng02D7f0M+iVUhfE7QD20/VJPS4vNH+BPDpD6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hs5CMpEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hs5CMpEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063C21F000FF;
	Thu,  8 Oct 2026 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791448788;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hs5CMpElV2j2BanP5A8iPCjBYTDP/YRz1qHHZUj2YxhDGIUB+LJpMjuUOh2lHSanM
	 29MWUfU0+KxSI6UMOD4q+SfMPi3B9NPeL6QYqxIIW5emnKf6xRlWN+AjRKZt5RHMv2
	 kegVtymTCUTh7b6XZYJXSnFrnMG8F6gMvFAT9PgBLxqeBMMbCFKJAuTTey/rV+QQ9K
	 kp6u4vYSyM3S4F8qcdwesDTdlSkNbh3P3I29J2mqg+q5xdP5J6Ei1LRpHb3kz4aO94
	 lJRQ54rnZu1QIr6kvLcXq7lO/HRAz3z2lKvEwW7Ls0kOlEI2DfLqgS1zx6pmBqkYHH
	 WTsKCZP9IyE8w==
From: netdev-bot+sinfo@kernel.org
To: Sahil Chandna <sahilchandna@linux.microsoft.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add support to process throttled EQEs
Date: Thu, 08 Oct 2026 08:39:47 +0000
Message-ID: <179144878753.2527009.17917144229253595701@kernel.org>
In-Reply-To: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
References: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
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
