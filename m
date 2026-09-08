Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3A56B87D
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 22:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908165; cv=none; b=sfuMBCjzKp92xUWZ0nwOkjnsmqbFyVcVVD3lqAbUaswEHN4qjZj4uQw33Gmo+DBijDElfugMnn0J1WOvKRyWcjDpVUca1MVGwtr0SmyYLo0jwg86MloQmgQWidgyPDf1wfH7T1nxdrE5FTdgyFMpEOYgbBg+g3A75W5GK28j3sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908165; c=relaxed/simple;
	bh=vsBDx43bAIddb0gfmnVkap80n2BUxIXNwZDCRSqU0zw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=iilZ2U/zhRIoeNkNV2RIXYif1sg7u3pKA7n0B1YvgCYdcXQFqXttqVt0FQHZ2ysMjE4vI0RuS4IjTYD/7pxUPMs0kkCD7Ddaf3L21j6+VAcVmT/LpDh/3qmGl25EMYbdUhYoB/n+Zp9UVhqWd4zIyOoaDn0riVrLzEwHRdDo91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDkpzYc0; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDkpzYc0"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5300bdf61d9so54583821cf.3
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 15:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788908158; x=1789512958; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UviIj0mAB9dLNORxdxu0OPN9iCyl2WihzfLAQT9a7wo=;
        b=KDkpzYc041R3h2s9AQirb4FzpjNMighuF0ou8aSbF8I/hNXwQIAgtLhBVKp2sYroi3
         K1TkN/11tFF2AvRK2eUW1aMvg5WexzneuKA0nFiapCYUlmBI0K3+ujdNaEW1sOcBjYsz
         bynNrPIL0fTItC9kSQMh+ba1fkvTtK6N+BxsW3qvZycNRX6qTyHQ2poOVgTNigda7SJe
         5MNP3YzXfvFkpOli8typDkTpvjRb4nB+vTp7RTNFtsIeazDxGEDqCxke/tP2AKKguwWJ
         mmE3KKSMg/IlWfaYOrYi3bDu2Qbk+oEy4uogEqvUgKJpfXRbJng+G24hhX1nKdgdu2ph
         ySrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788908158; x=1789512958;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UviIj0mAB9dLNORxdxu0OPN9iCyl2WihzfLAQT9a7wo=;
        b=CTkNLfHwKkbH3IQ01Wj5qE7DzqMQSTOHtYT/+ovQ1/N7LI9Jthv2wG2tdE7z23o7a6
         fD/7+NpJSemO5tMe/PPiBUJ8lKyYMSQQNviXEdafN3d5si9lEuwhFVNabakq7mKChWky
         FOBSOncVCHlTGN0qeRqb8BMq5+pTL0854Ptv2JbE7Q+a4Hy4BmLJMDCrXenPq3QnioAh
         soZgbtKTfhx806N1yR1XztP19qLS2i5ESQRw2jIhqI/aH78zZdVNNFktDJnowmQb60Gn
         Ax0H+xW0cX4CvxqeFtrkf7bJCDcUK4ZoC/0WfKP6KSVIKr8fbOnBoof9csx4hHvMOXRf
         HPNg==
X-Forwarded-Encrypted: i=1; AKwUvByGZAWxlpYNXT8EIMOZknnnDUcjtG2O8WRB5eGswGKj5G5sYmEplvha1uGfnuyRy4Mll0cBkOjoYf1E@vger.kernel.org
X-Gm-Message-State: AFuF++m1OJ2c+8seqRlPY5jMY0BoLX1Eoz+lQlgtWpehUxe164E+fXFi
	htFapgW8Pl76So2OXyOMSMe9ajNRNmmlbOBmgSVkAwp+EXBL9ybGWfrO
