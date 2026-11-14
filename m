Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794681624;
	b=WdcVGDuW0pyLHoFkIXF98xHJiYiyOqjeESYqJHP5bdSZUoUrZ87FH1HbwjbxnEF+bG74
	 Cktzcn6KY5P7/1qUBU9EBZMsLYCmgZ7YXcUriYTL6Jk6pp1lYowX1j6bLJdI+yyNTrvpm
	 GrvelwDpNxYgKc5iMGQfh8W9MeXBp4kGQ1bcxnT2jK0v/0A8cOvuVJ3b0TBmxs/PZ4yOM
	 MMsArVcuXu4QzaxXxpQEagNWFmmjEReBO10tCU7D8FiIvbgNY3T3pKSB+Zp/2TYUJVvf2
	 VHuf4XaVvhCIp4H84jB+nxQ3EQuD+/EgQa/gDDOCW20h07n/0O/uXXjbF+HmEOCXo9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794681624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=RDeoDvuqMX5CXuZ8DatSTgljbUzCp6t2qFD5+t+XaFE=;
	b=zEWcv7zUyXVuihOJtshdUYDzNkF1wTApjLr846DHpfGoxtOJ80Rq2QLz+A/+V4l+vYHq
	 IDEg3IH+CGVhn+Y3WPAhc19sXIkNtspmV6Ro21KjAAYl4l8wJcut0iow4fDCzrmeCKOsa
	 PMUOBm6Cp1ZvaGcPZWxctFjPTZBgp0bMQzcp4v65W8PFmTaOJC31ujLXhII/EHzeNpXRx
	 UATG7beNfJOU0Cm5L3fMUDHUGToPd7lfxeFJSj9Q2MNREJFd3K1W0RLxKG05swz38Mwy8
	 XmSa1p+Ly3lMPqvvJDGE32brAlBbwQkZ5hXuRteA5as0jlXTPcZYeVAPpLiWL2OPwgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OKQvH0XB;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924D0606A330
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 18:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 924D0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OKQvH0XB
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a06e79e152so1007867b3a.0
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 10:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794681623; x=1795286423; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RDeoDvuqMX5CXuZ8DatSTgljbUzCp6t2qFD5+t+XaFE=;
        b=OKQvH0XBu++VojD/u+INoAqGc3Ax0Cm7sYdvZeGr3L8gqCisEOw5EBV3aKep+umVWn
         an/nnKbxKy6DYbjRYvgu/fZ2SPbcgI9KPEl1Trd1mckq3R53F/E6Eaq3wvQbeeuu9l0M
         0r3nMj/ruEGEiipnr4mvv1s9NXN36nHgwxKsBDsYSprDn+XISlJ2s9UsbYlL1fZ36+YW
         A/Qnm1iUNoYEqgY3KOs/GSb9tQtZyGLrV2AnfoR1Y7B/pv/QjEJyAnpnTilMgTc+fpPP
         l+S5oKVA1wky3qlKOje4o9/IM6XIqLEcmeKmB1OmFo+lhyEmEARsV93Mfdv+LzfBQJk1
         QToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794681623; x=1795286423;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RDeoDvuqMX5CXuZ8DatSTgljbUzCp6t2qFD5+t+XaFE=;
        b=SOkZhjgUbwYavqY6uKkhKR0lyqLBlaVNSwIrmZu8IaW8f3bxyU9aLFHtTx/PdM2lRi
         m8yo9eO61Wno7KYvuLsXLorwFkPl9GUA5mzP8ko7GXjGhzGOQvAVdwkXIKvi2YPV5Xh8
         sm3gbT3Zc0rhY6EsgfK/tDv1xyJyZNa3Z72lYwx5LbCaod6iWtR7AiD8mDR1hd3JUJxb
         NsxcxjsnYz+PajSmFbY7lkaZd3tWOuKPCSDSNvk4inqzR7iUke07HZYvDXJ0qVXFq73x
         +Wpql3PXDc0+53EncSfaDHVAQwBPEnQymPHgVQCpkkxTJZiUjnKj6sYBuyRjuI/GvmGP
         zD1g==
X-Forwarded-Encrypted: i=1; AL+hErHd73reTyYvsOiQhqNpZoQHK5h2wUedcz7Moouci9RbvQzAc1S+6h+z2Sdl8kIvvdAUxFNNENdXaiRt@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZUb4rRROwQd7PW6CYo51lT5R2yg9xXKWys9hHtFbBjwjOCWnD
	AW9vFqKftn/DKGWjzTZt0asooS8RBp090ID//CrG6Dc2/xRywD1KwVdw
