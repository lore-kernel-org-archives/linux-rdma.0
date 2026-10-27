Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114865;
	b=YQq2Ba+9ISXk7HAN+RgxCkV3OZSHL7ppDYUD5QQThFaKHSGJ89WpT2thSPbGn+TlheN3
	 Was6SbBCEVIKqoPWR/c9UK3lnjARVRyZb8myf4n0BFjpCUwrJy5oUDnJ/vBL1EiMRLDRP
	 I+srBv7mRFa0Ydiu/OD8Zj2MfRBx2f5wpWU/BVvU/tHPAgZv5kyNN8bjFlC5VO+UvUOb/
	 NdIc1XxX2ZwsHVTFh35dHg7hkgOojeOCO2PEbwDaSTpTUZAHslGCDBYIBqTCIC11rkI3B
	 qQp2NUMI/oR+C2gSbOjfGQ6cE1gruUIa9X0NGdRZN3k0YSDw8yvSZCvkTHIykZqe9HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=uqwtnNOMKZ62ohb4pCxSL5wBGLnxx/MLeyk7MYe67bc=;
	b=oeSASWq2coNyIrMDhhPBfKAlwYKhTCB/y7BnGHQC4zjk2pZ44SVC+dvdgH8yQ9O0GyV7
	 98AUiLUw+CxMJuN1FuFAsAN04b4UB8L5pWBIpvOur+FUlnrAukCVSqdFdPLx8NW9wXoXg
	 zPRofnazNdRcW0+wN7Vcrc+c4Nobj0UljHK1yVEtAfR+RRqX9AcllwA1zy/G6FMruIaCr
	 jvxPBrw0vvW1a7YtUA8oGFGwPF1AvikAByziPPsyjCqyHS3hauIkr+v71uNrFHaRKMfnm
	 lRf6c6xuOWi5gai3IyDIjNv0fbCdwOoJ6gP0smO2gPyFEtiAaVXStIBYlVAjXTt09lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zx1yak+H;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAE6606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 15:27:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFAE6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zx1yak+H
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91befe703c4so162226d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 08:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793114864; x=1793719664; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uqwtnNOMKZ62ohb4pCxSL5wBGLnxx/MLeyk7MYe67bc=;
        b=Zx1yak+HP4vRh1a7K2NP1uGeEoVYSv5PWBRg8nmWiinXpO6HtYk19YC0TO2GKJUQpG
         AbHXCPy5c9GRnlxzBNGwoNDkjI8KfLr1z/1gO1G+XNPdZAw8/IG1XwI30jKNNg4ldjOy
         sh+rPdeZbxz03X42r07RMAnnLSDscRiB92jAOrtz1RZ00JROwLooZP3BvYRFfgusczZr
         n/Et6gNKJv8yxxssxKLyODZIDYq9IquF9P6ip0XYT9P33OlaM/utbO0z/HHvNmqt0iXa
         wJa8DegfBACV2xpO+Lnsn7vCgEhJ6k9a4/7Beoa+fbbcHKsihGspDNfqO112CHzj8A0v
         kZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793114864; x=1793719664;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uqwtnNOMKZ62ohb4pCxSL5wBGLnxx/MLeyk7MYe67bc=;
        b=L2GWJ+p+nFf+B33h60cUJvoZtQcEWy7dbOmTs/z/yveDAAnTZMaaPLru8reELUS+hd
         3IdPQQXvBHgPHDvTf8QzOjmfvyO5FdAuaTjpvo0bnD9PNWy4j1SnEeEXyf3xCN5CzNuZ
         rsjCU8Oq/hA+FWs0o/CkBDQTK/wXLm/SdI0ZFsXFiEvvGQ+mGtWKmT0CtmIgCGe7/Cpm
         ofRH3tPofToWKnFpj1VbF+hwlZOJjYBB/ceLSNC9vMb1Wv7P4ROeTeVnrC9NzwTauPfa
         7cqUqjXG/WtcaDsHi5XsWREl8toy/JlIv9+OAxjtBgLACWlAWDSHvYqhiOf3iY9vnYMZ
         267g==
X-Forwarded-Encrypted: i=1; AKwUvBw3JZ9ggUOmG7/jdVjpqqFHnQzWpipxwVZrvTeEMAXtBebEY0HbgW6p5ldrD4SsWF6DU3i8mtGPWCY7@vger.kernel.org
X-Gm-Message-State: AFq9FYJIslYcXtujBTb61VJMdfG667BSTlwAjqY0sfEzlFeZRgI17F+h
	fv5kjvbhN4qaXt5RTW9NAMZh2wIiglKaaFIPPu+er3EzJfhy6f2m2Xat
