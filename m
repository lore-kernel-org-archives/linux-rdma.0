Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA784BB28E;
	Mon, 21 Sep 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003818; cv=none; b=YZxIFjzEoJlLxiHP08LCSLL0Zn5HRPCER2O2QdRUlNZhGh2AB+v/5h5C0f4Qn9LtST+YY2vy3zzo9at0uNSpQr0v2wOS0w8cZHphT8xkEyj4prVHSs33A3NOTgNwWk67T6YrqJDSa2sd12OBwVMxVIc692fP968rOcdRf3nSQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003818; c=relaxed/simple;
	bh=ExRnd56sNxf0P8oZOH42TmlYkmFyGfOmxo03+yrD9Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kuh5LCbu7O5Omkv9cfumL/Nl77NM0llO6jnZpNQ0W2Aqzk8BYgrHDT4uiSs7ooqZvTsRnsHuGc4GRVf05P//iV04Q5gJd8LME9CZGBOHeMd/5H9hDNUrAFaBoPmxZkLclIHMVaV+/0tmVqdGnux5uLqmTzj9JWdJjSquanhGZAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFhFse7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFhFse7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D011F0089A;
	Mon, 21 Sep 2026 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003817;
	bh=Ua26Wzk5+rXUBQI+pJktHm7l6PYOAq/1f9N3wosqQyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YFhFse7biU1cgk6J6sgZJxUNoQvk0BXf8Y1UugqnRXKaSXFoPrtfDArlBSC84QVV5
	 zpO6cDcOsBNVLaLuJm5uEv4ed4jdUTUv7cI+3jzX8YkVczrT05tVT59inWJmS6HHXY
	 bsjUuasdYjwBWHAkB+/oTI/I66szKe88A0g8OsN+ziEYuIXxtK1i+gxVW5tlYRcF3Z
	 EnTGTYQo3USAY7v0tYfa7c1hdV25cXfenD9auuHy8lPv38HklegatFj84wLptRt2y2
	 LiVlNVxNz5MqQ0gyPBelanhpEL/D9uminGGB+1zKynUTNSJ/VGZcn79qWCEwe4eqkQ
	 ld3zf0Alxya8w==
Date: Mon, 21 Sep 2026 17:16:54 +0200
From: krzk@kernel.org
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: davem@davemloft.net, guwen@linux.alibaba.com, mjambigi@linux.ibm.com, 
	sidraya@linux.ibm.com, kgraul@linux.ibm.com, tonylu@linux.alibaba.com, 
	linux-s390@vger.kernel.org, dust.li@linux.alibaba.com, wenjia@linux.ibm.com, 
	pabeni@redhat.com, linux-rdma@vger.kernel.org, edumazet@google.com, 
	alibuda@linux.alibaba.com, kuba@kernel.org, horms@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net/smc: Fix socket use-after-free in smc_shutdown()
Message-ID: <arFKZNjudjaKJwzZ@quoll>
References: <20260917163956.2162779-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917163956.2162779-1-vulab@iscas.ac.cn>


On Thu, 17 Sep 2026 16:39:56 +0000, Wentao Liang wrote:
> In the fallback path, smc_shutdown() drops the passive closing
> reference on the socket with sock_put() and then still uses the socket
> by calling release_sock() at the out label. If that reference is the
> last one, for example because the passive closing reference was
> already consumed by an abort of the active link group, the socket is
> freed while it is still in use.
> 
> Move the sock_put() after release_sock() so the socket is only dropped
> once it is no longer used.
> 
> Fixes: 1a74e9932374 ("net/smc: Fix sock leak when release after smc_shutdown()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  net/smc/af_smc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 


You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem, how to document usage of LLM and how what you should not
do if this was posted in a good faith.

Best regards,
Krzysztof



