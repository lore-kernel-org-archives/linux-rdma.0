Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73154221DB6;
	Tue,  2 Jun 2026 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434242; cv=none; b=IQQYCOnKCUXcAtPHqyiHbXOO6Xpt7FzuZQH0eoYUm73uCepLvjjSzKqp3rHjsE4NyOkM/m/uPJandfHt80cuWKrpqsr8TEmjCKzgpBhcdqXu8HTJIh03P0ONcMBFRkwKbem9qUdPfxcrK2sL5iKwz4HA8mz0IbNmRDFozKtcoM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434242; c=relaxed/simple;
	bh=xcBwUqenQnYMfSBWCxuZu0/kzGfDaLbnZtYKX98y8zk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZA8UVlY/E8lTkdGxRJCpYK8mAAH+D5yAjUo4iiGtHtKn/wvHMLhLrZH6ELALsNjvMUxxELhZBreMj9NaSxuJdZKKHEL+OlReFSP2+qpBYkso/hyWwmafiIipcuctagUqKRSYF6T04c6sU69KhvityHcMN494L0OIISkGj3tvgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URBRQO8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URBRQO8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544E51F00893;
	Tue,  2 Jun 2026 21:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780434241;
	bh=szrWBKhghiac2i2mueK/YjJu1FK82B5hSpdAwSlajBM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=URBRQO8EBqqlHB/KHgDkXH5tmEouzPHMlK1s0wDdHL+bZ3gBuynAz+fso8Al8Jrj/
	 9JQDn+55i4u1Z3eVPrHvnULBNeLDirvQ25E3iDMU+y6qmdfmrr8C8T+UcDLIr+mCO+
	 0FEni1K10C+s+N+NJYUKd9Kxqk6Sp5Lvgkfwf/qPbSA+Jp9Kw9qancwOhtlaamVQDz
	 5ldsm636C9d6gkqy4Dnp/z7VGOIK09alUM8om2KAkTVIbDQTL9pwIi5SuexN4HFTki
	 s96CuKvrux8DwF2d4l9PQDYp/KYZM3zd1Aatv3mJziyjCBU9o2dg6w02HwSlkI5Ckx
	 a4nUS34yeqC0g==
Date: Tue, 2 Jun 2026 14:03:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>, Dust Li
 <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Wenjia
 Zhang <wenjia@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu
 <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, oliver.yang@linux.alibaba.com, pasic@linux.ibm.com
Subject: Re: [PATCH net-next 0/2] net/smc: transition to RDMA core CQ
 pooling
Message-ID: <20260602140359.3b97d180@kernel.org>
In-Reply-To: <20260528084819.6059-1-alibuda@linux.alibaba.com>
References: <20260528084819.6059-1-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 May 2026 16:48:17 +0800 D. Wythe wrote:
> This series transitions SMC-R completion handling to RDMA core CQ pooling
> via the ib_cqe API. The new completion model improves scalability by
> allowing per-link completion processing across multiple cores and enables
> DIM-based interrupt moderation.
> 
> As a side effect, the increased concurrency can amplify contention for TX
> slots on the shared wait queue. Patch 2 addresses this by switching TX slot
> allocation from non-exclusive wait_event() to prepare_to_wait_exclusive(),
> which avoids thundering-herd wakeups under contention.
> 
> Patch 1 replaces the global per-device CQ and manual tasklet polling model
> with RDMA core CQ pooling.
> Patch 2 reduces TX slot contention by using exclusive wait queue entries
> during allocation.

Sashiko reports a couple of issues on patch 1:
https://sashiko.dev/#/patchset/20260528084819.6059-2-alibuda@linux.alibaba.com
Are these legit?

Either way - would be good to get some reviews here from (ohter) SMC
maintainers.
