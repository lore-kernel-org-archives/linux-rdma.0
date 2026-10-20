Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792524512;
	b=OtmnMXXpNTyvNlOD06idvOllDT/SiPWC1v6d3pKhpVEbZNEbXSwnhfKeu8IXab6MCrzD
	 5CJbLgpnEMOvwXmx+55xLb5ErkRZKeDemVz4k1v3Syxqmn6Dzwwkm4eZoPAgJP5jogYvn
	 LLpKDz98xcIh1A09PyMcgB7/V3jAxWEdwVNgVyAUMmk4lNn5P4BzalziWzVKezLwWGiyQ
	 zT7bMURUs1V+TSF3UKg+s45YuUXoi6HKN/jjT7D4cvgVyHsCqR59dQdTRBbbT/ptQy2Ft
	 u9ElQJptGlTSfDb/lhWmiqc9p8avH0wEdHMicGTb99/gWwWZSBIy7DILvIWtt6ZcJOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792524512;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=glN78Ha6iYAaTjSlQ7NRgUJI7MtKCh5ZiX7TaERIYRI=;
	b=3FNbwLt/0u4VWlqAzJQKo4U8PTlAWklVY0dnwjPjyT50xTmPNajV1HmOi+lHQ7rL8s7n
	 Q18qt7lND8xSqstpHgcImvAEoeg/Cr/VG8z1DnoXrBVH9XBXuKY3GmBLDeAYw6H6GutKV
	 xDb7V9xogP8gSzBG4KpJPXPe6C4Su40FNdaM4FqyKTGfTd2d0V32n7rF/ba2xwbhCkD7N
	 iwHAdkzjpGai8+VRePVfrpTm4zT7FbqEGPhg4ICUzLVM3J3WnXFO6r4svzc84tJtWUA+m
	 Ar/5QSJtaMK09fBnm7mPGTyh71sjWgJb6P/bYTIKUE+29hnV9YXZeZLQ6CqMgu9ukjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjwUbFlG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB4606A319;
	Tue, 20 Oct 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjwUbFlG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AAB1F000C9;
	Tue, 20 Oct 2026 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792524511;
	bh=glN78Ha6iYAaTjSlQ7NRgUJI7MtKCh5ZiX7TaERIYRI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PjwUbFlG6w1Q03uPZWbI8v+utMR7Yli9F7whhmM4fI6a2zideqpDg/eGl6hRu8/hh
	 YF30sYMULcuiXPUccsBtKcanqmVT5iC+vG4uNx8opy/wqB10cn/Kt52pZoohJRrUVn
	 qI/mk0siz/w/IILrQqePAdpN1A7Gv6QJIaTRwZyHyIqtsMjYtp4Xl0ToOalD/vzimw
	 xOGwEFJvyAa5UZw1JSl7wVtHd9Qq3ElEiuD5gW9SPPBipNroPo1Cz/LkqcF57nSO/+
	 DTg5YHRw8vi8eswAYjp9IiYq4mgFFg5N4mOXx2dpBq4/hjIQnO99EyqnnuGMj+lt8I
	 gln9uT27gbrRg==
Date: Tue, 20 Oct 2026 12:28:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: netdev-bot+sinfo@kernel.org
Cc: hexlabsecurity@proton.me, "D. Wythe" <alibuda@linux.alibaba.com>, Paolo
 Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, Dust Li
 <dust.li@linux.alibaba.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, netdev@vger.kernel.org, Simon Horman
 <horms@kernel.org>, linux-kernel@vger.kernel.org, Wenjia Zhang
 <wenjia@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>,
 linux-s390@vger.kernel.org, Guangguan Wang
 <guangguan.wang@linux.alibaba.com>, Ursula Braun <ubraun@linux.ibm.com>,
 linux-rdma@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>, Hidayath
 Khan <hidayath@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [PATCH net v7 0/4] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Message-ID: <20261020122830.5ddd0997@kernel.org>
In-Reply-To: <179192256949.160550.18282620239378164781@kernel.org>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
	<179192256949.160550.18282620239378164781@kernel.org>
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

On Tue, 13 Oct 2026 20:16:09 +0000 netdev-bot+sinfo@kernel.org wrote:
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

Please reply to outstanding AI feedback, when you repost please make
sure this is answered in the cover letter
-- 
pw-bot: cr
