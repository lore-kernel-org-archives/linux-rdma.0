Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823006;
	b=eCW33GGTONzpVNyeG9OUCCVlPRhhlqRV1O6ol1tmkTMWfRlC8IUrAb3Xl+nFTgu1Nozd
	 sYeQU4qAUIbdQD78ALeER2dR+CIkAj3kTHXo9CfirHHM4raVfpi58vwyY8dBL7XKLFCPU
	 ycZnL3z46ZtKJqdg/D6r74+vaiPH10nNc1qQvDrMKksJAVDhBb5p3jGnyvMeF7msT6ZzV
	 noeue+iJTQnxjJvVZgxSRS531rVIpB0ycupM+YHJvqUZpjbM3QlZrMZ7fapMR6fEYrHOS
	 kV6gLLP6P/GDVvPbudewq0JQauqtY8Z+OOZH0F3t+/VVfHLqva9X/oX1bbtRGNildCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823006;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pbB/h7OcDLTENZAMlqrgPHDqleGuLS+XSh/+4bmYjVo=;
	b=bFSw+tLGr8XbFE+c/0YTQDflHhwwRW9cQE4+HWC2llOJa6PNtP7CZjkglU/4z91tiLW0
	 6ondhZA8w7r2T8mAHdpV53MTF2NL313NiTbA7YExbY9s7F2DyO+J05JtGFAsWxVCAx6jB
	 Z7d8xlf9OOONiff8WgEAemE8sdhuGgn5KnnVCWflX2SPfqzJ1uRhJS1Vhycwfxk+wXKp6
	 JpjK08yO08ch7LQHK+NgR4mV0LpvFMo5PsPRNB56W4h416T9YDYd3mA9MSK3YlfqUedvs
	 AaventAJhjPlTPy3ug48ZOcl61XhHkXA1AcsgrsT4UnehE0CGhnVa5LQJyI52ZE3PjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pAmB6tB5;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52945607C0AA
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 20:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52945607C0AA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pAmB6tB5
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso9989665e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 12:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793823005; x=1794427805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pbB/h7OcDLTENZAMlqrgPHDqleGuLS+XSh/+4bmYjVo=;
        b=pAmB6tB5L5Q0sXbpgw5MAvTI4uEVXOApuJPbfWOIyoio0S+Pk3ev+Xx+LtSaVDmZTb
         UtFs6xBq+HXY5ygUQ+qI7ayP+uN7rCJtM8Qo9UVtZesPJVPeKvFlcvws5jR2/iHFxv8Y
         veQ4oIX5N8YmBuVrhiXgkHYskpbffM0MwfPIRXC7NJyGDG5PAu/N2qWJVRrIBA6aDEf6
         liZndmGbC429jfE5e+Md/TpWVIyFUGja7Frb7Z1IKMKT4ruePVenI36Bw6OzDbXmKqlY
         AfTex7dzu322hFIm/ozi7mn3h55E6OP8ewbasszG/05oRQBr6/fSrgczdbozEEt+dWBj
         iLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823005; x=1794427805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pbB/h7OcDLTENZAMlqrgPHDqleGuLS+XSh/+4bmYjVo=;
        b=G48Gjafp5p19n+blt84a3Qm+pu1VRbNhH9NtF4ze5VOmI7o8zPmWO7YQ3r0h/FqGXd
         6Xpe3W1iyTOeUZl7/UdQsAzao0IzFwbn+e+A1BJU69RRfjfrbtTDev/Kf5iUVSYfNu1f
         +d43ilIse+zd9o1HP0k09Y8qqtNriGU+cOvigB2/RsPxNt0tuzphhZncj5ByhNdCxr/F
         sxUgadIdmkAmVRQBoWL3bnxJ1EUd2BL91hubqLsvKiOH7O7qNTAYfJNguNKYMWGbg4V5
         RBEd/KtlENe59yIzqEnijdBejOjiBP6jzerGIeAl4rf2uxdzf4PSplIdjzgsWASyyEbz
         +gaQ==
X-Forwarded-Encrypted: i=1; AKwUvBz43oFgKAxabcLjUw2fPpAbo/2HtDqshI6+28EiZWXL1xsJK/btQlIdkI8ItBMszp2Q9VpwKJdwGRHU@vger.kernel.org
X-Gm-Message-State: APuU4Z9JI+pvW4V1AMS9Cyu2F9L7W+eeTDjCWso2IltBjGDdW+b1ZMU2
	bI3TbjqrqA8jVxbjU1HOfY4tP4SCYqmav+B9Vwct3c47QwXTjP6QGkvx
