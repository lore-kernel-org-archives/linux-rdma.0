Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143157;
	b=ZQtbSxlzgou6S2SL7EDaCIvLTRykI/uZ1DZtQFKTQJiTNQbAgrFabFWsP7mtMYwJeEfL
	 c3V1DcBnfKChgfmRmhc1c67+uljegSnHCjO5tR/EuRQK3kbrnWGwR4ADWV4h1crlqbV1x
	 ZlONXa7CDc109XXJKzB/tu/7Mqpxh+tPu2CieXKBTLB2423aEb4HnU7Yoy4MjjKpb0KAb
	 o4GKrD06tswNIrTyDZhTQqDfyNP3BwvkRHOKL5UtapMM/vv6qDZNbyNl83qzAcuUVtPVJ
	 9rp9svBRDhIZSxjlrJyfKZF5XvnMLWl02tu/k3+xade0FdolpsckR3OD3jAfehr1QEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143157;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=R0byDOCbMpV3cQA2Ji1YPCftT8TMg7Mfe6FkmiCQqg8=;
	b=2mu/yK+gbdnDEaXqldN3EU0q3hos6V9vfVY4vzM9MVbjMNXJYuykwE7U1sYnXewqC7YJ
	 N63oB5isEFB9i2K96u3puHetCi23v4N/xQOJsP2KQeQU8IsJJYwPVHIZZBJkH3GBOHDrC
	 vbEZgfcCjvUTrUhCRb4QfN2wzvF16s4WQX8Mk/CcxC1OJAQPRbMuVhygyNr+ypeE/lnrS
	 5LBXoo8UFi+q+Ohqlet4v0MwutV5CmSAyhX9StetonT6w//SRJZRP+rFlFjMnSEQY2Eb/
	 khCrDdYJXiQg+1LbApgYSdGFn2oUzBTvmxntK5yE9lod2uA7b0oauyg7aRGAr0wDCdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OplKmHka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1446606A320;
	Fri, 20 Nov 2026 02:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OplKmHka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33F51F000C4;
	Fri, 20 Nov 2026 02:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795143157;
	bh=R0byDOCbMpV3cQA2Ji1YPCftT8TMg7Mfe6FkmiCQqg8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OplKmHkaXP0+9LAR+1s78FFbADek7xjUP8lCFnHJAHEe2AR+mmsU2BLpfjlyO4cSG
	 DIsark2S4lCPmElRHghfXIizkXzkWND7304LIEeP+qwEqY+UegBkgtmIdDWQTYC433
	 MenIYqM9E1ATX9aASYkGrP+vpouC/gjvlqu1P05E2QBhwh1FwAoqHzqwW14lrttXVG
	 tERf2wrrxivL42/IFQVBUtoPG9SCW+XYF7qpYgTA5h6D7PiMqBd7tm0MlgkrFq6VpY
	 Lj8ftVfZaOZYJ1kMc1IznkJVlkJvRFA4b0jwE42eRzRqlN8huoOta+NVrQaBcx679O
	 B1I+tomvnEhxQ==
Date: Thu, 19 Nov 2026 18:52:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, Haiyang Zhang
 <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Wei Hu <weh@microsoft.com>, Konstantin Taranov
 <kotaranov@microsoft.com>, Simon Horman <horms@kernel.org>, Erni Sri Satya
 Vennela <ernis@linux.microsoft.com>, Aditya Garg
 <gargaditya@linux.microsoft.com>, Manish Awasthi
 <mawasthi@linux.microsoft.com>, Breno Leitao <leitao@debian.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 paulros@microsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Set 1 usec / 1 comp as default and
 minimum interrupt moderation
Message-ID: <20261119185236.09603dbd@kernel.org>
In-Reply-To: <cc705453-0794-494f-adb9-b6fb71254ba7@linux.microsoft.com>
References: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
	<cc705453-0794-494f-adb9-b6fb71254ba7@linux.microsoft.com>
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

On Thu, 19 Nov 2026 15:52:40 +0530 Sahil Chandna wrote:
> LGTM, Reviewed-by: Sahil Chandna <sahilchandna@linux.microsoft.com>

The tag needs to start at the start of the line, otherwise tools wont
pick it up.
