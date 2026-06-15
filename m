Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ABB31717C;
	Mon, 15 Jun 2026 19:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552972; cv=none; b=Rz7I40L203aSv42onJCqW2bSs5b4IQM2UwWGFPSMdx9dOBX6fNBfxsEH4tUPjmwMl2U7MLNEL/D7F0UZ9cQiyTaxE3XVvMqGVRmhu0/BAmUrD2IfFfnhzDky7hQBJtedFsZhQ/rJcgcoveVwLbb1WdoseZz8Xlc/tMnzrsPE2HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552972; c=relaxed/simple;
	bh=GYDjYLQ9gRzm8R0WxEs3pazuhNSTAW7CY7oybNEvQ1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2XiDXswGJP+E4mJrwI8MtxWGp+jGXYR2xPThSPTd9QlVe/ebuI7b7JFyM+YUGGhJiOmBvGoAoIDeJVl2FCxmgSB1pNO5S0jEl/rkmDXQ7K477UeCpRNXpzocMmFtFKNTJtZD1EjIlWd3z7BUomSWgukZ9mO/I6CKTwNnSs1/5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/WOEzyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/WOEzyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8961C1F000E9;
	Mon, 15 Jun 2026 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781552971;
	bh=fxZ08tIsAmrwl6e/+2Kd3NJKBNmMgE47ibSU51+0cJ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a/WOEzyYrk8XJL+TtC6qwssKhtXAfnulfNjVf8UKyzDM0Wzch4/pXVqrfyXSLWqCA
	 cBKv4uX+Oclb0YpgI1uPANGMMQ61dGBcKDuDDl8/JnZoXxzY/E/VSPAvyP+OUSTFJy
	 ONk5W4Gb8rqhAYVeBZvms7cTSlUrpMZjdPpvH2udcN1FuNPhLOUWT0VXQ3TXhK6/6R
	 as5R0MS76nIFma07QAqNmvCwWPSZrqjELvlU6lkvPdzHVfE+yL07lDMRUJjxTktRGz
	 kiCWhP2Gdvy2zF4fLhhre0o6Qda+6XvU662BgbEhg5GRsEuDplhcDCQlU/bBTKNQl/
	 zCtH4nLzoTKYw==
Date: Mon, 15 Jun 2026 12:49:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 ubraun@linux.ibm.com, stefan.raspl@linux.ibm.com, davem@davemloft.net,
 yuantan098@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
 lx24@stu.ynu.edu.cn, d4n.for.sec@gmail.com
Subject: Re: [PATCH net 1/1] net: smc: fix splice entry lifetime imbalance
 in smc_rx_splice
Message-ID: <20260615124929.6f98051f@kernel.org>
In-Reply-To: <192d1b44ed358ca143f44ef167d14153bccc51e9.1781097957.git.d4n.for.sec@gmail.com>
References: <cover.1781097957.git.d4n.for.sec@gmail.com>
	<192d1b44ed358ca143f44ef167d14153bccc51e9.1781097957.git.d4n.for.sec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Jun 2026 01:54:11 +0800 Ren Wei wrote:
> smc_rx_splice() hands candidate pages to splice_to_pipe() without taking
> references for the lifetime of each splice entry first. That breaks the
> splice ownership contract in the VM-backed RMB path.
> 
> splice_to_pipe() drops unqueued entries through spd_release(), while
> queued entries are later dropped through the pipe buffer release
> callback. The current code only tries to take page references after the
> splice succeeds, and it derives the number of queued VM pages from a
> mutated offset value. This can underflow page refcounts and trigger a
> use-after-free. It also leaves the socket lifetime imbalanced in the
> multi-page VM case, where one sock_hold() can be followed by multiple
> sock_put() calls.
> 
> Fix this by taking the page and socket references for every candidate
> splice entry before calling splice_to_pipe(), and by releasing the
> matching private state, page reference, and socket reference from
> smc_rx_spd_release() for entries that never get queued. This makes the
> SMC splice path follow the normal splice lifetime rules and removes the
> broken post-splice VM page counting entirely.

SMC maintainers please review.