X-Gm-Gg: AYBFou3GQAYDm3ofoFTjTTuhUkpjssOFZw2sMltpDrmTjOPDrbNqn1swaRjXqCbT0bh
	sCMEpH/Jzb11/yMXINstmKOhe99wCdy60fMfQRLn9Hkf9qJfiDOFRPNd7sQoz8vlKMJ2gZywwu2
	XCwLtV1h7T21pCoRRT1wUdv11jBM7UE4bdbzRlo3ArMM5wZWq9pBSedMtg7uU4M0AyMjx8rQYCI
	/LyCSR4WOrsw2tNpQUXsXFjvpO8t50z6Av4lVPwGD6oQn7SdqL6P/5loeDL48hQLyXCHGfKgf6m
	1rHNuF2jksGlvj3OCJgxOnExg0vEfA8M5Y5qCQvukSCIIBdW1dhbXz4vnqQqPAukHxgRty2+BKt
	PtlJaa4g1me3Qg++WVZZy3kfev6PPTbTTRcrkp0AVMZUuJNqM5dBfLi6UQ6MOlkkJQajxBxU7ny
	XqJv6E6DXbqCxmyIPREg8W5vtB7Bg7oIKsECWGhmbDlcxh20kXqU1pGenmCFsvXW+wIV36MFMZA
	cFYjDwHRUO+Vuc0QaJIbmxBc/GYeXvL3U/xgAT9YlHCocg5NefzqocunfyDXNaidDA6Xts2yPBe
	vK/+9pl124MQuBO+aFuaQbqW3l8EYthuLQrNZudfrXcoHkr9s5ZfE1z+0oC4aN2ECdGYKW0awTL
	ws6F3f/ctIWxxzRx7o84HDlH6a+kW9r/cEVCVSR493dpGOZM=
X-Received: by 2002:a05:600c:6216:b0:4a3:5aea:21e5 with SMTP id 5b1f17b1804b1-4ac1737c533mr377961885e9.9.1793823004484;
        Wed, 04 Nov 2026 12:10:04 -0800 (PST)
Received: from center.jhjvjihww5qejoy14qwv1cc4td.frax.internal.cloudapp.net ([131.189.143.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56eb4da1esm15954045e9.6.2026.11.04.12.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:10:03 -0800 (PST)
From: Orgad Shaneh <orgads@gmail.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Hu <weh@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Muhammad Falak R Wani <falakreyaz@gmail.com>,
	Jesse Brandeburg <jbrandeb@kernel.org>
Subject: Re: [PATCH net] net: mana: fix XDP_REDIRECT of pre-allocated RX buffers
Date: Wed,  4 Nov 2026 20:10:02 +0000
Message-ID: <20261104201002.2215474-1-orgads@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <autbwKmZPPWEj0Dq@boxer>
References: <20261102064324.806414-1-orgads@gmail.com> <autbwKmZPPWEj0Dq@boxer>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 05:22:24PM +0100, Maciej Fijalkowski wrote:
> On Mon, Nov 02, 2026 at 06:43:24AM +0000, Orgad Shaneh wrote:
[...]
> > -	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
> > +	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, from_pool, pkt_len);
>
> I wonder if it wouldn't be better to work with rxoob objects which seem to
> carry the from_pool setting?

Thanks for the review.

The rxoob no longer describes this buffer when XDP runs.
mana_process_one_rx_pkt() calls mana_refill_rx_oob() before
mana_rx_skb(), and the refill puts the new buffer into the same rxoob:

	*old_buf = rxoob->buf_va;
	*old_fp = rxoob->from_pool;

	rxoob->buf_va = va;
	...
	rxoob->from_pool = from_pool;

So by the time mana_run_xdp() runs, rxoob->from_pool is the flag of the
replacement buffer. The flag of the received buffer survives only as
old_fp, which is what mana_rx_skb() already gets as its from_pool
argument and uses to free the buffer on PASS/TX/DROP. The patch passes
that same value one call further down, to mana_run_xdp().

The two can differ. Refills come from the page pool (or from
xdp_save_va, which only holds non-pool buffers), so on the first pass
over a ring of pre-allocated buffers XDP gets a buffer with
from_pool == false while its rxoob already says true. That first pass
is exactly where the bug shows.

Using the rxoob would mean moving the refill after XDP, which changes
what happens when a refill fails: today the packet is dropped and its
buffer stays in the ring. I preferred not to touch that in a fix.

If you would rather mana_run_xdp() take something other than a bool,
I can pass the xdp_rxq_info to use instead, chosen in mana_rx_skb().

Orgad
