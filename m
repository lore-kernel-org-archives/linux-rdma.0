Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416482;
	b=wzxxlvTSfJ3YV+sSfkiumFQpY8UMNzlyxzmk6jZbjV9XSYakCjrYwFu+K3uDbKid1VVq
	 FVGgfB0mIV73NRVNvkI5azD6Kad9/Wqlz6oBc4TjVnhOqv4+ND2Uj6RVOnLPaE8lRP9RF
	 VdTHakwXJWTTsuB2hav4pqF3vk2aCQD6GQL3+qVcWA2C/XYpMMXDRpm6xB2MMnII+GG/v
	 3K7VS1rRGVlvyUHUzT6Z4lhcT42oFU15Vj/hke2op8AgMo5eWCIPb0AwvfRPtcKFfc4WQ
	 gzjBRwaZ7W49sEADYecjMt5Fcj2EQlnaR40iEC28GcjMGpnAXLrjIPdhVGOs6/Y4xgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416482;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=cNJr3c3uqZZVhSfWEr07FcVM+B83XjBK0ipGpurD8/w=;
	b=T9WmjIuD3ZaMStf7DFM2mk2VvfVv0p82MI2EUFSU/en7eo3kmMZlrmr8KvAxDQTi6JwA
	 UkSuDUWc9ulKkTZlhd9lg3FhNGG/cZGm7NnFz8npaN9k7uFnNgEkFORhHHp80y6NNDgqI
	 uuqwymSHmI0xQE2S9XFHDuYeVAupDA4rwyHwlcvBweUjucn0B0AStC2PzyhCE3sgd+iDQ
	 M9ccupyVyt17yDR44kcCh+4j8CeBvHVsouL3LDWk9m8389vVIo1aCb9OEfZ9stiBMYoHQ
	 h7oy6pS0c0bu4bjA5uYpL3eCPfiOQ+wARDcaAt2dm3cDOpqLld05wxs0gnSDd0o0upg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eV24wG6k;
	arc=none smtp.remote-ip=209.85.217.49
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E66C606A32E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 17:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E66C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eV24wG6k
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7d2e43ff4b4so33056137.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 09:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794416481; x=1795021281; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cNJr3c3uqZZVhSfWEr07FcVM+B83XjBK0ipGpurD8/w=;
        b=eV24wG6kUDKl/1BRzugsFu4O6Q8IMvuBMVX/hw3IwA8m/Qdq9KxFfGNdIwU/1eK/S/
         ryB9W0aiepskzNkxFtuLuS1B8mDbwU0HwpPUMSHmC1vGEAs3AcwgrIuW2dj/HE+iOpfC
         c2D/uE7ouHDAkBbJKtQh2hwdmG3Kxw5BCw6dYMAOxlPArZVX8CZnIRFqD41fzK06ZI1q
         GThZ1b4wU1om1c6zeGKhdtmLDrJKAvlzi1ckauC5O0yIfDFOTVBPJyXqT0g4guj/7j90
         CH18VtYry2bKaO8SsBtHxaYYhBDJn51m9CKVYwR7LJa5RW9yCa7mGQnRL7KBGekkvjZ2
         vXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794416481; x=1795021281;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cNJr3c3uqZZVhSfWEr07FcVM+B83XjBK0ipGpurD8/w=;
        b=nrLSi4us5CoQrCa896HlwS3R4TdeWPEq1yBeGc84F6YOUn4VcaAj8OIwFq7RwZZMK0
         TTcAcc/psyVZ8cn78To3q4VM3mx1QvTXwI73RL6mIM2UNTE31EhPMxsu1J0f18W9REJN
         afx05wLWGesWdm+cZavPqTGdK+yOyq8p3s4ea6y/+fDkLfTB/n1qDPF4F9dmG9KaN7rK
         HeX1IGQK7bbSQ2o/wbz9ZTnZljGyls8GBUuWjxNociuBUYt4Vz4NlIf9pJ+ZgLPGGo+N
         N9sceNvVtz7uzu34nE0iNSASwRMqiVR/5+oQwbu3GWKYXy0bmyniXJQxXyAiCzE8Jguo
         jm8Q==
X-Forwarded-Encrypted: i=1; AL+hErElQe10GNIsrPySaj8HI5lemTba/gC6GU7VGtZilLic2AMzk0s8P3ZB+EI869kbWgq+WJH5uzuughcd@vger.kernel.org
X-Gm-Message-State: APuU4Z8AduFpJUq03Avd1hcpx8iU2+8svz8+onBet37xJp6asURcYanz
	VdGjoxcyLyHzaX7lrhqSllCBlAqPQGmplh0AgqIkZFS1iTAGiqoUDtBB