X-Gm-Gg: AYBFou1RWT2FoVBUrE9u/ZFOK96Vk4vqbVdBpiFpbewHJxzSxsiirdzTsEd7trvGcaK
	t6ZLK34wLdhN56QzrY5LWMjLjCwm02IsIV/uFhLXPNPVbHmm5Yp+fL9I0esifPPKho3y6kW94uj
	PKq6CDBa8iSUg2Xfzl6wRDXgQLsOu6uyiBndiDOUhf2ykUzvLuFbTLZC6ZTmQVgnPbSmP3NEGgw
	unwJJ8uNN9nxit4pYUXpJgjfW+jzmt7WZ0TWu9hebS8brQaoyckCj5zfEDNta2USNKNR4VYJisY
	mqmrXtR4g43GlQLil3khY684kw413OI1axiOc1dlB/1yvh6rDLtMmp1NHyyAeGgWrymrJOl5WlE
	A7R6U5Qq2vjpJePxjaUBWQpE0QxjxzgsrykmGUpeI4bhVevd+LGtVXDprWtO5elltfbH5g3F7BQ
	rBdVzFlUCUWNJGYShtoUiqUaSRmtGhRk4zn+mTlD48gz2cYJQOxp0A4ip1k0kO2UdJ2DY+J5vrn
	PYqZ0p3b4RFjj1hVsiaSe6xSVFeDIsI9CBrWdQQXyxOI+oTXObBprANdkb7Oc3J7MQbJwc1da/U
	Uvxtv0O0UJJ9/hbIMwh+U8DQVBv6ksmaIwypKv7buxC3PSlPPIV4sfCQBqpobBIj3GAzyQQazdG
	xecQKWcFVLM4aqHHN0VBxiXmjg2ktinjvb/Y=
X-Received: by 2002:a05:6a00:2346:b0:89f:ed3b:df97 with SMTP id d2e1a72fcca58-8beb7150117mr5498543b3a.51.1794681622656;
        Sat, 14 Nov 2026 10:40:22 -0800 (PST)
Received: from localhost ([153.61.198.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed263649esm2256214b3a.45.2026.11.14.10.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 10:40:21 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Sat, 14 Nov 2026 18:40:20 +0000
Message-Id: <DMV5JEF4P0Z8.3K0HQK7SWX2S@gmail.com>
Cc: <davem@davemloft.net>, <edumazet@kernel.org>, <kuba@kernel.org>,
 <pabeni@redhat.com>, <horms@kernel.org>, <andrew+netdev@lunn.ch>,
 <dsahern@kernel.org>, <idosch@nvidia.com>, <ncardwell@google.com>,
 <kuniyu@google.com>, <richardbgobert@gmail.com>, <willemb@google.com>,
 <ecree.xilinx@gmail.com>, <linux-net-drivers@amd.com>, <saeedm@nvidia.com>,
 <tariqt@nvidia.com>, <mbloch@nvidia.com>, <leon@kernel.org>,
 <linux-rdma@vger.kernel.org>, <daniel@iogearbox.net>,
 <john.fastabend@gmail.com>, <sdf@fomichev.me>, <martin.lau@linux.dev>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <song@kernel.org>, <yonghong.song@linux.dev>, <jolsa@kernel.org>,
 <emil@etsalapatis.com>, <ihor.solodrai@linux.dev>, <corbet@lwn.net>,
 <rdunlap@infradead.org>, <skhan@linuxfoundation.org>, <shuah@kernel.org>,
 <bpf@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 0/2] net: keep the TCP fixed-ID flags on the
 header they describe
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Julius Bairaktaris" <julius@bairaktaris.de>, <netdev@vger.kernel.org>
In-Reply-To: <cover.1794139176.git.julius@bairaktaris.de>
References: <cover.1794139176.git.julius@bairaktaris.de>
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

On Sat, Nov 14, 2026 at 10:27 AM Julius Bairaktaris <julius@bairaktaris.de> wrote:
> Patch 1 lets SKB_GSO_TCP_FIXEDID describe the innermost header again and
> replaces the inner flag with SKB_GSO_TCP_FIXEDID_OUTER, as Alexei
> suggested in review of v1. Patch 2 adds a selftest.

Thx. lgtm.
