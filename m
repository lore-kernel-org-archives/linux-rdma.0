Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795142810;
	b=lVDvCHvVL+zbvObmaXW21J9ThqAPm3IHCp5gJ+p3goDfp2yBtp31aGxGFru9GL8UPJJo
	 Pnd6Yb0QtZNQTWHRQh88HmQ/jZiZIEiyWs6okrL2qQIk916utDXKeMRkVrstuDthsrHCD
	 0LPivueTRTqmH0KPUu1PCEQBd6MMVR1WABG3m0NpUWy33NQONiu6Hfm/4LdXTNCSzOBRy
	 YDrZFoqsSRMZpcIRrQAR3cYO/5+3ILVMIufY5GMG3QvGoBEGcTa6kSjWdffCyghJE+5ww
	 c2jWcpnOrlfWruD+ta5dHtId2oJTsQBodx0ukwjBrdia9ybZJAWz0Bj2U8pNukhwqCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142810;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=yr/uKPUgfAaxf6T6HbuD487OUhPehvlRV062kb2O/9g=;
	b=gpR2+fhN7f+aB5QHkor+DPsP8f24UqRd8vzGdCr0G1f1DkUB11511c5V1k17c69Tsid4
	 JgFEij4oywvSu/8UdRwf618bf7begRZOaiCq+uDD2JNYQIK7pLI8w15WwPQeH9c40A39F
	 8ghnyFzV7w/VXM9x8uJHLvhtkJaTccVrHuWbaGqB54gNjlqn8NvFVuOXScPLFUMxBnHji
	 Vv783yRp70Nq7exhdAxJ5y3sxmdSJU0GCVOBc5P3bf+76TryFFEhwoTl3RK9rDHGVJSgG
	 k9cwsJSBz25+UAKks2Zf27/pkZDSKvw91IDYCYZBiMcBZdgP75Vu1vceJN17ovxS2eA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eEqvGS8N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55377606A326
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 02:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55377606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eEqvGS8N
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-372bdb942dbso514835eec.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 18:46:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795142809; cv=none;
        d=google.com; s=arc-20260327;
        b=LekzVOS9Ovgz6WhTgFt4sbWHpb1INTIbEnK9gyOWG2RvZKSgelZqUR9iyZSjpLvK66
         PzDy16EeoVSHFkwYMQwnRRDmF22XWosPe0yo7Lne75/AO5pr1G4TmbtTSmKVtA+nQ71B
         Eft5N8dNG+OmtQPzPc65VZN75ja9+MYQSenRDcPKP7lxVwt/Q1gICK5X1kyVMSkWBgWN
         2pyKTB3WWy1mjrtDR+CfO/XpX4uTG/+Bh6GuFQSIir3frBbq19qfc0LnWhX6jC0MmLKh
         r+oXUvdvf/8/OzW44JnI0OXqYxkRuBV0VfO2BiarOeaUdKRfmd64WBIxV5WscvSAleD0
         BpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yr/uKPUgfAaxf6T6HbuD487OUhPehvlRV062kb2O/9g=;
        fh=rLoi4v2T7HngPlwH1BGqBXiPQ6Jy5DpJA48s+qDWR/E=;
        b=cKicwYlsU9ha9zZJBLMOBHpvv+lk9Jf6obS9c6KMvm3OY+Ib5gIqGCmDkOCueZcP/d
         qtRWQphq8CR7uHAHhTheq3Q7Mvn0anO2WEqF8zp830yu7vjiA8MRQbvOJbuYI4VphPUL
         kxDVCQQrXcqITDZoAOKrNKLH0JlRUN1Zvcs0FTEfH8m12+bAWWUXGR1BKYFPhwQ/yxOs
         982VSV7+Fhh41KLG/mKRM0Z9MMlfmpmlihmN0p+nFo7YUEhqQfbLK7wznDHTX7/lhJKt
         /2gtZ7daa8hl2HOaJb9I1gIABKUOIlt3atrV8TJRrd1q1X4PIyFFgWOAQ/mUCULaUA20
         31cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795142809; x=1795747609; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yr/uKPUgfAaxf6T6HbuD487OUhPehvlRV062kb2O/9g=;
        b=eEqvGS8NSjDv/lk1dVAeRWGEh8TiPEgsovxYo2LanZz/ysbPTA0KZq1Irb7hcRkPPH
         dZSKM5hJ+MP81SnZ+0YwGi9bkP1Nj4+OFZ0Lt6OVh0NqD+8zwd2jHvx8mYlUazKKsh1m
         HPrp5gdyujUqmXeYT/G/nBelGP45z8ik/RKgIuPi3Zckw5IrXLdeVO03dmF0pTH2nmhS
         hsnbTKRCYVDZ/qt55BKdfe/Wx9Yu584hJ9b2q2mT6yR/WDdR/Qx4DXrvOm1j343IutY4
         Y47ubAtcOvI/QjaVZ/IOKNUxRBxkEueTGnwBZYTX/g37Y+CT7SGJLGI1cLuhEF7b8+Eq
         NeFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795142809; x=1795747609;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yr/uKPUgfAaxf6T6HbuD487OUhPehvlRV062kb2O/9g=;
        b=cMfNPrwu353v+0WSA56nKZFRa8CMQiB4mZCJ5XO9+TPLD3Nv7lR6XAsXr15VX+FgZZ
         RWcms43VCLvtzoGJT9h8D25LdsCS9EbsotEzO7NenVy4Nf8EpYKchY36/UhFZ7oYY5K2
         0M77JlvOZ0qJTtzKpRs0YINSYUGvQMja4qg66ztC+Bl6QqiZHP0D7NcGtIJh3IS7AEaS
         kZJzXv5lctuH4HfUITx/iVgjyttqi5kFny7JAQBrAVk+t9HEQIKP7lUEWq4DtYwbH6oJ
         wAhaT/naKVXzct/M5RMwKh5h7b6RexQTjANDCQy+gtfbVbAjbScmA8nRweDC2sygwPbU
         1OXw==
