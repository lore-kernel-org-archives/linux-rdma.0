Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248961;
	b=wi/SCabp85DjXOwjItGn8delE/VL82nnGEWOsyA/Z55aoYalmebrXH3dXf/W4iq6H22t
	 Yk7NwNqEmZ3/A713Of9wJ7GSQjsKtYZqGO3xXD1ely/VOt3ZWbE50f/lVW6AiUX+0r2X7
	 bG/ucF66UH3/1BdZ57WShJl3q4iZRGpU+UHlKTicwINTAn0DvLamh8kOQ+eT+fDFessSI
	 qwqBmF8uqVJVj8I04sBa5wwT9gcUfkIKK9Ql9VjLJ59kbDAKJa8aohRfRlK8XA8aMyqFP
	 fBpBXD/xri/Bl1/Xf/L/dFRjeVpSJjj+RS5Kmx7ep3fmH7KqTtEN+cnTUVSFL+KRVYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type;
	bh=TyNlOaE6r53YabDf7NgKAHxeTjKkEmLPqy6LNOwpSOw=;
	b=HRPc9CiYLdHMHrfU1xJdTBEJCFuwlK4CPY0KFTx7vv0T9oWzCYl+1n8rsXHBa23EnO97
	 PV9H8h1S6fA3DeJtn0SGjjSrkizvnUM4CpAl9lVgjdqQY4bzZU64C3LDP0+DssvUDaNgn
	 Kyfq1i02U7zQT6C1hW+uFN5o7DYvwmhUhIbI6OLUVvEDKvbgStSv8I708YjED45Nxcfck
	 EA4Ch5Z7ixCPup19JmQOZZ6MYChbn1cX8ADz05/Kic40pWPNr7b1nFMaxS4EpAwZ5ER1V
	 iUYIXV5o/7+YXIp4c0TfOaiHwT0Grwg2pwANIYUhz+2/thfOdBkGyJnSwYTERweeIMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wVPmauA8;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC146070ED2
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 18:29:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAC146070ED2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wVPmauA8
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so721842eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 10:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794248960; x=1794853760; darn=vger.kernel.org;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TyNlOaE6r53YabDf7NgKAHxeTjKkEmLPqy6LNOwpSOw=;
        b=wVPmauA8OdLBNUi//iUcElADcRibZhBlYmRzMsqGWZwocRzhlB8pAEZUyTVONutmzP
         YHGl7m7d5gmKZ+kHy+amcdGR0AdGQnPC70uqhqLev+qT0zS5gLE0OQedk71PD93HuDHe
         d4AmF+8Op5QqLeFTRnHezx/ld31iyUN1GiwdR9gI83FoQB/p3kN+M6POA5UihECgoHE8
         nuCiIhx0et4FR8tdMwbyimQJYCdpUxlrmR1+YMHy6otayeUpxcz8AVkru0zzf6Ais/I4
         VVUtRfQ+Vg5feQX7YYsyKpySiIOvAMZA1iGgR5VhnDI5k3Uv8f3/btggB3XTDbZErZLZ
         HL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248960; x=1794853760;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TyNlOaE6r53YabDf7NgKAHxeTjKkEmLPqy6LNOwpSOw=;
        b=rpA1ePLSObeTNBvpHVK+pSS+oDUO0rQzAM30f+fg95v1choK7u1TZVUbK+hOG32ewh
         OvOzjgxiFOlnyW6P+vWpIHlMNK+1H7L42fwyq/JyFeHPEKz1CZK3UlOHb4KMi6hbR+J1
         iuhhchP6/RWwLMfl4XY14HV//Tojm6tfU54jzCplj/JhhLP74Iq39pa1CyI6NFcvJqbc
         lnbe3OicoceoVESw5Wnmn+S/9hNwfJlpBsgziUjSTbUgL04+gWKnAxj9yvhx8UQihRCE
         Qz+4DroTynq8XIpyOsHZ3+5zxmhVwo53XTm1V7zh+m/LJUacmWzHWg2noqtHNcpkBi+W
         L02Q==
X-Forwarded-Encrypted: i=1; AL+hErGkc7/tGYsVqgvu9HbYZMZjniSJJD6cOlcQ6aRucE5dS3cN96FnXTTv05/vKs4nvjoyyypGohWNuL/+@vger.kernel.org
X-Gm-Message-State: APuU4Z+cZrhdGccaA6JOdZXvf8+KEa1ZbWQQge4Kdi7AHZ+kGH4U0lc9
	h3LxY0lpyTsolIoqwC0T9qMQJiKrbCCmXb54KFQEWDy3yQxfMJIynorw
X-Gm-Gg: AYBFou2TrsQZehoHUG2z7RCwHTsDlevlylzwViUpkAKj0SJT0T2VWNPpXQxDAF7pJua
	mnvVl7JiRbiGEba+n74K1nQQ0Dkp+df0C03WgX6+q0BkLf+of7NxdMNLHYF8SxE34/6iqSmDg/j
	FbG1a/bgm9WbQ+ut6l/Um6Oftx5+bR/Nm33KOTFeSKviUYc7E7mX7gMb0fi+2CKYafs+gqz1hZe
	n0YtOriFAszW+OsNbnoQYWK++RjgT8tdvm5HyDIWHiSvcLwXKrUFH0XA+m1VnfYU0qY8eq72gNP
	eo1YwtHedxOTIPGNtNbDZujTldzGJ8jdSrHJ4CS1Oytdz5lqkrsBRjWbw7mw7j4BSYBFUeiL2yo
	ejwKU9BrNVahD2kGZvWPAv9TECnn6HLHGkTskEklK7DGadL1KUm7MYI2VUnwQxnd+AKEA36UzYj
	07whEw0eg5W7milDuFnKLW9FydBQcAczRaUJuqncBxk1PpRaZJKbusMtnaHsHtbBUC56sH6bElc
	7ghlncFejSFCU6WSu8PsjtA6vSJa9+nUAMSQ+Zb+tya0tQC9SdWWDyCKFqmOK4hraxEO60Qg8vO
	hq+mQ22fHFiEoLin0xOZ7b4=
X-Received: by 2002:a05:7300:e9dc:10b0:36d:3c0f:cc85 with SMTP id 5a478bee46e88-3751c82b5e5mr145592eec.5.1794248960011;
        Mon, 09 Nov 2026 10:29:20 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:41::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520512ec1sm99440eec.12.2026.11.09.10.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 10:29:19 -0800 (PST)
Date: Mon, 09 Nov 2026 10:29:18 -0800
Message-ID: <8025f6aed4bc33298e8be50280ab72e4@gmail.com>
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
In-Reply-To: <179418738174.994134.464817117967884735@kernel.org>
Subject: Re:  Re: [PATCH net-next v3 7/9] net/mlx5e: lift the netmem TX frag
 size limit
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> [Severity: Low]
> Is U32_MAX really the largest length an mlx5 data segment can describe?
> The commit message says:
> 
>   TX data segments have a 32-bit byte count, so devmem TX frags don't
>   need a size limit.
> 
> Bit 31 of byte_count looks like it is the inline segment marker rather
> than part of the length:

[..]

> Would a value that matches the hardware, such as (1U << 31) - 1 or SZ_1G,
> work better here? The commit message would need updating to match.

Let me switch to SZ_1G to be 100% safe.

---
pw-bot: cr
