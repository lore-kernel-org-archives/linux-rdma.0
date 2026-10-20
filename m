Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534435;
	b=1pwQtRilOK4ODfinwerEsY278PmvoUno/85njgiN1vDkm01UqpcfGN7FaNFWj/hvc3w7
	 l2wGFLyAr3cZ82S93ykNq0edV+Pz1541QP/kwI4qUPYhu5VtqPpc5+/ydHs5DELUfp4Gi
	 QL2iiQUBEufTn/7dMoSc5TF2ZEndHujfdKDOWQsJ6pSaJmhbl1VIFI00aeXlwtJONgMsH
	 Rp2e8yIUzHuZh7p7pWcFbcq6+hsnWwEG9NpFmqzza+0mYaPkE0TxOo5gr3a2sys9bBl7f
	 2TglqfDd2jftKzc8s6xZ4dxoKYLaZD0d+vSqvtyxPKwO1KTxFkxficW6qPW7cKXQW8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534435;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=jZfhbIqi1uUmdy+pyP1X9I2KypCtlyueUy+pbMyFKC4=;
	b=Pu7Yw/DyKHiX76pNbFP5NAw/wewnx7B2KOuh7od6g9aMYx7PeimOMwG3jqGlXirehLvQ
	 5XW7mrmq9ZcOAO8P31k2gvVRNwwPm4TzjOSQBJoMZohzmGNUoBzfvmyGSSR5jvLwy9vcl
	 XmOrwC5hAeh3PcxkKrSrtmVgIyjqgAhB639OgjolRnMZApCSd7XMjzqshgS+Qz9CmP2Vm
	 Hodgstl73wqF0rZTIRDLGLjVl8m75pSsz0OiBrdchEkJ2/v2GtPr702xfecB36qOBIsie
	 2Tf6gVrqMqzkuJnHaxw4BCjAj/0utGHs1O12QE9op/PpbQGGBKxUAVOqURyL9owCmeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZplb9jj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19822606A31B;
	Tue, 20 Oct 2026 22:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZplb9jj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FAC1F000CA;
	Tue, 20 Oct 2026 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792534434;
	bh=jZfhbIqi1uUmdy+pyP1X9I2KypCtlyueUy+pbMyFKC4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JZplb9jj3/fh4yPxtmiEATTk0TxsAhQ51FI6louGQa040mVzXQ8BPS5D2iJ69mU5o
	 6QhVF3SBrJ3x73n9V7B3OQ1cZUAaoheXvorGNCS2sRULZYq/Sh+vpnl80GqC2HUYRT
	 ktonkocnOBAjFssRKmlIhpnylCxff7cntyCzEkBaHxpa4HIKMUyz2FIGqT0H1XPieB
	 9QJeat0+uE1UyTqhZeGyHOrZdr9XTNzc4yO+Cgz18GrqoIoU25aMDUHQAEebhQAUHD
	 Qaveaet+Tx+bDPQjARR31jSBxdhpxelTNStdK6H9IjBJ6A4Lqjcp41gZj968IKOI60
	 g2cPZgKlIKNRQ==
Date: Tue, 20 Oct 2026 15:13:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, ayush.sawal@chelsio.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, pabeni@redhat.com,
 tariqt@nvidia.com, horms@kernel.org, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, ncardwell@google.com, kuniyu@google.com,
 john.fastabend@gmail.com, sd@queasysnail.net, ebiggers@kernel.org,
 kees@kernel.org, aleksandr.loktionov@intel.com, petrm@nvidia.com,
 u.kleine-koenig@baylibre.com, j.raczynski@samsung.com,
 wang.zhan@smartx.com, willemb@google.com
Subject: Re: [PATCH net-next v3 0/6] net: unify symmetric netmem and
 page_pool refcounting
Message-ID: <20261020151352.794bf03b@kernel.org>
In-Reply-To: <CAHS8izPZ18v_1CnRkaAAA=d94wutJhoOZdOFO_1CEXSexd_=EQ@mail.gmail.com>
References: <20261014173945.373295-1-almasrymina@google.com>
	<179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
	<CAHS8izMRSU3AyVf+sP5uXShiSKuLumZwT=fsgW+bhJz47UoPRQ@mail.gmail.com>
	<20261020150307.258b00e9@kernel.org>
	<CAHS8izPZ18v_1CnRkaAAA=d94wutJhoOZdOFO_1CEXSexd_=EQ@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Oct 2026 15:10:03 -0700 Mina Almasry wrote:
> > You should have followed more modern naming patterns tho
> > get_netmem() is pretty bad IMO. PP naming is object_action()
> > so netmem_ref() or netmem_inc_ref() would be better, no?  
> 
> Ah, I didn't know about the modern naming. I made get_netmem mirror
> get_page. I now notice it's folio_get not get_folio. I can follow up
> with a cleanup when net-next reopens. I assume that will not be a lot
> of code churn. I was also going to try to look into deleting and
> consolidating some of the now-redundant ref-ing functions anyway.

If you do it soon I think we can try to squeeze it into this merge
window to avoid unnecessary burden for backports.

> I can also make it one of the design pricnciple in the page_pool docs
> so that the LLMs pick up good naming practices moving forward.

I don't think it's needed. I mean, if at all we should perhaps
think about naming guidelines for all of netdev, but no time for that
right now..
