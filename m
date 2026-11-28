Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795834987;
	b=qe4TC/9IEYpxA97ivO1PePvjf4+3QB8g9VVMFAjjnQYcdrFAUXoH4xPwmKqtt1Af3iRp
	 O2ldHKePKZIqScZ1hTYsHrt8CFkt/iGuhZMTVVG36gNdpQsiRRNMMK7mzjXLDnDjc/QO1
	 +6Ih5nZEB+UJgP2eGVWjVtoi52EyhjtxobjibltnFLimi1GSY2CaSEVxKqS6ap5V6yVqn
	 jxJapA3Yvp1Bh+040YfNuCRg2HdCMP7DXIM24/oxvkGWYOSFj10qNHi8UvJF2JLcLuPFo
	 fkNaMm7QinT3MRXJWmWKp2vzuWpYOiLdeJuBf6JEYJI3F/sSEpSWhiqyo6lKNAWppvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795834987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	b=2GrREzqpYKhvPzWw3sP87ROPveapaUVaLD4Q+q4y0rIAKgeK3dXIhUuuX8Q7wu2HhNF7
	 LnMOONq5FNUFvOXaDEAb2NDOW2+My+0ltfGpixy18VJwmHtg859jik94EvwPoWwErwQgA
	 oKb5uzCfHiaLzBuyEa25v+UvQUaM7DGFjYDxcoKbjxGKfuvnnL06629wYRK67ni21Gspu
	 hPEh/4Q6uFtyfFcDOrjZl9Gz04V5EeSUG0/YtjmNDem/Ktl/DS/sFQdG9UzqUZio4z9TT
	 St0cH/sfDzM4dYfVRlSGRpKWEcJHxWTIJFxNpXDtmCqHj/6cOcNo7rGLy+4lW9ct8Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QkFQYqdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59331606A31C;
	Sat, 28 Nov 2026 03:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QkFQYqdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEBC1F000C1;
	Sat, 28 Nov 2026 03:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795834987;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkFQYqdo8UgFBhKbrNq5M48rcRcPI0+ZZI3YBrf/nGyQN+eKRn86sboBFGn1pXu/2
	 A9zY9YIdSEsXW6OKHmLNh08PCyvyTNEnoUqDz9DZKBT5jjPmYxk6iQnN3UOVuB6HJz
	 ifVsOExDVt9T1pUaJanvmSknI1lDrl2CksoLcAexIQxvTd9VTer0l4E2AxyLIbXkyj
	 WEqjHa8/Xkv/k+IiGhfffBveWF7R5Ilues8dkp0EwWN8chVSLJPVHtcru/MQE0Tam3
	 C5+1jnDUpWfLTUj0E+8Cmxwke8iF+QF00HHE5zao6x05RkdmaaVpExTINGxZ1KTkcg
	 Ypy0LaAk2b2Lg==
From: netdev-bot+sinfo@kernel.org
To: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org, Michal Kalderon <mkalderon@marvell.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 netdev@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
 David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: 
 Re: [PATCH] RDMA/qedr: prevent listener teardown from racing MPA requests
Date: Sat, 28 Nov 2026 03:03:06 +0000
Message-ID: <179583498616.3294.3592532320610708040@kernel.org>
In-Reply-To: <179583482032.4059708.5194029012702478533@jaeyeong.cc>
References: <179583482032.4059708.5194029012702478533@jaeyeong.cc>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
