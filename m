Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794681202;
	b=uOd22HNb09XTGMdxjGIQEAOmxYkmmf6mFlxzH8obX66Nh6p1R/3gs9N7n7B9DsgPRTNH
	 035Wox0X46lCxdw4fArD7fJs0erZzM/TQt851/wSTPi26DXEACrDVj5hD/A2ul4wJpaKh
	 DxIeIxfxG8JzcTjnA847rZsaa9zZSbosGKwDkoPId/xrVWEWq+mZRXji9CT5iKWHTJ9ax
	 rzE0NDN3LXfrCQqJB1MeJICIgt9fMlFZyuS0pwQPpIGtOnY0PN6/TK1SfUpIyloSH1hfb
	 LnZ0nu24zxuTKst/urz0H0F9BFefKnPzsxBWzmAM3emZTwpyVY4cE1mFMjHWo2EVIQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794681202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	b=VbIaHV6tJsxUiS3Fa0XiP1cdea63HjFJ0uetBptaRBiIgSpnFMyoirw/qulZNnz5OGBi
	 nl1vVcMKw+mXese6bFPjK/8Sa7Ci6cz82JxXSHYdclyneavweeAmgl3pvSysB7uLgm2Yz
	 Wz5Gx5qOOXqrpBvrKkGdJH6QpHjEwqifn7/PdU6/Tqk9q0jbXBGEiO2xsoBPjr6xSXwT5
	 9EUBoRqHQsjUK8A3gWe/3DT47ygjd38FJMOg8l+eUoEdnRxxkCoR0ZlDcXOUdcMqpVMDK
	 yC5akRhoWLdsEayOoYkLVQYQy7jqO5PF5071ZAyd2xVJS/Bjl+PjqutRTk0sFQHLotg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5MNvSnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7640606A323;
	Sat, 14 Nov 2026 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5MNvSnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC031F000C4;
	Sat, 14 Nov 2026 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794681202;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5MNvSnlDqrqNqxmCHWeQ6p7kWyc7DMPFW/cUgM0axTuYDj4kVGtOgQnHQ1kvhp70
	 O0uhuyNIuYJkrTGz6weVdsNPT6gqr35fRoEULXsLvFS6DYmaupB6UK3FOjoJlhn1L2
	 AJjKb3kDChwFtgZZSx+9SQTLLlT0VcfdXx6BMFFlq81m1VNUmKzVehITaIM6jv9Mnm
	 u5lbuClPh24SvsljBzFZaAoKK35sCnSO5CVfI4aBp0LOmBtj1uBZYvVbjG90tdIVme
	 mL7Sb3ia8b+MD+T3Nsm+fbIBSDAvp7QYf2+py8J0H4IbMQTo6gyCxn8ixFKs8onuBJ
	 q2OmUEbL14EAQ==
From: netdev-bot+sinfo@kernel.org
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch,
 dsahern@kernel.org, idosch@nvidia.com, ncardwell@google.com,
 kuniyu@google.com, richardbgobert@gmail.com, willemb@google.com,
 ecree.xilinx@gmail.com, linux-net-drivers@amd.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, alexei.starovoitov@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, john.fastabend@gmail.com, sdf@fomichev.me,
 martin.lau@linux.dev, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org,
 emil@etsalapatis.com, ihor.solodrai@linux.dev, corbet@lwn.net,
 rdunlap@infradead.org, skhan@linuxfoundation.org, shuah@kernel.org,
 bpf@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net: keep the TCP fixed-ID flags on the header
 they describe
Date: Sat, 14 Nov 2026 18:33:19 +0000
Message-ID: <179468119953.2168702.10813567320493574993@kernel.org>
In-Reply-To: <cover.1794139176.git.julius@bairaktaris.de>
References: <cover.1794139176.git.julius@bairaktaris.de>
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
