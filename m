Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114213;
	b=jj/2NJ0pM1Lk8QW7aJ+qMkdlRHtJDPgboMLcYi4U8OknhjBxAv9zQzdYxPKdm3Gew5IY
	 MKd83fIRSVhdY/rLw9GDoBpSI/QYdmPZ5YBGm4eA/nALl6/yHxH9TB5q+FK3Yuzrz8EZs
	 yXVMekyDhLY70zpLmC7Oli5CuXPcYZp5vpg7h1OL8BxB0tXkvW7z7FmjJs+WAzhQgCCY7
	 J6f2XH/kFJNXa0aqjyD4gU0T4tZ9O7lF7ZqhXDthVO8xth3WgLCBr0cxSywaH1RPwxbnd
	 2UmMVyDxGxmq9rmDej0mrWYSqu2/QazMKGied5C3//VvWGzx5bO2rkXXVXxB/O6fCCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=pV7/FMjkL7wdPpM8Y5++u8mrK5b9ri0r/zd+YSKLnSY=;
	b=b7v78DXypXz6uiCZx6dmL9iPc4AURwrq5rJ1aJu7BEyzmNQ5WbG8nQ/JwqoVmpX3nyFK
	 miLL9VYpcCFAdG6uLPOOZxYPko8GfZFvFGK38+SmmHbKI7ofG7Z8R0Yz4qLuUoR0FhfEw
	 5Q+Qc5w0vJvWhdnK5d5/uYZQ5b7kPUy/LztGlr88WzPeo246GAU5i7m0CIoYt1LIa9920
	 a/M4hbtyq75EVionywoEUw7v6SwKskg51858FbUf+wPX3SwSq/fC2zlRJPc9sckzBRKiu
	 L5Jvnnbo9BlFT+ijCueOo1AZby+VshsaFAH42Vt+sFT+sO0/5X1rT+LYG7pqCJUtflg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bJcrFyod;
	arc=none smtp.remote-ip=209.85.128.171
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36612606A322
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 15:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36612606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bJcrFyod
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b05bf699easo40162677b3.2
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 08:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793114212; x=1793719012; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pV7/FMjkL7wdPpM8Y5++u8mrK5b9ri0r/zd+YSKLnSY=;
        b=bJcrFyoddKPNBUKMCWSaSLNvZDtVwvQ1Ps1hJYAyLKLDONqD/aDvfhTq3zgSTdBwlN
         jBjU+4/LHNvJx9CTIEQ1Vg6/GMOm5ZHWSeSEcUn1cglxfM/QokKoFF2DgNFEgxf6mdfB
         qRu+o2ma+8jTA6il9dY0Sx+/uVtjMTims0fyGaPPwj4sLUh30Ql24gM0/0Rn60UcJYtt
         TJdmauEA1AQ5PkKzhYzcZpDgFk2vteUH2BIdeSbjf/KJ+zb4MD5ISpp8zLc8eLfQmlEX
         dalfnQzkkYc4bqYoPXZIMrAV7Qu2oK0u/UZzPJ8jIkks16MV1M8bEzik3Miq6yR3uEya
         q4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793114212; x=1793719012;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pV7/FMjkL7wdPpM8Y5++u8mrK5b9ri0r/zd+YSKLnSY=;
        b=fZM9NJOilaO2jBvYV3jtNaFfW1ww3jGJ8pZEYxn4k3WnBK56SELFNriYhXD3uICXfG
         3RmuSZue9M5Ns0Zfy7NWrNShEO95X1DWMlL9Kk7yqreybBZMqNL+5MHi+XBJhZAtAdDD
         vdoOng1xShCucyUKZpnNrHTCQGhMDIKXfNdtxg2ytpc/aiGa5wWSDGVZjGn92JOA3Acf
         saFiXIcy2iotXsA+4mWew/RUWKFqnm3OXiR+YSx86DCqSltV8j9Kt6a2y7vlds7rBAVy
         MpbO8xLgV01bB1QUot36dH9WAnYiypD23JnjWCEbxLxS7z46nB8SKxJBVg8HXB2HYcHf
         z6mA==
X-Forwarded-Encrypted: i=1; AKwUvBw3PGEI8KFZA0g9OhUPaHkrndjrj5Wd6HkSFUoz3sLjw807kWj5Xaigw0HYozvpbezLt1jh80IdEe5q@vger.kernel.org
X-Gm-Message-State: AFq9FYKNthA5tm8y0EVkD8PHSNCovzTsviZmirzHfbbaCpiDFZuZY36l
	8NRtxVsrji83zUdDWmV+nkxwMvGcDJTqd4xYpIQog1XeWddUzmAGVq/L