X-Gm-Gg: AYBFou0JoS0w2fCYUo/ODa5Uu8vZnJX1BuW+vQv8aHt1LODDd6nqnpdxX4sJeH6H0nW
	ebf5dVKMja3HGbNo9q8P8Z6hlt+tJeRh7jEiOAeCLlWn5coBnKOK0lNJYeKtaVzpuEgR9TsoaP6
	aZqueaToMuT7sl2hcmqFlNLXf5XQD7AP7GYkt1iDkyOfI+GO/XPrzj1nmH+Y9nCTOmV+78XgtaQ
	kMpi27ZB8/p1soGnCqwIumDVCBxazbQEkSMPe7PT7iuHSHLFo+nwzq+FRlSLRsLg+7e0DokRmBy
	eZ2QKNuPmTN6BV3OnPcxiyI7zUWMJJqO1aUOvnXYOcyU25xmMkHvkauEjekEQMhZJwkUd+wRsww
	I4RnPezsL++FjMoT6njeBdSt7Sdc4nlfOrke+AVf/U+OrW+40okUy0KbKN00QgyO0wj+EEy9ZHq
	xy4qX25hEEiZYhzN3o24U+IuU7nV0OzDmaxfZuQG6AIpyHRApWfmermztZR4hNb1RurhVrOn9h5
	BYQbweR9UkdCPUE3wRgBjtJOTjEo+u0lLFyMi9B45M=
X-Received: by 2002:a05:6214:5093:b0:91c:7673:a417 with SMTP id 6a1803df08f44-91c7673a830mr20960306d6.50.1793114863756;
        Tue, 27 Oct 2026 08:27:43 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::4:1ee2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c6e20ba4fsm27571496d6.14.2026.10.27.08.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:27:43 -0700 (PDT)
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
Date: Tue, 27 Oct 2026 11:27:42 -0400
Message-Id: <DMFQ63T8HLVV.3L1SY71TO7GHU@gmail.com>
Cc: <netdev@vger.kernel.org>, <borisp@nvidia.com>, <saeedm@nvidia.com>,
 <leon@kernel.org>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
 <kuba@kernel.org>, <pabeni@redhat.com>, <daniel.zahka@gmail.com>,
 <willemdebruijn.kernel@gmail.com>, <horms@kernel.org>, <shuah@kernel.org>,
 <cratiu@nvidia.com>, <raeds@nvidia.com>, <rrameshbabu@nvidia.com>,
 <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <bjorn@kernel.org>,
 <dtatulea@nvidia.com>
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Todd Bert Freed" <toddfreed@meta.com>, <netdev-bot+sashiko@kernel.org>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261023234640.1459291-3-toddfreed@meta.com>
 <179288570143.3134.8925369868949382653@kernel.org>
 <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com>
In-Reply-To: <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com>

On Mon Oct 26, 2026 at 6:05 PM EDT, Todd Bert Freed wrote:
>> [Severity: High]
>>
>> The PSP ICV doesn't cover the outer IPv6 header or its extension headers=
.
>> An on-path attacker could take a captured PSP packet, insert one of thes=
e
>> headers, and set saddr to an address they control. This assumes the
>> device authenticates such packets, which this patch's premise implies.
>>
>> Several of those handlers reply with an ICMPv6 error that quotes the
>> packet. With default sysctls, this happens for an unrecognized routing
>> header type (type 0, for example) with segments_left !=3D 0:
>>
>> Before this patch, all of these packets were dropped at the is_udp check=
.
>> Forwarding the decrypted skb itself looks blocked by
>> sk_validate_xmit_skb() ("unencrypted skb with no associated socket -
>> dropping"). That leaves the ICMP error path as the open channel.
>
> Agree with this finding.
>
> Ok, this puts me back in mind of the approach in v0 of this series ; just=
 drop
> packets with extension headers. Actual support for extension headers can =
be
> done separately from this fix.
>
> pw-bot: cr
>
> -Todd

Like Jakub points out, this equally could affect tls offload. We need to
be careful with any features that can result in device-decrypted data
being sent back onto the network. Another gap that exists currently is
xdp tx or redirect. That would also affect both PSP and TLS offload. I
think we should try and make these features work with crypto offload,
rather than building up more and more defensive checks.
