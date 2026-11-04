Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823280;
	b=zEWaDPyoDDVz1g0gmipbHt79RXfLrujL104Sc5eD/N8iG+NPeVlJh1lfQi6ICMczsR8y
	 5ZWxPNw3Yq+drF7WRwAQ/FF42A9mRd+hWOk7XRBOqjgM1PBNh7Ba8fPu40uxDsj5FEwZn
	 R7sZjUm6RW8dRyBt1EX3LyC2XlnkRyFKrrKD7Y1JeI8epnD3Wfnk0Rbv9QxIa3DhuIpOw
	 hMaSwpVISZOLBnYjzOI5z6kmmxzkpiI/M+hgSZx5g7RJHoEEX3IfFoRikNbkyxtO0NwVM
	 vYlmfYTPj+IvBk5TKeu78VxoM2nRMmJF93tKZ9yboz8q8n3ll32h3DE0v6DsYucq9Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 From:To:Cc:Subject:X-Mailer:References:In-Reply-To;
	bh=nAk9TdoYQsbnhW9OiR+BprvysYmI/LWBbcb+XpKe3i0=;
	b=GqBw5+CvxT/za30I7QxI7Xm66upchHKSflLprVCFYh08F0C+xvcwcrT+q5ZWM9PXxzQO
	 D/r5wmBIzppRnRi5ZuegjGd2JZ4tUeRpBcKmI0X+fVKwxMs2uRpM4t56Hs7/QBwCHcxGZ
	 yoRPE0FEtU7tcAC29yXmabMHo5+/f5V5ToG/3gvhSiHRYW8FYY/8z5F6ics6XghoUqIQv
	 9kdrIBx19nTc//ELs+SchuBir3erushthi+nT7fi117uoe3MlP5I/0ysOXZKvVR0DwfRi
	 yvhTQzGiFkW7DjWXQps6gN8nPkOKW/QKoe9HjYomB9PFL3NIxqL7H5n6Kmg6YnSzmpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ql+XRLib;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038C260B88D2
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 20:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 038C260B88D2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ql+XRLib
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so437080a12.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 12:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793823279; x=1794428079; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nAk9TdoYQsbnhW9OiR+BprvysYmI/LWBbcb+XpKe3i0=;
        b=Ql+XRLibDWnQ1LnoQjFEX/qf72hQkbUy+kGN/fXTX2FCPHDIlqSMYkBDf3lVI7MaKM
         VUWVMULjccrZBJ/djTGNKLVIVDpRmRhcEZUUQBwZK4+Rr8mO0+Bi0mkZfd2ZHBPpudVQ
         EPZbDUg7TiomNlcc7z64bbg+e4EE+2sg2iMSx3lmLZVHDo+GZSxXWifh1/SaayVPnaRp
         fgl3Wyi2yHuh+5k9k4PHZmTk2AbYt+1hHwsaY8Jwj4YkXCITgQsAVWUFq+2ocr269ahq
         tZeFIBtfeAQ2FlkWYd0pHUvZGR0OtNpSGdz2nBviXUv0PFsroYvJfhjYOzvU4/UdckL8
         DAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823279; x=1794428079;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nAk9TdoYQsbnhW9OiR+BprvysYmI/LWBbcb+XpKe3i0=;
        b=KxTFElyUytifPA5LKzvabXckN/eGW/MAb6NFdEi4gAu+KmkdHb5EF4n+2x5QgW+itu
         fXKE/3vcuyrT+Hzg8v2dtFgaurrI1PeMnSyd6jvuJ/6C9NJdYbf04WeS0CXDH/+KJJ44
         0NG8COJ00nVQTIGX8Oa8oNzR765Z5Y8QVUczj1i1zwAPCj09+H/jG0WXIkfTRgKO+TCB
         eFcJakvbAPSsfSi+yvYc5zBFcAJwysF0SO07YfwKR+Jbb3KvthiGyiuWbGAVPRAqeCyT
         6i9xMwoCms2l5FOUzYD3ofJIb7mYbADRjEh7RSqJqC1GicnlgncBnQlLQ2Bsrnj8UEts
         c3Lg==
X-Forwarded-Encrypted: i=1; AKwUvBzKRKoh8s9DVq2xCeMVyvGCfxWOXPLHXe+OsxTtgPqVnmP9ryN7RhIHFgjyVHryUMWjfX5C6ekugpTR@vger.kernel.org
X-Gm-Message-State: APuU4Z/qcKatM6kP/vG2ombcYAmw3eMp5TQ3PxJhjYIE0tFYp3zOVSXz
	p2ZET0zyiDk1wUpwyVYzPp3DVY42xr/st/sw1lHbhzi4kAYEOT0U6lHs
