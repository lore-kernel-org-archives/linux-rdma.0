Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697701;
	b=cZpLom/EoGHlRiPdVAEEt/L/qNLoaJRCnKyZj3dTwDttHBoJyMSsVzEzmJaC4aOX3C6N
	 loKrW1SJqZXtU36GrV3uyA03Tu7pAWBbPspQ+Nxy+l8M2mDdcTUG37+/BgLX9fg/vlKfX
	 gyDw4YlA99GR46pOfBh2tiF3SxLP2GIAAL2IAmvrMsWCeFOP3UUI+r3CwCJTOUeZzhqVQ
	 yYo2tYUP5aqXOn44PNG8OAja6T+CdBToxgB18xNWQd2HHzx/7tW0lnWtGZts5bQP48N36
	 JtPR9BNfsFBahMr9khE80HJBxF02rdtYMfPUS4EZrPa/7OODR2kRsQfwNU+e8BlST7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697701;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZtVxNjum2onVgyfgmJiMMLLrDXk38z30mQSMHGHOx2o=;
	b=I+R6h2b4YTX3I8cso9zJml5mcc95FGjh9ze6ulnAjyIDEO+bjM1HTdFi5KY1yX8ds7sQ
	 J5kITIZK9g/AVYBfo0zV9CyuMdoMNo+Vtefn8B7h+antixsRHVLDOurbZ6+47XXKkP8sR
	 Skn/vM+Rolx66Qg6RCL7h7h1eocvM4k1RtVCUWW24mXrR+QV852LYreZcsMQqrHKTThak
	 J85GfobsB3DhDTACen8hJIzDz43RV3UtZPIOd79/PIHvS/lHbCgMzXLd/wqyBDpKiG996
	 w+ASLmICx1KO5EC80+IvRMLkEc+GpuAXL9cXRrkUwapLxMQOP7V8jIV+uy8Je7RhyPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZgbTgaGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477A6082BC2;
	Tue,  3 Nov 2026 09:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZgbTgaGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE411F000C1;
	Tue,  3 Nov 2026 09:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793697701;
	bh=ZtVxNjum2onVgyfgmJiMMLLrDXk38z30mQSMHGHOx2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZgbTgaGrvAF8Fb6QRcJFIMevTkk+19RkTYYqUeUBK18d+O+RfedfvCgCLPnDxbDjh
	 PIxu2xdGoJsz9a8OXS0W3RKZud0ftPsLJSDz/2EFQbwSMXQ7GphQSnux0zNeBnaQzI
	 iLFeYjlrB+gzWnDA2GZqO7X0ylbBoynihEXQELaIsWEV2Lox1RvlkYYanmQkxbmii/
	 yceR/kMzcMjVhJ4jKfULstJfXuMYDkmYDzyUIL7QdCGoEY0BzRh+8hcuSP+1AWxvk1
	 6/HmFK3jttnLhZTBfHbx6YTS4sqLrGbN2IkJvb6J5hoIYtG2CVete7W3Drvmzm1ol7
	 k5gxldwI3tGQw==
Date: Tue, 3 Nov 2026 10:21:38 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca
Subject: Re: [PATCH] RDMA/hfi1: Free the trap send buffer when no address
 handle is available
Message-ID: <20261103-peach-mongoose-of-charisma-dee123@quoll>
References: <20261103081915.1147987-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103081915.1147987-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 08:19:15 +0000, Wentao Liang wrote:
> send_trap() allocates a MAD send buffer before checking the subnet
> manager address handle. If creating that handle fails, or if the subnet
> manager LID is permissive, it unlocks and returns without submitting or
> freeing the buffer. No send completion can release an unsubmitted MAD.
> 
> Free the send buffer after releasing the lock on both early returns,
> matching the other failures after ib_create_send_mad().
> 
> Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/hfi1/mad.c | 2 ++
>  1 file changed, 2 insertions(+)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
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
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




