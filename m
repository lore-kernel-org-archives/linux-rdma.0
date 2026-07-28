Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA43478846;
	Tue, 28 Jul 2026 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785276663; cv=none; b=OMBfTWUw4RO3kBwAvFus296sYF2NFvq0qNtSWoTpAW5bW8+F7x1udNqC+JxDutmCeE3xaIvzH3qWpf7h1GQ+vJqcaqrehloBRFHUL/mtOQEmAKvv9igCQVptQVN4Zg9W71WIBJchtXC1/SOms1yVWpmbk3T+WvbDpTmwR1Ha744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785276663; c=relaxed/simple;
	bh=DSU11HJ0gEj2T7WYZIFYs9cZxzDTOZBiQdddxtCYqtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIfGl3jhYDuXdG7Z9Sg7Fqh7C6qsqzWLcjB6VxvyPP0jliZvMUAlxnFMdNyBhFvf7GywamQfumU3ZD7qJXsFYkqVD7XMiEhXOzivsXvcwiyG9lmjL0Ltbdtn+42mb8hHE42Nq5isuJhLUhRmqUQePn6UeWEjG4LQexa/zodoGTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N67ZWvtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N67ZWvtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42D51F000E9;
	Tue, 28 Jul 2026 22:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785276659;
	bh=nIzR7Ng57hdq+Zk9fctd1mnE9XJG3J564Q1if55yDP4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N67ZWvtC8BgzVctaomn+jSqVPrqHBHSvI6hrwyiGuOR1NJ5Vk6mthbkw6TkC/g90O
	 4FsXuXK3IwudXgSywg4r+0f+T99qzDiK0MkR8QTRs8oQ9Ylx2R5XhRSeScui8wTikF
	 qpbvvctwyf7TJbLpPSXq3Y7Gj3iNa6yioIh2IgFPJFVaFm6DL6RyWQveAkzQG/aKfZ
	 lL0xmUABz9KeZ0tfNwPqfoXmCP+KhVnH7PnXe3qehUCsF0JrAku3uo7GG5ZpDo9p+k
	 2EJM2hnp69qLY1QXmNxR+6rPeGzZSXxCa5RvsPCSAa6nLvQ3KKjKZidEBqR9f1sxMa
	 pM/nDLDo9dYWw==
Date: Tue, 28 Jul 2026 15:10:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, leon@kernel.org, brett.creeley@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, allen.hubbe@amd.com, nikhil.agarwal@amd.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260728151058.17f8fc94@kernel.org>
In-Reply-To: <18c6130a-c8e0-8e58-ad1c-f1578e1c5f46@amd.com>
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
	<20260727182825.7b9bdffe@kernel.org>
	<18c6130a-c8e0-8e58-ad1c-f1578e1c5f46@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2026 16:48:25 +0530 Abhijit Gangurde wrote:
> For the earlier PHC series [1] Leon picked up both the net/ionic and 
> RDMA changes through the rdma tree. Would you be okay with the same 
> approach for this series or would you still prefer a shared branch with 
> a PR?
> 
> If you'd still prefer a separate PR, I can set that up.

Send the PR for shared parts, please, that's the normal process.
