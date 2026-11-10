Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350178;
	b=4VQiTLrvPo3XemrYEZcBuqQw7d9AmcVBnKvICV2+tNRw7CSynuPWtXl9g3D+c74YcUKN
	 9WIcVQ1hmqLHTcrEYP6tsCe80ek7rb+Cf2RXT3WEwHXK4BE7wQew5A6DsE0e1RUHlTBtt
	 B1TG43YGEHeUP0ulF3mH1jkJP2QyktVR2hpzRixApU+XT1z/cm8oVV33v4M6sTdziuh3y
	 RIcCf5BfbSC1eDPJ/QqawP4ZSYf0LU7831VvjFBISgr63g03ZJaiNbLRcFdnlCm8LDOvg
	 elXmkDWHG+W5p1ZEgDxBOWxh79we4cwfqIoxjRUEMs6VWziTgyYv5yeeEsMQNH8H/jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350178;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=GFO5SgMs8ReKJKikz9lkRPOPcMKY8LAMToxS0clBDck=;
	b=ndnSHi804GShSnA3099AOjO1l0rFeuSL66dWmukowdVeUyGMqJxdsKV7pgxh/xmbTsq0
	 nmuGG3Mq02EA5QM3Y7IaDfHHP2Go3dhPO/bEKW4gmdYYPOTNCWpHmkKu85QVlTlm/+qTs
	 zhT9O1DOxId0CHG2s2nkq42PXTlPF/QlRrhksrgYI3VvnXpIQaDz1gXYtlqlO/auETtSq
	 gCA584OT0Wem4K+hOjNTZxfx1VialICZcy3JtGYXUWcyNictJ96wKSsjm38B4hVznV4it
	 QtMikwjtTeUqrf9ccdSWGi2gUvrdwlCAgZ1GW4hVf4l4pE+RRnWbbD2/mKWzopXObjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E1bUdJnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4B1606A31C;
	Tue, 10 Nov 2026 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E1bUdJnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6731F008A2;
	Tue, 10 Nov 2026 22:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350178;
	bh=GFO5SgMs8ReKJKikz9lkRPOPcMKY8LAMToxS0clBDck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=E1bUdJnQlEXRrR7QwKxM8f/74VboDlP7DcSq6c1FP0RZH1JDytqc+nluEKFsPs84P
	 E5umCdkWdxo/6HC5b3qc2cV/OOBCM1ink1Ul5+LiInafa7lCc6yPUSnHhtS0XrEw1Y
	 boeMQhkDwhBDC/foVQuFvfuk7ye9QAzqJmvFaiQk/BoiTwH9W/fIrAyZ4yqCQT8LZd
	 t8mUTO8JYNjEm0TN8w/lwk86hvlBuDY/DMqWXKGuxcCaigXhMpoXnLqrUcdlDki6zk
	 r/t89iiRwxbB6kyh2nW5pIq3qkUN5EbS4cX4LQPIAuBeXfrps36IaCoVj3q2MDCKtg
	 8a/W3Onh4mYow==
Date: Tue, 10 Nov 2026 14:36:15 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, edumazet@kernel.org,
 horms@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 leon@kernel.org
Subject: Re: [PATCH net-next v3 4/9] net: devmem: add a per-device netmem TX
 frag size limit
Message-ID: <20261110143615.05f9adbd@kernel.org>
In-Reply-To: <20261105222058.944293-5-sdf@fomichev.me>
References: <20261105222058.944293-1-sdf@fomichev.me>
	<20261105222058.944293-5-sdf@fomichev.me>
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

On Thu,  5 Nov 2026 14:20:53 -0800 Stanislav Fomichev wrote:
> Devmem TX frags are bounded only by the net_iov size, which is about
> to grow up to 2MB, more than some devices can describe in a single TX
> descriptor.

How is this different than normal zerocopy Tx?
Drivers already have to deal with long frags.
Having partially applicable limit seems like a bad idea.