X-Gm-Gg: AYBFou2+LwM7tcPSJsFuiMc+e//WDWrUMHqb+0o/H6OMHW3h5s8L9wBMfWjC8rv+zG2
	WJGv4Qeke5mtW5oS50r2S8vYRyC/AAtTFrinuicMuQ4dfq50YeCYs+uBCDSZ+WIqJoOChhMCEQ8
	b4qQ5HoNb7W+gE/G7AjwKz/9XNvjUNh3SL5tgNn4gPuw8zFkbLWXz6C69ysJbwrKs71Wx9XNf1k
	K0IIx5+z4Q2lnWpZIRgdn9UZ4mrYcPsEboqotG+pRG/aZSuRonxBfJ0oyZ14+8valRbJTb+tPiq
	LigJmptNwLJ16MHI0+PrRZS5lL//yiB1bWuBAPyg05Jnb0eDdfNPXhugfDZ4rquLcDU6C+WvT3f
	mXtNro5SqmssziS6bb88WgQFwpL0poFa6w6v0vBMJz7qfQQydd2PvmNzS2WyHVD+BZzHr8mxb8c
	iuj9zhxOtdEGs3jLimJqOd/Dp6xkE7TMXRtRbmCMLRdAKqXp2PTGsdO9ieCSBIQCstR+hD8eeIw
	kY5d9353XQyQAvbCADRoYxOQbenPwrgQ3oiPhFk6UwQnU0puj/FU/0CVXNGjOSw
X-Received: by 2002:a05:690c:dd4:b0:8b1:4446:8534 with SMTP id 00721157ae682-8b166b77c23mr74464917b3.15.1793114212162;
        Tue, 27 Oct 2026 08:16:52 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::4:1ee2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e539e34sm13895667b3.9.2026.10.27.08.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:16:51 -0700 (PDT)
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
Date: Tue, 27 Oct 2026 11:16:50 -0400
Message-Id: <DMFPXSDO64VR.2AYG2NTUEYFRF@gmail.com>
Cc: "Boris Pismenny" <borisp@nvidia.com>, "Saeed Mahameed"
 <saeedm@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>, "Tariq Toukan"
 <tariqt@nvidia.com>, "Mark Bloch" <mbloch@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Daniel Zahka" <daniel.zahka@gmail.com>,
 "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>, "Simon Horman"
 <horms@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "Cosmin Ratiu"
 <cratiu@nvidia.com>, "Raed Salem" <raeds@nvidia.com>, "Rahul Rameshbabu"
 <rrameshbabu@nvidia.com>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>, "Dragos Tatulea"
 <dtatulea@nvidia.com>
Subject: Re: [PATCH net v3 1/4] net/mlx5e: psp: tso: replace only the length
 in checksum seed
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Todd Freed" <toddfreed@meta.com>, <netdev@vger.kernel.org>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261023234640.1459291-1-toddfreed@meta.com>
 <20261023234640.1459291-2-toddfreed@meta.com>
In-Reply-To: <20261023234640.1459291-2-toddfreed@meta.com>

On Fri Oct 23, 2026 at 7:46 PM EDT, Todd Freed wrote:
> for psp tcp with tso,
>
>  - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
>    computes the checksum seed using the addresses on the socket and the
>    total length, then
>
>  - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
>    addresses from the packet's l3 header, and the length of one segment
>
> the length difference is expected by the device. however, the
> difference in addresses is incorrect in cases where the l3 header daddr
> is an intermediate hop (e.g. IPV6_RTHDR). this causes every segment of
> the tso packet to go out with a bad tcp checksum, in this case.
>
> the fix is to replace only the length in the seed which tcp had already
> computed. this is also what tcp_gso_segment() does.
>
> tested on connectx-7 with the rest of this series applied, with a psp
> tcp socket whose segment routing header's first hop isn't the final
> destination, and the peer checking tcp checksums in software.
>
> Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
> Signed-off-by: Todd Freed <toddfreed@meta.com>
> ---
>  .../mellanox/mlx5/core/en_accel/psp_rxtx.c    | 21 ++++++++-----------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
> index 348fd7a96261..d9c2742b3c24 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
> @@ -177,18 +177,15 @@ bool mlx5e_psp_handle_tx_skb(struct net_device *net=
dev,
>  		return false;
>  	}
>  	if (skb_is_gso(skb)) {
> -		int len =3D skb_shinfo(skb)->gso_size + inner_tcp_hdrlen(skb);
> -		struct tcphdr *th =3D inner_tcp_hdr(skb);
> -
> -		if (skb->protocol =3D=3D htons(ETH_P_IP)) {
> -			const struct iphdr *ip =3D ip_hdr(skb);
> -
> -			th->check =3D ~tcp_v4_check(len, ip->saddr, ip->daddr, 0);
> -		} else {
> -			const struct ipv6hdr *ip6 =3D ipv6_hdr(skb);
> -
> -			th->check =3D ~tcp_v6_check(len, &ip6->saddr, &ip6->daddr, 0);
> -		}
> +		u32 seg_len =3D skb_shinfo(skb)->gso_size + inner_tcp_hdrlen(skb);
> +		u32 len =3D skb->len - skb_inner_transport_offset(skb);
> +
> +		/* update just the length component of the checksum seed
> +		 * tcp computed the seed with the total length, but mlx5
> +		 * devices are expecting the segment length
> +		 */
> +		inet_proto_csum_replace4(&inner_tcp_hdr(skb)->check, skb,
> +					 htonl(len), htonl(seg_len), true);
>  	}
> =20
>  	return true;

Thanks. Makes sense to me. The bot has a mega nit about the commit
message that may be worth addressing next version, but otherwise:

Acked-by: Daniel Zahka <daniel.zahka@gmail.com>
