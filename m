Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445022;
	b=CYeV2eU9aKX/+tWWWQgECSNO0GJdtCCzMmXuB8sJLWOERvZSHOIiG8UeiyJL5inZ+e3t
	 S/ty4mx91b5bY8MGkOcUYhrMejbKAhl4pooM4bxM9hcanAd4WPJHAG5xIe81qPqk1kYGY
	 3v9CRBOCvD6NeM43FbUPT050m251CJX0LmUmxQnM8YFTe2cnnlEwYkRsDWiPxCvOCO77c
	 MXA6XBPYGVkKBaBvn0N1a1pte11q1TOjGvavKI7+YqUBrcC9Xj5s8wglONVfDmHl/TJB8
	 hkRlm3KYdZmv8YOaZP2lyzropsRB6iVtFRQ5RFJKTezmsF4cd+N10mh6ABZf+z72zpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hKApyV/aS+9KqkPmaO1BZU1VaB2VbTd3gghIjFzdoW4=;
	b=eyh9LkK+qBYUtGVot89MYpNj64xtYCeIJBmK3fRQrGD4tNqdCYNdydBl+XtWVrXXr3id
	 Q5/QuXNq0QtqXExFVF5Xd1SBc+V4TSvYKHzzvfgcHuz/XhKl6gUj1vjL9O7FBLNJNibNu
	 wQwjdlFBsqHlQGxbErY6XsxXi92Mmsf6tHGplMDR0dPTNikc0bO5Locp3xOjt57/TP5PE
	 seiaW5bFH93VT50vTquURjKRYy/Fu3Ld5JviywjKh26kTVRmk8HIw1abikycIlVNdVs+C
	 zsWRYH/Gj6+Koa6oyfzSqQ2orDX9TKeT1qNk99bcTMqecpuNX2buOPrK+3NM5W1JvUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CDZC/n/U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED63606A321;
	Thu, 12 Nov 2026 00:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CDZC/n/U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C321F00A06;
	Thu, 12 Nov 2026 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445022;
	bh=hKApyV/aS+9KqkPmaO1BZU1VaB2VbTd3gghIjFzdoW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CDZC/n/UXscJ0YkWeSISNjgouhtEXyZ2040Mn0MjK2N7ocpRhRIdwb9vLNDDnrfed
	 PDxr4egmmkI9RljfWhBezOxGh2CmKCQmOF9aVGYgzRKPw7/vP7Q+jsXYR5++ciRM1K
	 q4fNzDMSvU19Hw6srsvVwmyNiC/vp+NxE1naSwYOSWjG2/NhmLHEkrv4pjzP2oBEau
	 Qx83kUjzmZoaveynAHAYQd1qTAW8KzLLCdTC7p9pn18pvv76hAEBk5Yln7jQPBDI6Z
	 lUptRn9JC34Cy9ZmGRXt/k+eeEX1VYwsSu3rFnAwMqk5wFSCMANX//tmqv8PRTJYDN
	 wBBDNmEJOWAnw==
Message-ID: <sashiko-outbox-210008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 05/15] net: add METADATA_PSP dst to carry a
 psp association on an skb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-6-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-6-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] net: out-of-bounds read in skb_metadata_dst_cmp() [1]
--

commit bf04d738461897fa25a1f7c67c60f36977a2704d
Author: Todd Freed <toddfreed@meta.com>

net: add METADATA_PSP dst to carry a psp association on an skb

This commit adds a METADATA_PSP metadata_dst type to hold a reference to a
PSP association on socket-less skbs and validates target device and MTU
constraints during transmission.

> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index f45d1e3163f00..73755bce2df06 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
[ ... ]
> @@ -125,6 +142,8 @@ static inline int skb_metadata_dst_cmp(const struct s=
k_buff *skb_a,
>  	case METADATA_XFRM:
>  		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
>  			      sizeof(a->u.xfrm_info));
> +	case METADATA_PSP:
> +		return a->u.psp_info.pas !=3D b->u.psp_info.pas;
>  	default:
>  		return 1;
>  	}

[Severity: Critical]
This problem wasn't introduced by this patch, but can skb_metadata_dst_cmp()
trigger an out-of-bounds read [1] by casting skb_dst() without checking
DST_METADATA?

include/net/dst_metadata.h:skb_metadata_dst_cmp() {
	...
	a =3D (const struct metadata_dst *) skb_dst(skb_a);
	b =3D (const struct metadata_dst *) skb_dst(skb_b);

	if (!a !=3D !b || a->type !=3D b->type)
		return 1;
	...
}

When loopback_xmit() preserves a standard rtable via skb_dst_force() and the
packet enters gro_list_prepare(), skb_metadata_dst_cmp() downcasts the rtab=
le
to struct metadata_dst without using skb_metadata_dst(). Because struct
metadata_dst is larger than struct rtable, reading a->type and the union
members (such as METADATA_IP_TUNNEL's tun_info and options_len) reads past
the rtable slab object, which can crash the kernel if the access crosses an
unmapped page boundary.

[1] https://sashiko.dev/#/bug/linux-cad8ab9c-3c7e-48ba-8546-0bb9ceb5d8be

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D5
