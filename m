Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7B72D3EEB;
	Fri, 31 Jul 2026 01:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459824; cv=none; b=ZMP/LbaO44hr2+X9Yu1B8em1tNMHjhOEfbHB8ykgTZ0e7h24O6ubyB4osVtCHuBD/J6i+/8h1axJU6kVAqwpqknGIMwSs1bHJU2CnijwC7V78R9F4K+OoVdjs3+kOz1atwTND64kg6rLC/B410to/B0+mbZY4VPojHkyk3eBNt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459824; c=relaxed/simple;
	bh=Z6w1vDmyi8Ro4MsCYO800LR37xI8ie0IZo+YAcC5IhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sz/xZ/j2h8KC+odd2Fvys0fdGsdvUAXliMTgw3LZKaEsIzIYq3L4lPl0PYhWtIUj5pd286jkqta/WOJXiP+YeSp88TcuXVzoNWumPRSb/a6XyKgymPeGDAz6umI34DQtfiTzVTTCYOig1rIB4cPZIjOQCB44Uhxx1Nxcf4DTW0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYM4+pXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYM4+pXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8C61F000E9;
	Fri, 31 Jul 2026 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785459823;
	bh=iiSSjg80EDycR8obWWDh44uNX+f5T/nFkgGlg/IY5p4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KYM4+pXlnRGRIWXB4wDQC+bDKE8ioH09X/m4fGhqTHx4bKg/DXX8zBl6dKkPzXEHy
	 7vdBijodShoE0oL6vptfuOSxQ7mumogxBEZXcq0JCrserpo0PYvDqq1gild60y7mYa
	 psbIG5C+is4ktpoQyk9O2amgmBVq+o4nQSnyVXQlHkdxTe0nIQFpgBh1k4UinOhexp
	 df+pwiGtdmUYQnOCe4AskucchVeOLEUXUf48+9CRxW1V1Oc/rfjDaZp+McZPMltqML
	 qKOlR/fEXk1h6QSs3eK1AufP0tBnqD84BDz8kIKXWJfpfr6N+O18kx1lajcoMwOU8y
	 dk3aA88s8MUhA==
Date: Thu, 30 Jul 2026 18:03:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>, Dust Li
 <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Mahanta Jambigi
 <mjambigi@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu
 <guwen@linux.alibaba.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Guangguan Wang
 <guangguan.wang@linux.alibaba.com>, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net v3] net/smc: fix out-of-bounds read of rkey array in
 SMC-Rv2 LLC processing
Message-ID: <20260730180341.4c4dccfd@kernel.org>
In-Reply-To: <20260727095833.1079618-1-yhlee@isslab.korea.ac.kr>
References: <20260727095833.1079618-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Jul 2026 18:58:33 +0900 Yehyeong Lee wrote:
> An SMC-Rv2 LLC message can be longer than the 44-byte union smc_llc_msg.
> If the device offers two receive SGEs, the part beyond 44 bytes is
> scattered into the link group's shared v2 buffer. If it does not
> (max_recv_sge == 1, so smc_link_shared_v2_rxbuf() is false), the whole
> message is received into the link's own receive buffer.

This should probably be a 3 patch series:

  1. the use-after-free fix in smc_llc_srv_add_link() (qentry_del ->
     qentry_clr plus the explicit kfree(qentry) on both exit paths)
  2. the new peer-count validation in smc_llc_save_add_link_rkeys() and
     smc_llc_rmt_delete_rkey()
  3. the ownership refactor of struct smc_llc_qentry and the
     smc_llc_enqueue() signature change
-- 
pw-bot: cr
