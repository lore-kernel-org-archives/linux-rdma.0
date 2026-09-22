Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351FC345CDD;
	Tue, 22 Sep 2026 12:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081995; cv=none; b=WApiZbBisZqIzHM8FtGbBO721up1A+1SI+F32DxMnnZVPb+fAI0cJQVdNamUBkIhCHEPqkuji0xGDZ3C3MwHEd6fhzOYKTqZYECyYPuuLSThhAnxCShslGmPRRgyOiZW/ZFgTPq8NrjsoAeIAz5cHIax2NIJYANgifEouLIZBMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081995; c=relaxed/simple;
	bh=HBhTFGjcb/oq2NQxZq318uNBp75lqYk1Qme0VlTg6L8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SVqj4OWYtC7gb9+kPevdaX83EC6vYhqB1sK9nm7L4UixIM9N8ilcC16s78s136VuHqcp7N4cOD0OaMbbG2AiLnsMhxoabbE5Yp1hKbOkJQOYIXrVxeTJ0oKHsaYI301icsaUU4hJhNv/T9dv46R4ontLfMGTsQK81PCeB6fBFNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U30hXL8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U30hXL8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025531F0089D;
	Tue, 22 Sep 2026 12:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790081993;
	bh=vMkzLCE06iwghtexRskJsv5/ACp1zOpiqHdLIwwDSMg=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=U30hXL8Cu6Q4gpdNG8GJs+50X1ZOqbQ0JGCFhsgRJm+IvHHGbRnUhEJBeMgeZabkW
	 XU+YkNkMgBKKgQtuDJ/VyramCsuLmoWpoigDZZh/UioC/3t5ouy8fqpKs9Mk54wK3G
	 D+DoP2Lwj2yQkinvqvTKXvetwcBv9G6dmJoKvlIYa2I1UP+t0ODqpfzZ9U7gwwznv9
	 1OgJ505jTzTomciPV+jRpXkfkQmAgCb3xVIHLQORe604uGHE1Y7UCGh6p4jAQmYfH2
	 r4fSp/I5dlq8DKoDsYFxwlWZ/H0YzlBuJVCDbJq3sY36k5cgz0kBcxLQzXbs192RKo
	 sq1MZrNF36GRg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "Jason A . Donenfeld" <Jason@zx2c4.com>, 
 Nikolay Aleksandrov <razor@blackwall.org>, 
 Alice Mikityanska <alice.kernel@fastmail.im>, 
 Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260916120926.1761-1-lirongqing@baidu.com>
References: <20260916120926.1761-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG
 hash skb
Message-Id: <179008199053.3235896.15275843993198937658.b4-ty@kernel.org>
Date: Tue, 22 Sep 2026 08:59:50 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 16 Sep 2026 20:09:26 +0800, lirongqing wrote:
> rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
> selection and copies the flow label from the AH attribute:
> 
> 	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
> 	       sizeof(*ip6h->flow_lbl));
> 
> ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
> array to a single __u8 and yields 1.  The memcpy therefore copies only
> the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
> uninitialised in the skb buffer (alloc_skb() does not zero the data).
> The resulting LAG hash is computed over one byte of real flow-label
> data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
> bonded interface can be steered to the wrong slave.
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
      https://git.kernel.org/rdma/rdma/c/b63d21631f8365

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

