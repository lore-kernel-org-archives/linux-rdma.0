Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759561;
	b=tyow476PIuSvNgKJ0lcqwESURdkbWizVPRwckPsnQ7hVc2wslAWovxF0/F5GSCXBlHVL
	 IWmAerDgxo2zSpnWqOd1Se/C11nlBUsMNkoXZGqkemC44Fpyp0VURMw2i+c3RWcjayZyH
	 o7ZQnz1c1LMn1sm/5dzDHIP4JfEO2mK0qMTL/S/C8b9mE5tekfgGKnHTNIJ5/aV66C9k0
	 EWb5rNTQMXB8VXdSyTS7lD0Rlt8p48nYIA0F1s/JhIMHGpckGeEDc8apyxfeeWso64+dJ
	 7KoTBEklMY9krmCC/SEcj0JNZhl6ieR3ES7h6EJBEtX6VTgVM5bgyQdYAFU95BHdrAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=dtteq37MHedx+rE8JLWFOa+4G8437Cq3toUxDHQ3mCM3TFouEEy/fDJOrEqXfH/CagI4
	 wrHd0U+1ibFuOaCjTe1cuSjw45EOCZAEczjHKRYk0OUJDMa2o3EGh5N73MlhDoNBohAxu
	 91KsXJaUg3vxlG/03nujknTLdd+ryJGkuv3aXxP7UH8LTOk2ycWaXk6KsYQoCGDJ88d8q
	 iiD/ipOi+MutsyUZdwbjw4zTmHzEi6QlUlEFJLtY9nuqMAc6179T0u+PuLywG8xVkZNKp
	 thy5bkYEr0Gx+0VGSMQ2hS7DBWoy1/yIUEOpTneoX1PuQS9xcvYSfuefCacXIrF1xBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lkfV48H/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415F3606A31B;
	Wed,  4 Nov 2026 02:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lkfV48H/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4031F000C1;
	Wed,  4 Nov 2026 02:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759560;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkfV48H/ZsicWO/FBwG0JxlqHR9bDDvJ7m3UmhwjeXvfyK2posHfj3PVDfYpnWc3h
	 6Vt0JBym/XMiwKTRSt2tQPF1xQy1ONL77TfWKYRDCbroZ6cGB9Dm9W3M86LzP5sqMo
	 Ft5I5tH/XFYn+0ms6f2rj5FYl9Akdz/sj7ChKSaME0l2OMXtrxFe0Yd6GMaQLIwhAI
	 R9SLAx5/oEEpHwcFasNJ3fcwfZurnvuYoSGGQWRJQr20C6bgHjZQIh7WqYXZqY2LR3
	 T/2GlJKqh9TJVY93In1N6Gw5tbbGi61qdiQ9/kFQbL0pSvBZMFx+mw6SrijXcsVr0/
	 RQzFx3O8bW6uA==
From: netdev-bot+sinfo@kernel.org
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>,
 Wen Gu <guwen@linux.alibaba.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH] net/smc: deregister the MR when SG mapping fails
Date: Wed, 04 Nov 2026 02:32:39 +0000
Message-ID: <179375955951.488859.4992369766072112123@kernel.org>
In-Reply-To: <20261104022812.1484233-1-vulab@iscas.ac.cn>
References: <20261104022812.1484233-1-vulab@iscas.ac.cn>
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
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