X-Gm-Gg: AYBFou2P5MEkMPJZifmKehBileRuONkhA88YPgZe1x66RwA7vv8FWBF9MKVofWANIRb
	P55SFpOF1DiEnjDkS8amDlGG1MuSjNcght2VisVWOQbAgwu6i5QL6B7ojtUv4ktim53CtsdtQGb
	ZEG2qlKq/aV7TiVFaVK9LxABaIoV/X6NzdW4OOeKSyPKlT66Im88umsGhNSpz4XEAT/uU7f7EWn
	NCah6dNHhPg3jtjh4zhp6/BC3pGW0UZQ8jaLebCuqsCefpgGiejqpjhdM70Cpk+ODkB9Q+IX2jH
	n6UVNJEFEX4n+TWfBPn9TdJ0sSR1Sfb544a5YTKT9FWb0t9HkoTVkvdfwRvQtPkPbLPJCDu7ZTh
	8hRYzJZIYpPvKk9emvKPUBDJp8DAQk527P8cW1pfswK00MkPwtC2DrR/Q2yPdichipdhnwDQa30
	Ed2JFu6HM/UEw9GEhY+uLoM/L4uyqH1bteq97yKy2t5jJxsii0lBYGMc0y7aBuh77UMQ==
X-Received: by 2002:a05:622a:551b:b0:530:5418:92be with SMTP id d75a77b69052e-53054989290mr42134121cf.28.1788908158185;
        Tue, 08 Sep 2026 15:55:58 -0700 (PDT)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9106ba5b95dsm7172286d6.21.2026.09.08.15.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:55:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 18:55:56 -0400
Message-Id: <DLAB0LQ7WDE9.1IUD2U6BQCRKS@gmail.com>
Subject: Re: [PATCH net-next V4 13/14] selftests: net: gro: Add PSP
 encapsulation and encryption
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>
Cc: "Bobby Eshleman" <bobbyeshleman@meta.com>, "Boris Pismenny"
 <borisp@nvidia.com>, "Carolina Jubran" <cjubran@nvidia.com>, "Cosmin Ratiu"
 <cratiu@nvidia.com>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Doruk Tan
 Ozturk" <doruk@0sec.ai>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, "Jianbo Liu" <jianbol@nvidia.com>, "Kees Cook"
 <kees@kernel.org>, "Leon Romanovsky" <leon@kernel.org>, "open list"
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Raed Salem" <raeds@nvidia.com>, "Rahul
 Rameshbabu" <rrameshbabu@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Shuah Khan" <shuah@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Simon Horman" <horms@kernel.org>, "Willem de Bruijn" <willemb@google.com>,
 "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-14-tariqt@nvidia.com>
In-Reply-To: <20260908065244.3799142-14-tariqt@nvidia.com>

On Tue Sep 8, 2026 at 2:52 AM EDT, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
>
> Add a PSP mode which wraps every transmitted frame in PSP transport
> mode and encrypts them in SW with the help of OpenSSL.
> The receiving NIC decrypts and decapsulates, so the frames seen on the
> receiver on its AF_PACKET socket are identical to the non-PSP ones and
> every geometry assertion in this file applies unchanged.
>
> Sender packet construction is unchanged, PSP uses a different buffer to
> avoid double encryption.
>
> A few PSP-only cases are added: psp_spi_diff, psp_ver_diff, psp_mixed,
> to cover coalescing scenarios which only exist for PSP.
>
> OpenSSL is optional and scoped to this binary: gro is deployed by
> several suites, so a missing libcrypto costs only the PSP mode.
>
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
...
> +/* PSP transport mode encapsulation, as built by the sender:
> + *
> + *	[eth][IP][UDP dport=3D1000][PSP hdr][encrypted L4][ICV]
> + *
> + * Can't use the kernel-only include/net/psp/types.h header, so copy the
> + * encoding here.
> + */
> +struct psphdr {
> +	uint8_t		nexthdr;
> +	uint8_t		hdrlen;
> +	uint8_t		crypt_offset;
> +	uint8_t		verfl;
> +	uint32_t	spi;		/* big endian */
> +	uint64_t	iv;		/* big endian */
> +} __packed;

My llm is complaining that it thinks __packed is not defined for
userspace code and being used as the name of an object being declared,
instead of an attribute. Otherwise:

Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
