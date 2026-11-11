Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794433936;
	b=dvBPApLKlJ30PDRFIsa+hl2xo2Qs0pexLWVDz/j1bnscU+zjwGxlwriP9YZ2IWiqQfEm
	 3wB8a+pi+31RYYlj82QyJYGe48VaAqh72VhAbTu8bxlaXXY0Vm2/B8ibjWrXNawbT72yu
	 W8KknxKElr15GvpfP6K7Lbckcj9U4hrj3lWKDnCaAv+oDxiltHjyv+TsBfnXur56r6dsr
	 M2nL4nLGfgs6zNJxFMOhZHNGsifQshOil/2PXWDGtq8nZ8/f48YytnjjAlxiqVlznntvE
	 fC9xjxiZjOzDrgN2hMjEr7sk39SRHBGn9uubfs4Er6mZWrud+OHEJ/huLOid+vhvfkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794433936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Gi11Qvl77A7lJFoMQdONv82mizaQFstGPpmtJnQoYZ4=;
	b=hK0r5DJILEP99wXU3OLUvsPeiKCTB52874EspP1agllQpC2EvULYu1zzMJF2nBtTqk4b
	 3nhDscdQAUrwlpFKuvrZ6HwGGiG7PMtCdoEQBM4T8Le878T95a0fP5h1ywI9G51FGqELA
	 evwI3IzHKiy/FvWfdu6IhzdW2xS+P6FqAE7BIjegsLS1YD4zAy8xfoDkgShjRIPefB84x
	 w9JTBLfZRCBB6VlpXp4bj4kv9n/0MzhjJ89XvVn2dlC/5AhUdRE7yyQQ8htEGDXt6sq6t
	 g2oDt0g3U9pxvFDzn0kGirBgjh4eQj3rY58OXzloZ41tm91AV8am7lMGZcqECnNATcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LVadYj45;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10168606A324
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 21:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10168606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LVadYj45
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so1801821eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794433935; x=1795038735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gi11Qvl77A7lJFoMQdONv82mizaQFstGPpmtJnQoYZ4=;
        b=LVadYj452qYWKXqudUfJYP4vTIXJJ1dd3U7RzKuzs6NI9h1XPCVOlLH2NMyOw/fSpE
         a88EhfciP9x3tgYLLbGHfZo127HjqFmkiin6KdIsTfgtrTwkMzRTwMGranMmPEkRP4af
         1fgYgf7SIEfRGRKqH/+rnq1nmaqMdDGChDU/8bSAhmdWZvQmWYxe9hk/nKnyh+hUXQpS
         RuZz/rfJupbQipvOUhYUOt4z/uqT3MMyj4Fxlml3BRqUtntjB8kfTsiEqHI2gsRKou6J
         mzatv8neNrpup03S/lOw+mLiQnIi5+xiU0V2Sh/BMvr0RUOSPeWmUcV0x7Pv860pKpje
         f9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794433935; x=1795038735;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gi11Qvl77A7lJFoMQdONv82mizaQFstGPpmtJnQoYZ4=;
        b=fLBIR/Z8h9M3x78VpFtuTBCHYn+qTqoPLUYsRGDzDj5+xcr+Zc0MZc87IMo6FwHxDY
         bjmxcn3lzqir0AfvBw3w9nbV6Y63bcLpzn1lHtxnJIH2fELcXkeS98dkybxCtqy89G8y
         9ht2WM+xt+xMH5UhQUr5T7pcT1rp96hBhoAp9YjZTLhV4yUbsA7lv5YyS1l0Q7/hQseN
         32yd3V1bdl7gr/jFZDi2f4GJNfwwwdGF+IGdRVBWlraFNyO2qkUnXX/Ne29d1SEwFwXm
         kWlbN6N2qrScfm0iGhcirjwIXaB+dQD2Q1ZCMMth7VcEv5NXeVmP501K0eqFz+hbLBkX
         fFbg==
