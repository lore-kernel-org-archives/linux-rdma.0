Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533789;
	b=U6QAds3Vr8+eXFXZZtrhY3IOXk+iLZnjUUfXKQkRYsmqFYKgfCLPOo9h/xoGNnGOVAnw
	 pETbtUTnQ1whzITDsrZyZPKDhV6939/tr5gjqVoW7Di+K418QlAvlqdQ6iwoLaon+h07e
	 HJPP7xQNTPLTGCPCKWybBo06S3Deog8h8F9Wf9lm7d4w6v9oNoeh9NBKt6sonZZxLw6Or
	 bdGeySuFkaRttsa4V40FoPGmfKreS5qLyQG9Qj3ecfw/iG42aA5Tqajhn2m2GfS5zIU/v
	 I98jD3cRjNFecGQqXxuNuAH6+Wf6rWumeNK/rPIUcPlqUmZxg+aFp0wctbKEbumC7ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533789;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=TLUy+0Iwf5cqLX/7iERPs0J79x58Lq1KO2PtDh6fVLM=;
	b=vFBWxlVKEC5mMfva9iPzo1fLn73aYPGy+gE+7VYFkxJTWeXisqsW6ox/rgnDdqv7NBll
	 RkvBfC4/WJo9KWArtdu68dHerlG2ISB5TodoQ5u/nFIj8NL2phwIoiUjys9H+5vZk57b3
	 8uXiisSn65Bx719aHzPHomsROwRQcxOtPZLEcUwG4wMLZKejymWqOVN3TmrZSA1tcPZFv
	 9cZBvnXt3dIPe7O+4VMghGzDrJd+FQmVH5YqmMjCvQPBGfCIv2h4Rx1Npn9GBj1JORfHz
	 xy+yQXpqaWz9uPAUiLsa28ZwpO0RYtz9OCr/Z9famLyWP1j8aI/AyL0VE9/USKefEmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=luJJJ1kL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA70606A31A;
	Tue, 20 Oct 2026 22:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=luJJJ1kL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5791F000C9;
	Tue, 20 Oct 2026 22:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792533788;
	bh=TLUy+0Iwf5cqLX/7iERPs0J79x58Lq1KO2PtDh6fVLM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=luJJJ1kLwyFswru9nVKygkBzEPDfpEkh4jzwGCopNmbCDNFK40cR2a6B8G7KcZoNX
	 SouNHZ0Xp87AKDliPX5QAWLpKdrTLbxT3wHPFvaHsnIkIqv8ivT6lPEqqdsmFyBRP4
	 cBgQMq/57IcMKRqq1gNMTuq3Lz09xgW9gapdiGOtFzCm4VPgQQCm0mkGgMl1GOURlp
	 j5A/1UeY/i4+MuoU1T7xoUxcBEM9sFMiGo4ga595TZGj1INs3SpcENe1pbkWAUfuPa
	 2fb3FcbiFvkSq7FQztHiS0xwyqHTl3j1XZl3RzIBSny7Eu2jxvXznsQ/tjCdb3RCX3
	 Egfia/Gyw9Mlg==
Date: Tue, 20 Oct 2026 15:03:07 -0700
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
Message-ID: <20261020150307.258b00e9@kernel.org>
In-Reply-To: <CAHS8izMRSU3AyVf+sP5uXShiSKuLumZwT=fsgW+bhJz47UoPRQ@mail.gmail.com>
References: <20261014173945.373295-1-almasrymina@google.com>
	<179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
	<CAHS8izMRSU3AyVf+sP5uXShiSKuLumZwT=fsgW+bhJz47UoPRQ@mail.gmail.com>
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

On Tue, 20 Oct 2026 09:23:03 -0700 Mina Almasry wrote:
> This is awesome. For years the skb refcounting annoyed the hell out of
> me. I couldn't fix it on my own; there were too many edge cases I
> didn't thoroughly understand and could break. LLMs made this possible.
> Thanks!

You should have followed more modern naming patterns tho
get_netmem() is pretty bad IMO. PP naming is object_action()
so netmem_ref() or netmem_inc_ref() would be better, no?
