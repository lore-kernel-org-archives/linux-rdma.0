Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712697;
	b=29edEMgNlNGYtWuXXmVbPV8FM1uZk2j9sFrSgPhB8MGd0Pq6p6y7R1hit81fC2aoyLdQ
	 bLR2AmEWEBK5+X0piA1vzHgQy0DdGocCOA3suiPrJPP/nqXTn3mB7E31+5EH2N7ESi95D
	 RqVEyt47hsWlsGlZFtyzGK8a0uXFCf3cmpDuGV3fT/PB+LLgg7JpXXiLnByCaSs2cUbtN
	 /2F5Swu0GMHU1JP7sTejF4RPd+isKuhSRbi55Lv8Xennha9cHSQk9oX2lbDC5QCtDWgzx
	 Rh8mEWdwlvQPGgjBUmEYRhI1FFDGDLOcWGQnqw+3Xznfia59fFSdsyYmEGGOdEI91Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712697;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=RHK+oDroh+BWIdQDKlDOU+2VRgKkyUtO9u0OdXOwLJs=;
	b=LgMMv5u1cUfGuW/MbKwCZh1EYLnBIg9ZuXqtIVridXGX12pcrrbX4u/NGh1zKF18Mb8k
	 alsLkkUFkmePrxd+KJB8OC1pdx1jaEBvhGNKhzjzWKhosdxahuj052m6jQnGnLASa4RvU
	 TUzoZA29DqHdWNl9RxIVEvIcvkKpFPRICxQRNp32qddWrbz3uA6Ri9oQeXh/40X0meIm4
	 vk3bW6sI/v5VMslyxi8IkJrAVR+GiiHrXOiyb568CUpE6Y3k2HpAJnpo+t6sV01M4Jeli
	 Mo54X5y7GwaOzXn7i6/BAmYYNivp0h6jsVsarMJKDUTyI3b7f58Ql1B+z9HJIZXRKvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=guf6ZVDm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4663606A889;
	Sun, 15 Nov 2026 03:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=guf6ZVDm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E1D1F000C4;
	Sun, 15 Nov 2026 03:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712696;
	bh=RHK+oDroh+BWIdQDKlDOU+2VRgKkyUtO9u0OdXOwLJs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=guf6ZVDmwaky8SEJp57VkXtN6Ss2A0cMWAFtCpeJkNgcuac1a0hgIhGyT7sas1KCS
	 1tXHkr0a09hmP/DodxQD7dfLH6N69ho5Wro6/JB0OeDs396wIrERLXi6qHFWZZ6Qjc
	 LoAel+Pp780j4ZGXc/H6v4iWnGWrvKjc0zcfsStIVQqKSZsfK2fHoWAbR5rsCifQSX
	 vSZ6ovuAVU3mnVw1UtlXD3ViRNRDkNQV0UCdX6rLp+bcyVAKdbnpzhgU9Lq++VvkyB
	 AQ+EJIpRrTQ4Yk7HRxxPCodwE5kA2GBr1TP7qwyx9U/YFsb2IE51b0x6VqyTapRsBY
	 r7Jze/vdNp5/g==
Subject: Re: [PATCH net-next v1 04/15] psp: add support for socket-less psp
 associations
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
 kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 martin.lau@linux.dev, pabeni@redhat.com, saeedm@nvidia.com, horms@kernel.org,
 tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 03:18:15 +0000
Message-ID: <179471269504.2199510.18115986956046547098@kernel.org>
In-Reply-To: <20261111005533.6436-5-toddfreed@meta.com>
References: <20261111005533.6436-5-toddfreed@meta.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message misdescribes how keys are handled by the
  new socket-less association API.

--

psp: add support for socket-less psp associations

This commit adds a registry of PSP associations that are not bound to a
socket. Each one is either an Rx or a Tx association and is referenced
by an ID. It also adds the rx-spi-alloc, assoc-add, assoc-del and
assoc-get netlink commands, which are admin-only, to manage these
associations.

> key material enters through netlink and is never reported back. no key
> is stored for rx associations, and users reference associations by id
> and never handle keys

[Severity: Medium]
Is this paragraph accurate? The code in this patch seems to do the
opposite in two places.

psp_nl_rx_spi_alloc_doit() in net/psp/psp_nl.c returns the
device-derived Rx key to user space:

net/psp/psp_nl.c:psp_nl_rx_spi_alloc_doit() {
    ...
	if (nla_put_u32(rsp, PSP_A_ASSOC_ID, pas->id) ||
	    nla_put_u32(rsp, PSP_A_ASSOC_DEV_ID, psd->id) ||
	    psp_nl_put_key(rsp, PSP_A_ASSOC_RX_KEY, version, &key)) {
    ...
}

psp_nl_put_key() emits PSP_A_KEYS_KEY with key_sz raw key bytes. The
rx-spi-alloc doc in psp.yaml says the same thing: the key "must be
passed to the peer out of band".

psp_nl_assoc_add_doit() also requires user space to supply the raw Tx
key bytes:

net/psp/psp_nl.c:psp_nl_assoc_add_doit() {
    ...
	err = psp_nl_parse_key(info, PSP_A_ASSOC_TX_KEY, &key, key_sz);
    ...
}

So user space does handle keys, and rx-spi-alloc does report key
material back.

The code only seems to guarantee two narrower things. No Rx key is
stored in the association, and assoc-get reports only the SPI.

Could the commit message describe that more precisely? For example:
"the Rx key is returned once, by rx-spi-alloc, and is never stored or
reported by assoc-get".

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