X-Forwarded-Encrypted: i=1; AL+hErFdGsyw5IiomsCuMO8YRPclAg5t8o74UHrAtAl2oBx4mb+o1Yo3MWKd4XakuLBwYUul3maKZm5DdFoY@vger.kernel.org
X-Gm-Message-State: APuU4Z8eDWLXVwQ5jMTiWI/LkKnrh31Igy/4bxLw3dGIw8xmCPjSfgo/
	w2FI0Ap60nRH3JPo187FuNVH89ZxbrTT2mCJD2TsTzISLE87qj7NdH9WplmHrhkJAfsEKCJXhFF
	zyP66OdEJuN6pHBGRV9Av7lrkP/L/SHQ=
X-Gm-Gg: AZFdTZcjU6/P1piqUAbN+CoYU2Uoq8yKmCLhB8D+YAdsL+OeUX7jTSIFCJ+dFA9Bhiq
	wZZDd/EbuRJdeHdRqrkESnAWitTs+cVLjrrZ6/cH+LLch6N4HkhCfl1NHRPsBSSyTT68vMcHCln
	962JqJ6Zml1ACPOJ5PInO8YhksMLU/69acgdrl52b1n0wobup6wJm9O+7vR4OV/td62CL4begGV
	CUTLQ3iFNtiedC7BbwpkRvdHNzOiWB7ACcdYAQp48PVUh9viOzfMy5N81QzBoMnzwonrZ7HEbwz
	VbdK6J95+/D1NxfpoQTqHpE8not6dDuH5Efj+BzSz4bTPgG6WuJbKYA4P1ya7klEx1CXE9WaGG+
	F5wF79gucLIANZb/fIcCxNICkE7Q9KajVcctj1Zv2aQKUt1IHa574ew7ti/iW381jtg7uCcly7w
	9Nxg9BtxqoZYuH+osG
X-Received: by 2002:a05:7300:e9cd:20b0:36f:f3b7:6dee with SMTP id
 5a478bee46e88-3856f148099mr1509811eec.7.1795142809415; Thu, 19 Nov 2026
 18:46:49 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118051247.3885308-1-lcy8047@gmail.com> <96a5ce67-89c8-4010-bfc4-4553e1aefe87@nvidia.com>
In-Reply-To: <96a5ce67-89c8-4010-bfc4-4553e1aefe87@nvidia.com>
From: Changyul Lee <lcy8047@gmail.com>
Date: Thu, 19 Nov 2026 21:46:38 -0500
X-Gm-Features: AclHuK_LbjhS7-Db8Zoq1dtarOebPOZsaYeLwUIwTxAs3oDtr1MYrA09Uyk3gnY
Message-ID: <CAKefsHu6P6FJAz6hV6+Fzm_PgXcTCn54WjD5pH0ThLC1A-DOFA@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx5e: IPsec, Fix RX mapped ID leak when adding a
 rule fails
To: Jianbo Liu <jianbol@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thank you for the review. I will update the patch as you suggested
and send a v2.

Best,
Changyul
