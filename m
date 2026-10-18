Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6D81A5B8C
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792289512; cv=none; b=dwj4gQia3evdtYP6+HCYB+6hqTnuk+5uQoMYvaoyM+VtnID8A+xUMsVNq4vHvN65uPo2BZqJEGStrNXIkIUXOUsN0n1RjyNWkm2T7AmRp7hE1f8IJ3LljA7IYb3ugmSxTDGzLj8G//jZ9WzCXVY3tytxjxM1MOWKM6Xg1mAEbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792289512; c=relaxed/simple;
	bh=quR7zaG5HvFKkoAcyflM6P6NFsJA2yI0PSyMysQvzs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPljZHcZGU8dYUAt7utcMewQYMtJHGWqbH7BclyinzkK9KG7T+yhTIdg8uinIfbcYtPeawpUIa/TdrSelEKhXLf1LoP0gRAwIAi30fnenqj2wXuNSDrp81zj2VXSAZle41hUcfuL/x993HshG1S0mBZXHqJ4LZjFX3KuXM+oqMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=QQIw8NTp; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="QQIw8NTp"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4395d31228so3327866b.1
        for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 19:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792289510; x=1792894310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quR7zaG5HvFKkoAcyflM6P6NFsJA2yI0PSyMysQvzs4=;
        b=QQIw8NTpx0NQVnPaElOZevzSeEGsEd1HNJUlehuDS2MEursrdpPIEapiL/nlrwPAE/
         vq1GtTOJLBBFzsy2D0eKUgVaMXkXNnlc9hM9pcp+OFhy1Qqea/tzUdKQb4PA1t6akFN/
         cHtMznWJFCw4lQ27SP+Fn0vLmmQnDzceYS703/4CVpDi+IOwlQpwy+l/6eu2+UseMIPO
         ag5rkYqKZqUJYwHjnvtlCMlqbB16c80fXFZqqfGFY+Fc8LCAzS1UAKU7KONBsC0sLibl
         4CEkkS5xkd1WiCOa1QExUiKXoKCDozL1d7rLPQHNqv3/HHW6ctYc2n7SAyJEMueDqmDm
         DxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792289510; x=1792894310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=quR7zaG5HvFKkoAcyflM6P6NFsJA2yI0PSyMysQvzs4=;
        b=QkLVu7XJTZJ3QNQRTIQxKJ4LS1OUIUHsDJiqHDKLIXgbwAT23l/wbxCXtovrxWDxJU
         4slQ+VVsK0YV5+nigWRCjPU/NuqEN6AdDnThkUQOeR8fP2uMwbj/SrNT94hmTBuq4bOK
         wzupYf2e8ZGG3eKu9SsDfagGTez0iCHMBspzwqCWvmHLDyrxNxZDRIA7xmyaSFGJDVCv
         8akHSsathm/ChU0sKXhvOHk3xFryOO74QFfyjV3gXTWAykSVjHeApCSdll9O5yTwj72x
         T9BEjJquid9r/5oHgeEW2c+tAdMKqF/Gzf/lgdgLYkMJCzpNldBPj0ZAiVs9WUUEoc9n
         VN/g==
X-Forwarded-Encrypted: i=1; AKwUvByAyvOUFTun4wUF+h5NpPZUJYuo8MC6WKaovnwZdhxSfTYAJ7IQN4sUq8o3CwGQ1D+2akuYGwNzsyYT@vger.kernel.org
X-Gm-Message-State: AFq9FYIK17dmewm5P99myQaPn4LEIIMzAjP0xLjD8Gy9MyJ2ocm645J3
	Uh3yWT3QRHydrmJmzg5PMnMIMVD/bfnP0D6bjsWerKF26HYv40iXdUqlO+ao6iRdQw==
X-Gm-Gg: AYBFou2URNVfiakZxHdb6gW5sp5/1X8JUJmK4pdb8tNCDvCT0aGvZhHIHkpr3TqdVdC
	7A+Gn1ieMBEm9v+H84IuX2iAaC4KyG1ZumMkjM2Z//y0VeeBMdSoqGqj2QmNIv4JmT6uouM7QCz
	qnqGq4Ysq1jtXgYAn7m/h34tSNhbraO1pW1dSdoB+02nQ1blVBnTAF4PadryI7q+XuhUVWgxTT9
	Q+c9RM22w4x9+d695KHlHfeCI1IuNTWXGrV2bMdeSsNPGLwOyHNyDXP5/Bn4D4KrXWjdUPJ2Y1q
	LgVvZPrDMi6nw9EMpxw6MRFR8s0EU6ahiIepK9bI+sbyIWJtmE2TuS2gY1PSVxL3Rd1wIcjJJEG
	4HuxyPROVzQd7bjLHhO0hJTWexqcBPtAUyXOQWx0AczcrzRDnRq4UjEfydKJPvN35ujnkDxzf8o
	bGlhwPQ97G6KYLxvEd+g2z4Tq4olxcLxMrey1+CmuiAjbRE+Y9OavvtY5Etv6J0DyJHXJg4Rxzw
	xmbebepEah6V/7NQOqLhQgHfRbQYIpFOWKnvPXRXteJGXdtNX5/42P2BlexPQDNPdoyr+9Vkp53
	jBnAv8KDY2JY3OM6KT8ianrDdyZs1YUdpDTdBA4zUZUic13Hk1f9orcQDfebRffVz2hnx5vBgoc
	emuEOomLepeaVJ4iHBSoo9CjIbCBr5TWyU+TO/JmeUiSc6IVkPxKiE13w6RJUXGrk+WSA0lWncU
	FuAAhvuNTqqxd1a6b2Inu2dzgAyQt2n6qrxCa0U7MscyKldtnJsyYMk1YZhnS+Km72erQOHX4eC
	dugpl84
X-Received: by 2002:a17:907:c48b:b0:c35:d50a:1356 with SMTP id a640c23a62f3a-c41a08dc5fcmr283934966b.42.1792289509761;
        Sat, 17 Oct 2026 19:11:49 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f247424f103187cc9af620d661.dip0.t-ipconnect.de. [2003:f2:4742:4f10:3187:cc9a:f620:d661])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb1835sm224698366b.79.2026.10.17.19.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:11:48 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 2/3] netfilter: flowtable: carry a priority into the offload
Date: Sun, 18 Oct 2026 04:11:45 +0200
Message-ID: <20261018021145.3769432-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atQkUoH3aa-J5-vf@chamomile>
References: <atQkUoH3aa-J5-vf@chamomile>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 03:43:46AM +0200, Pablo Neira Ayuso wrote:
> I think we already mentioned this only works for hardware, this is a
> no-go.

It works in software too. nf_flow_offload_forward() and
nf_flow_offload_ipv6_forward() set skb->priority from the flow, see the
nf_flow_table_ip.c hunks. The selftest checks it on veth, without
hardware offload.

Julius
