Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73443AA4E0;
	Fri, 14 Aug 2026 17:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786728256; cv=none; b=IRxM2GcFjmxImbfbQKVKRayQjPY8MEcB55eHOGAmvhhhL/JkCVzRCyJoRCYNCzQa8WDnVpI3xaZednk6iOc4dCWRjLfa8GaLOZsW9PKZiZHYMJaoR1hYWc6W73s9TVLmMVMJ8IrNAJ9NvzDGZU6AXRRdtpTI4MOEkch11l6qiJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786728256; c=relaxed/simple;
	bh=9spt2GuP2cJm2zqWXMCT7IKRw0iKN37Yyrs03jqgU2A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhG5RwgHNTaZplFYQ6O1CPU4QuuUHDrbZmGgb5STU76EOXmH1OU7KEoa5sTwXSxwZ9DQdr2M6NjJ1YILIc6cU+FyDp6KnbCiedxZd2R1qrbVNqLcus5ghT9vgCoq5nJ5WJptWjV5sCByN6iKqUXljKD40P0/LfVL9AiQqrdie1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jneldP2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jneldP2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7B11F000E9;
	Fri, 14 Aug 2026 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786728255;
	bh=9spt2GuP2cJm2zqWXMCT7IKRw0iKN37Yyrs03jqgU2A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jneldP2gvUOy2jFK3ePfz+OK8WCSTLg+4tBKGeKU7fDJdpn+e6zkYqm4FG/RHyRVZ
	 7rwmGfRo/YkZh7O1rRZ6OWP+0uRaf50Iov+ZutuuKHL/lfUfbIbEFurF8QpJvJjIJt
	 r1VzSBpM9fbPmZPdbzBY+KA1d+polsKfeTB2RqStKcknD9DhK7wy197cMQj/qBOR/W
	 1ms36AyBsFo3tUfsa9krjYDpnktIcwM/BSnC7A75YKdzG1YXYxU+sni6eQ6usHXlgW
	 aSMfl0poKloOaZlISeF5UksLkKOCM/FQKVYRdT/Bi/ne3HRI7DvEsfA/r8Hw1+Rs4K
	 RF297CnRVaOQg==
Date: Fri, 14 Aug 2026 10:24:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
 <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260814102413.5a26bf8b@kernel.org>
In-Reply-To: <20260813104954.319065-1-abhijit.gangurde@amd.com>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 13 Aug 2026 16:19:52 +0530 Abhijit Gangurde wrote:
> Patch 1 extends the net/ionic firmware identity structure to expose the
> rcq_sign_bit field from the RDMA LIF identity.

I asked for a PR, based on a tag from Linus's tree with that patch.
Did you send that?

I only see a PR for rdma-core here