X-Forwarded-Encrypted: i=1; AL+hErEAIamWqzUh4F3i/g1j6EWkfeVwfKueYqj+244OiMaryRD2TU19pTyBRRUd77VGlA9ZTVvUrgBgmOrd@vger.kernel.org
X-Gm-Message-State: APuU4Z/S1IP73JZ+WcDtJOzXYU/uWKC2AVr1zKhoKSZUhKk0EZ1orG3W
	ZfkX6zQ5Udd6NBw4E2GF5GrgdJvjlwrF6VlNmOK59nf4fAMY0F9khU5K
X-Gm-Gg: AYBFou3X9mcAdVKVKCzau7WoSUdyBUZIr75iZT8Fp2mSb9t6qCIsmL8VhdH+x7yOHTM
	EgCjvJuVozlL91i9bCYcQJ9/hJB+ubQ1mqDmMwqWs60OvuYPuxWzjtZqEzbn0fHBIh2RsutSmK8
	c7KlQ1t9zGw3LRd7T1QwnviPVMsWxR/WRRsPpUx0Tq8U/2P1KI7Tl8hutOs9ngs0wcfgqowGIRz
	sk5PmFj334/mhGhGb6vvMPGZzBt+9W1ANw+P97kihCmpOBXtWdOj8BwanlyhG9JDrSGmMvZGbsa
	BVZ0OzxZFCOrzrtHZz2G6pvGD/nt9SIWAkLdu0zyGFOpmfB9GCxCR/26x5xYuyh+4xObp7cFw8v
	kEbDqAc+iQF3iQqG22hU5oARTwqjCnWEWFVxBdTVGRaXCl0yRJ8TyzluvudzKJhVpEQIhAorKK7
	krnAQkOrmGr6yFQ0BoW6eKYYxZgQh6IaJYofL8WcehyZ/Jmq2WV2YebtTSKq+acc8nkmsUKwKF3
	1m/L2HETxVgz4FPWh39bq5mPP8Cn0XyMQ/jfiUyyHI8m3iBQtzZNQG5cZTasHvMB0dkVNhiASdT
	Hqf01cxRhJX7Mm0aF6m89SI=
X-Received: by 2002:a05:693c:894c:20b0:36d:5102:9974 with SMTP id 5a478bee46e88-3768327e7ccmr4031936eec.2.1794433934007;
        Wed, 11 Nov 2026 13:52:14 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:44::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bf3e18sm38761082eec.16.2026.11.11.13.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 13:52:13 -0800 (PST)
Date: Wed, 11 Nov 2026 13:50:20 -0800
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	pabeni@redhat.com, andrew+netdev@lunn.ch, edumazet@kernel.org, horms@kernel.org, 
	corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	michael.chan@broadcom.com, pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com, 
	mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com, sdf@fomichev.me, 
	dimitri.daskalakis1@gmail.com, almasrymina@google.com, dtatulea@nvidia.com, 
	bobbyeshleman@meta.com, asml.silence@gmail.com, daniel@iogearbox.net, 
	razor@blackwall.org, leitao@debian.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	leon@kernel.org, narcisav.kernel@gmail.com
Subject: Re: [PATCH net-next v3 4/9] net: devmem: add a per-device netmem TX
 frag size limit
Message-ID: <avTiZVzjvMLQjnJ1@devvm16445.scu0.facebook.com>
References: <20261105222058.944293-1-sdf@fomichev.me>
 <20261105222058.944293-5-sdf@fomichev.me>
 <20261110143615.05f9adbd@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261110143615.05f9adbd@kernel.org>

On 11/10, Jakub Kicinski wrote:
> On Thu,  5 Nov 2026 14:20:53 -0800 Stanislav Fomichev wrote:
> > Devmem TX frags are bounded only by the net_iov size, which is about
> > to grow up to 2MB, more than some devices can describe in a single TX
> > descriptor.
> 
> How is this different than normal zerocopy Tx?
> Drivers already have to deal with long frags.
> Having partially applicable limit seems like a bad idea.

Thanks for the pointers. Yes, looks like I can drop all this per-frag
enforcement. But bnxt is still broken with bigtcp, will try to hack
on something separately (queue stats/etc to make it actually run tso.py)..

CC'd Narcisa (synced offline), unless your priorities change and you get
there first (or I get carried away by something else)..
