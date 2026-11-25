Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795609377;
	b=hvzoYHQvOV9P0aarQ3lNAerMtex3i3fRfUOJRJYlt+yduCWiLZnie9A5tR9j4/UWSMju
	 zWdFvsIi7n/fu1qsGA2aNjpR6v+WMwAVK/yYG8/z2jyQf9XNNJwfNE0pw0lGLtzJt9W2Z
	 Q0WoT850iT94i33wsgQaSvQlaOaWzKXOGYwdPGPzOMG84lZjzy4MJi2TKNRTfJzmy5bqf
	 kYJtd2BTdbaKjwBP4ffer1bAulbh49N8vwqPYdEuH/eRqfr5jK3cituP1Zq+Mdn92/aDK
	 5jxBmw61guDs0Hb8S8H9ItAXPvIbchlAggkbuyC3EabmBKZHCKp8s7Btp/qL8Ed466Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609377;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=BqYbVkp18YFTLb3VEkoOskWOPMdBBEJIN6BpVjF2hh4=;
	b=A9VOFERdI7Wc9RlMHvwo4k4hjI+mBiBY1BZaQiQmULcbopzSczEB2t0hm0RSfOpxHmAI
	 VEaVCZw+0VAwUcsz2nuBqFNESX016U0feQgXJKfN7abnKeUIdvxakaH0zqiewPS7pcm4X
	 r7qwZhW/UpyoZoNWorXs6DO5rowTUv/Hw4CuCdItOQIWbEz7PopY/0RCJtlhdEuaNWQg7
	 VMVFFcTSSYopWQ+Rz6ZboCx1lSsD0NGHlNanPNY0ZyUx/MWarsxKRynBapvXv/DCgM4Ny
	 vmDt/ppm5klediAUtwoeNAx3ETojxl8jHLRisUbhZ0E5atUmv7GFE5Fjm4vBHwn+13w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ho1r5IhL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CF7606A326
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ho1r5IhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573901F000C0;
	Wed, 25 Nov 2026 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795609377;
	bh=BqYbVkp18YFTLb3VEkoOskWOPMdBBEJIN6BpVjF2hh4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ho1r5IhLFFm614MiesiicedLDMSFpdAwZ0axt/yeTETSDPkBJHRqsKJSYK5UUBNtC
	 VxwJLWCKd/uT6ula5CzyMVe50YeH+zyiB+2PCTgUOKOcSYNByPqaifNYcuSZk+tU3W
	 rUg3TxjF0rmwL4ZNHQfZXpw5+kaw7SmkcqqJlHhZ1MQbGAZsIKzEpMKdY9F83NHl1L
	 G8qazseHYY6vMuHKCqswlVy5YCvectiFWJxsEN7hS8/RuQ3Tdf/1kNeKZF77We8JA9
	 hDDzTH6W1j1bDxfA6VHuEJ2HASQH4a20LNML/E/1w8tl74sqrH8PR/QkxNXrFGKfus
	 oK/HtFTbfwHXA==
From: Leon Romanovsky <leon@kernel.org>
To: dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, 
 dledford@redhat.com, sebastian.sanchez@intel.com, dean.luick@intel.com, 
 mitko.haralanov@intel.com, mike.marciniszyn@intel.com, kaike.wan@intel.com, 
 Wanhui Fu <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123041556.1888113-1-fuwh1120@163.com>
References: <20261123041556.1888113-1-fuwh1120@163.com>
Subject: Re: [PATCH v2] IB/hfi1: fix error paths in hfi1_mod_init()
Message-Id: <179560937395.1209522.16053960019824865334.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 07:22:53 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 23 Nov 2026 12:15:56 +0800, Wanhui Fu wrote:
> The error path in hfi1_mod_init() is not completed.
> Fix this by add some goto label.

Applied, thanks!

[1/1] IB/hfi1: fix error paths in hfi1_mod_init()
      https://git.kernel.org/rdma/rdma/c/c18b5f8b77fbba

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

