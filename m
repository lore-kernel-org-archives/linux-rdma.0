Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795265171;
	b=DQ4QlF3cjpQpy+Fu4QO0etL9EAW4Uf/INZ03L66r7+q+X5dsdH/odUQhbmPQ4LQHliXS
	 8rK7GlOkj0cVEbhs1QVVczkLxA98QXPES/mGvuy1sSdpnfcGI/+pPJPAZvBbjwChgJelZ
	 +ter6K8iAcnu6ehInjALrnBb9APu7lqcxDaSgZruoaYO1/SNfoyFLlhk8PM/vAoOhFIvw
	 9iAyAZZwhhbK2CohMnxm2BHyLSSUoky2TxymH+Pe3566KJVbaaFbz44uu+nE2SJF+iMfJ
	 E+bzrJGuT7q2hXSQlXPsfX6MCOu+HimrYtyCzAmzx1YMAuoWcan1kbDG9tt8iZqXCsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795265171;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2ZEwLcg95Ugs9d+H41feHz7jpaFCbsgN0NW7tPaUY70=;
	b=JxGNNsC45c4e9B3SvxWXQUD/CL2vDUdWFMuKOeZEMGLqidxJUok+LhWjImleS7Sa0v6f
	 8JOU/NSYNqtSQqar6yi6uHsB8LPilX13hZHmdpiYPZ4KXsrm+Z86ZMzd0oYZasqqBJ+Fe
	 nQn9tSlVAOaGVuwSL0LY/bTjFR8wFVIsiE06VP6HjcKcMLKzYI8WxfwAkCf8dOdScmL8x
	 np1+ZoYdgAzSjF+MAHYPJmqhLIB7EnjhMhtLFtmlKDKVUtRJHc7moZXMBB5YYXHeZJXfb
	 nOUyeHqRDLmhH3z9eL2KR5oY2UNpcgr7u+MqBSUcbYR8+mb7RKXiSEOaSCZQGp4n/vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DH/4Y2Xg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D26B606A330;
	Sat, 21 Nov 2026 12:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DH/4Y2Xg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E625A1F000C4;
	Sat, 21 Nov 2026 12:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795265171;
	bh=2ZEwLcg95Ugs9d+H41feHz7jpaFCbsgN0NW7tPaUY70=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DH/4Y2XgRrTTNoUmmu1jgpPTAIyeagTqMU/nfrgWIDxsoLkGyIgoHjPQzLxU0jObM
	 1pMsbNzanQAWVgQywHNrdKpxCX9qt34vSxTDHxDZmmfuCMvF2BecVAskCKlBxvcPtT
	 BBKylQt9p/TjpoY44bqN43PL7OLkzfz05HyLDqCTkmlwsQkHxnpHBfH5/BUdwyT8Y2
	 IVUYowFCfY60rdoT33NFDIpX0MAXtGRgtWpS8bXSYDCuTTttbW8enziz33FrfmrC4n
	 Z/ccvwBm8CNhsk2ZV/mcqPZkFAp1Pa02Qee2PVFkkY3qzFr13LEsvlryub+6zFR6ne
	 ywAZtuogDLhgg==
Message-ID: <sashiko-outbox-227021@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 0/3] net/smc: fix clcsock lifetime vs
 asynchronous paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261120124534.430200-1-mjambigi@linux.ibm.com>
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 12:46:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 3-patch series:

- Patch 3: no issues found.
- Patch 1 ("net/smc: keep clcsock until socket release"): 1 potential
  issue (1 Low)
- Patch 2 ("net/smc: remove the clcsock release lock"): 1 related
  pre-existing bug noted

Detailed reviews have been sent as separate replies to patches 1 and 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120124534.4302=
00-1-mjambigi@linux.ibm.com