X-Gm-Gg: AYBFou1WWB5FO2palHFSFKapaKhNsB7w5TyzZOcIBRGQACyEWEdahbxw71whQnzvTXV
	AHB8LnR2EWHgVzJKXpJ9yF2w1P3CSwkeTMLD5RvfbigXt+EdVxnYsC79QRwU2WZpLy0HNS2W3lw
	UlW4d0t6/5IheDQnoGsH6RYRO7TjaHtZYLOH7OWu7Tjs14zZMz5YNUR1iDAnLg7FhXZwOipuIyG
	P9PWZ4wcFcMkLzxg1UlwehdpctP4A56MOvnuLPKToO1X4C32K/oHP5gTCxs6YzsAJPqUd2uFkzs
	49q8Hea8xFLzzTVFj8GzX8z1dnW5CuV0et3iq1IPyvN6JSoPIG/0W6Iwjtgx7G5H64JbyHlkLr+
	JZA5YrLQ3BgbBmMqLVIqjA0Jz2GQENViskCNSxmdB3H7jFQJbezxke1H2rXzzeGh1KMpuM5v9tc
	s/xDbYUeeD9RNfh27VBhvYaPLGEQd0fgFjzYV8w/9hZRoAF6zU1UyhJvcnUI1bnt12sTzXFPPzY
	9CmQfVxh74gzrUWwT0OnanSm+glxOpMe+R/ZCxCH8/LhZJ3DaYg+vy2Lm2+7rZd20r/9p55b9Qc
	QUOpiLlgNGsRa1LYHvdysw/xhnP6iVh+7cpFhj5yLm2990WxuQjTPFynGwUdFsDih+I9JV47H+9
	E24OtCh6dqnWXI+51X1l3XRXcLH8dXgek7T8=
X-Received: by 2002:a17:90b:57c5:b0:3ac:b44c:2d84 with SMTP id 98e67ed59e1d1-3ae897cc815mr14967216a91.13.1793823279118;
        Wed, 04 Nov 2026 12:14:39 -0800 (PST)
Received: from localhost ([153.61.198.245])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b094ce9f65sm2992245a91.1.2026.11.04.12.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:14:37 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2026 20:14:36 +0000
Message-Id: <DMMPA4SE5V7I.BQOTSW259XNA@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Antonio Quartulli" <antonio@mandelbit.com>
Cc: <saeedm@nvidia.com>, <leon@kernel.org>, <tariqt@nvidia.com>,
 <mbloch@nvidia.com>, <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
 <edumazet@kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
 <daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
 <sdf@fomichev.me>, <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Prefetch packets of upcoming CQEs
 in the linear MPWQE path
X-Mailer: aerc 0.20.1-355-gf870624f6c37
References: <20261103235823.536706-1-antonio@openvpn.net>
 <DMM0ADCEGAAB.2RFNF1ZI5TGWK@gmail.com>
 <f4bdb8b8-45d6-477d-bd7f-4ca4bbafef7c@mandelbit.com>
In-Reply-To: <f4bdb8b8-45d6-477d-bd7f-4ca4bbafef7c@mandelbit.com>

On Wed Nov 4, 2026 at 7:46 PM UTC, Antonio Quartulli wrote:
> Hi Alexei,
>
> thank you very much for the review!!
>
> On 04/11/2026 01:39, Alexei Starovoitov wrote:
>> can we prefetch 4 strides ahead without the CQE, like gve_rx() ?
>
> Yep! I measured your version against this patch on the same system (one
> RX queue, MTU 1500, mean of 3 runs, gain over stock):
>
>                                     v1      yours    yours + shinfo
>    UDP 512B flood, packets/s       +39%      +35%      +36%
>    TCP, 1 stream                    +7%       +5%       +8%
>    TCP in an ovpn UDP tunnel       +36%       +4%      +34%
>    XDP_DROP reading the packet,
>      NAPI CPU cycles/packet        -38%      -45%      -32%
>    XDP_TX, cycles/packet           -35%      -30%      -33%
>
>
> It matches my v1, except where every packet becomes its own skb, like the
> records of a VPN tunnel (ovpn from a development tree here).
> In that case I got only +4% instead of +36%.
> Dropping only the skb_shared_info prefetch from v1 gives +5% there, so
> that line is the one that matters.

Thanks for the benchmarks. Glad it helped.