X-Gm-Gg: AYBFou21ZXG017yoIvBK3Y1eBzmYa+4v2h1iTpOUW3c6GixA9iJCGIJmyuj0F11vxu3
	js0nZ21A9PDP9T582UyaponxIQ6FE/3VZUlW4RS7n9zbtpG+KFIRyAt1QlpISakX/nJlM8Vj4yv
	yMmQc8F28TgJOXO0nDSUAHGk2+1XE/iyWr1qqWi/Tldn0uBpiPvNcZut8Y5FeizJYouH7LXi6Hl
	FNByZc5tY7s2aOs+YuFu2W6Wsm0NKGIOh/BUUUkDJcarhAb3wioPanaHPzPhyKUhCQ+t4giuEYL
	WLPQsdrpRuB5oaFkgUkIIsbi0l1wdmXiwCSY+ZSB2ZtqoVgS/FT11/9cnM7cL3dQatId/GRvC8r
	T94EzAhXWhSSIRY80k6itUM/OD0WiOPYSvv0Tzx8yhxDlhUJEAMWqfeS0cY9iV45FFHDuZeoVqr
	Nmm3+Pa7/JTpsJZy2FwWjEN2hb/G0gDhV8N5PtOaegACY9RNHWa3fVKVTi3TiTNVANgMP5C/uVz
	VOXA7IjEqKkLYOpNpJEXCQKLNswzn8hZ1mtuRTWIEpnz6dvEmrsE9BonxhOvnu4Ej4Nt3ecSQY3
	fpag+GOsFRmouGLQ
X-Received: by 2002:a05:6102:a4d:b0:7cc:905a:331a with SMTP id ada2fe7eead31-7d6316c856dmr19138137.14.1794416481052;
        Wed, 11 Nov 2026 09:01:21 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::6:868a])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d302239188sm4078178137.2.2026.11.11.09.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 09:01:20 -0800 (PST)
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
Date: Wed, 11 Nov 2026 12:01:19 -0500
Message-Id: <DMSJJY9PLHSR.39PSNUXEC82J4@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?=
 <bjorn@kernel.org>, <bpf@vger.kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Donald
 Hunter" <donald.hunter@gmail.com>, "Eric Dumazet" <edumazet@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, "Jamal Hadi Salim" <jhs@mojatatu.com>,
 "Jiri Pirko" <jiri@resnulli.us>, "John Fastabend"
 <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Paolo Abeni" <pabeni@redhat.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Simon Horman" <horms@kernel.org>, "Tariq Toukan" <tariqt@nvidia.com>, "Wei
 Wang" <weiwan@google.com>, "Willem de Bruijn"
 <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v1 00/15] psp: introduce socket-less
 associations
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Todd Freed" <toddfreed@meta.com>, <netdev@vger.kernel.org>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261111005533.6436-1-toddfreed@meta.com>
In-Reply-To: <20261111005533.6436-1-toddfreed@meta.com>

On Tue Nov 10, 2026 at 7:55 PM EST, Todd Freed wrote:
> psp associations today are bound to a tcp socket when created. traffic
> on that socket is encapsulated in transport-mode psp, and encrypted.
>

You can start sentences with capital letters in cover letters and commit
messages.

> this series adds associations which aren't bound to a socket, which
> allows psp encapsulation and encryption to be applied to forwarded
> traffic. you can use this to transparently apply psp tunnels to flows,
> with help from userspace to manage the tc rules and orchestrate key
> exchange.
>
> the lifecycle of socket-less associations is managed over the psp
> netlink family. socket-less associations are stored in a small registry,
> and are addressable by id. the registry does not contain socket
> associations.
>
> socket-less associations are on the device's association lists, like
> socket associations. rx ones are therefore marked stale by key rotation
> in the same way. in this series, nothing acts on socket-less rx
> associations on key rotation. instead, userspace should replace decap
> rules for a SPI before its device key has been rotated twice. a
> follow-up will bring enforcement.
>
> series structure,
>
> 1, 2/ prepares psp to work with non-tcp packets
>
> 3, 4/ adds the netlink commands for managing socket-less associations
>
> 5/ adds a METADATA_PSP dst which carries the socket-less psp association
> on an skb for tx, and the transmit checks for it
>
> 6, 7/ keep mirred and bpf from sending decrypted skbs from egress to
> ingress, since skb->decrypted depends on direction
>
> 8/ limit time-wait psp socket validator to sockets actually in
> time-wait. the new psp actions check for presence of the validator
>
> 9/ adds the act_psp tc actions, psp encap and psp decap. in software,
> encap is egress only.=20
>
> 10/ adds flower matches on psp header fields, for rx matching
>
> 11, 12/ add drv-net tests (netdevsim and hardware)
>
> 13/ makes tc-testing run dependsOn probes outside the test namespace,
> where they currently always fail
>
> 14/ adds tc-testing tests
>
> 15/ Documentation for socket-less psp associations
>

Some of these can probably stand alone like the bpf decrypted, psp encap
helper, and timewait validation, and be submitted first to shorten the
series. That's just a suggestion though. If there are dependencies on
the main series you can ignore.
