Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795221737;
	b=kHWa6HSwz/8sNa7cKsKdmtVaOkBRx52dcgy5tszPI8dn7502eVYvIJ60duLIhzKUGfTl
	 7xHrwRKhrinERnRz9nh+tf7qa+WCLD+1ln8Wa0R6trquusevolXpKZxS3VZ8pzMIoFfWZ
	 F0N23NhXTUEX8QEjRDb6VuUaAutZ7xAkBr++iQ4Y76ajlMt2+IEQazBPEdAJwJC3gwpsF
	 6qSPREP0RsVVGZ+DSIjLNB85VI1QaZM4dVKEsBC3u3LL/81B/iUjvKV9ArVDS8PMFjscs
	 c9RG5ydFkI8Oubnabln2XqFYshsyG+aJ1/kExWkSpUMWkh5eQAn9v23nkYvxnK76c9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795221737;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version;
	bh=cmb9/XQKjIVigQ77J+1xKd88xgQJr9ojuUuD9/tW/YU=;
	b=ozQ+XRvLYnPfxeJ/ltSaVWnHy9PueifR/xR5QhsS9mUCjTQm0cxwj1cYpwIkOZpqBsdO
	 kRFiinQoVYzpdfyw+vsPXld7UV0GH1x1eKJ0Jq8z+prlU8q8ZERiErhvw+K9bzO3h4GM4
	 mHgLSF9bVzsNxAmAh+Ro/HQkFNSE7hT07V775MjFEwFTAN820sBUtP+FmEKeL1ydN16/9
	 B80SNJ7IHUbDpD7TwiPMiU+dtsGegsTYzX3JyhLD2vod0KuRxRPpz9ND+WzdfKA6c08gs
	 G/5M8516uGtL/Bg0Yo9zK0aZdVACCRuiySdJXSx53x6TZg+0pCTShQnYVobeEG6clHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=QY1WI86N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242F606A6BC
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 00:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8242F606A6BC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=QY1WI86N
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AL0BTH92948769
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:42:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=cmb9/XQKjIV
	igQ77J+1xKd88xgQJr9ojuUuD9/tW/YU=; b=QY1WI86Nyjf7CsbvaWv/XaKMrA1
	lSjKgS0WH8FnIjt+OAVaiV1pgmKYWnBTr/HJz0WIMgHI5A1LIwAaJY/QILNmvenJ
	ptnLD2VSQsdYpkZuOl2fF5m+cbapHAjZtKLSbPqPobcPnj29Vz0HZ2DnvaLTtD5Z
	vU/LWFl4iKdU9lkDDsdKVgdci+SH0bg4BzwJ9WgOdLOXxjXBnHxS9tt48E/rjdJs
	PCDY3AdLGRhMOgJ4+hzWfxcXF5LUeTKJcwiA0Drvzn6bapTSMEPI7JpUOrzX86ZX
	QKhUnMbaMqYxTDEC/VKpknh73CYRgU9RDe89XsYGYYs5EFh/suvemfdbX+w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j2t99u3jx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:42:14 -0800 (PST)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b4232374d6so2028413a91.2
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:42:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795221733; cv=none;
        d=google.com; s=arc-20260327;
        b=cChCay8x6w2whXv+lRyu2PxoI2T8A8kyN9Q/sG3yp12DHCSr27yIAoGhUjUG6VpvgA
         xcelbzQ0BYTfqIhuSbtVJyJhBEr9W6qpBzl1NbsynMSCOOXB3UsVhXvIKoM/WoF7QNBQ
         PXUm4NyxDSzwiMIEpIYMFxDeJUXx/l8fveoVvfxRjWubaXdVFFL+4iwRZuJZcvKxAFFG
         e/NVdS/DhcSsetYgubIDaPt257Lbkrrmj6RQnmE54eIHzm7EaDV5G9e4mp4qXhuWaa+s
         9AISCoIe+Tc4bnzDFu7PVR4JomOOjZEiV7KbxxBQgsOYW1cXRgFkIzlfRgw/egA5iYkn
         nVzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=cmb9/XQKjIVigQ77J+1xKd88xgQJr9ojuUuD9/tW/YU=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=F0fyf3FXHTzG9qlgjvB+w1UC7vZ/8pzlZyHQ6S9ihWWs280ZiJvBTUk7Su4CGc0K57
         +0HhKwoaQkOr7uMEzxRWzFqQSLtpj4nDxaK0vzdGnaSFyPdwQi1K/8pKc2QISiCTMHTF
         ere1OEFNp/xpGhD5bdR3OVEW4ka33iJZusIFgAQvJp5ezF8dkNeTHGESziw+VJQ1pLUs
         nNZkbOvJBrSJxYqWyTClYh2pU594z0z+CKsflvG1O36Jy9Uio/3OSVYV3U7z2H/IYpJQ
         INCsi/OrfGDUJBwkaOA+9ZwYQr0ADt4XVlrRMUAAwLa2V65OSaTJNAfWdJfUOgXd2ewn
         cT6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795221733; x=1795826533;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cmb9/XQKjIVigQ77J+1xKd88xgQJr9ojuUuD9/tW/YU=;
        b=EJzzH+VNtRaKDk5xBB/rsfTnkIYQ+1ERf8gFqN/IOPniFEVxyfxXx9cuHoTfE38caz
         8vooarlaxB6Th6DQpK8DaOPqtMeEgiWOHJ12SE8WKwkiMQUvAJkQXxqNE3Dluo8tXqB+
         G69TTDJPP5xp8gyNyv1aw4uLGuAktELBMly/cOTQrtbNrSh+0faulDtvbyfG8SWmKosg
         EyMh2S49svX89i5UEb0jzOmgnR4RPfZBzKnnhLJ6CdV6Z6p+Hc8a49RsetgoTgpD3+hI
         YPm+BMBCEfpUWHAK18QF7VTUNJ/AXPz9T6H72q6hxQqUsg6u57WZE24rkYLknbKSarwr
         UUjA==
X-Gm-Message-State: APuU4Z8lJhVoXwdob5lODYunARmugdW5Pw/5teo705490laaMB0JFzsO
	BX+FjEKWjBNEPdbOwbExSKoobXesZ30hUlaDnTUeuUBd/m+1ViY7HKkEmx56K9dPefYUoz35Jlj
	PNsH3OiTQdcFOXPNBkCayEMuIJi5Muje6T1UgBfrt4f6vQmce/FKh8NBqU5CQ9LxVQLuzw4RXKN
	g9UWVcVQCRgUmzw4rLOHlvK439sGUMsAldN3cZgt8CEAPY02E=
X-Gm-Gg: AZFdTZfkL0n4ae/cjujyAOPGFLgjJTNSztYiAE1f9H99i75iLvwXhxc7TvS/ZqfQd9u
	C7pPdEsJbT3NlExGZYG03Oev40YTk3RKgrhvX0m81H4RF7/3wXw+HyWR3n41vV6MRT1bxa5MHxJ
	Pm57UAOYH9YIeWW0HYqWR4oZ3i5IUs4XVlRW/5LqugvsrjjuVW+yyYUBpSswY2FmiWrYx0JCh8G
	/K5mlzleheQmZkBGnzAMa4YXPuJHT9dRDFX5SoQ1Q+puu/+TJ8=
X-Received: by 2002:a17:90a:da87:b0:3b0:9a2e:b494 with SMTP id 98e67ed59e1d1-3b41c95b089mr3980238a91.54.1795221733088;
        Fri, 20 Nov 2026 16:42:13 -0800 (PST)
X-Received: by 2002:a17:90a:da87:b0:3b0:9a2e:b494 with SMTP id
 98e67ed59e1d1-3b41c95b089mr3980224a91.54.1795221732627; Fri, 20 Nov 2026
 16:42:12 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119013103.1092559-1-toddfreed@meta.com> <20261119013103.1092559-7-toddfreed@meta.com>
 <sashiko-outbox-224313@kernel.org>
In-Reply-To: <sashiko-outbox-224313@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Fri, 20 Nov 2026 16:42:01 -0800
X-Gm-Features: AclHuK-l1kzQmZfxaMks_8rKcXp3Eu5vIVvwK5OneLSZqpLyGHr6o8FxxmfrXhc
Message-ID: <CADh2yMy9skck8GuUEt390mrSir=sWVnUkJDC38hDb+RjGRO6LQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 06/12] net/sched: add act_psp for psp
 transport mode
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Authority-Analysis: v=2.4 cv=LvQHWXdc c=1 sm=1 tr=0 ts=6b00e8e6 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=xtH7KyWI9dI7BmFOsl-x:22
 a=n5VHtEvjoD_29M01vEgA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: XV4i8rNx--sRNIzgxowbAqP3z9JmMDuu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDAwMSBTYWx0ZWRfX9ShtkN+7q917
 ezOcgaBxTOHWUEWZ9Z+SGwLGg6Wgtchftc7oieOVCwMl6W5x9odjudyOp0HabJK655ATRGesxEh
 Idd60OG2Ch46xVeBEW+XdmvD6I2Uoa2UjyQkThXGv42r+P00uC++Hef2sa/aLHByLrTIHGX+hR4
 D9AkrzOUjsvdglzuQGA0hkw7uOzFtS5OeHwuBUZOV4B/Up7HcEdUuEeXwxE7AtMpPm54EkTkO2v
 QFFWdVGhz4h3x7T2ygUHaRUbeCIGA4rSxQew/C6MZVa+9oUuJmBABAnXOFk3uy9b1friHUqHlNr
 1YVI8HCGTy3dwVYyhWD6gRFgEeOUEO+Z7L9jZzVoIgG685x6hZVIzZikPSnHWkhEADj0E9Q1CRl
 kLKU0dYm2uy9+swkhCPNwvrWqACVNDYSdLMRu9dsCM+YpRu/dWh84JpV19SrB9in0rMlMGyrBio
 QBg2/cV3ViglakPHUWQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDAwMSBTYWx0ZWRfXyjrPH3fKW8fp
 Y4kXZBAF2lK2s5M8PhSFAlsS2qVA3J6SzjVfKs1ZzyY2BCNK5v+RKbnUckiNtW0iRm6z/njKqtu
 TwwmAXEoDfluUQP2ly08UM/zCcCHurA=
X-Proofpoint-GUID: XV4i8rNx--sRNIzgxowbAqP3z9JmMDuu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_06,2026-11-19_01,2025-10-01_01

> [Severity: High]
> Can setting transport_header to off + hlen on a GSO skb cause out-of-bounds
> L4 header accesses down the transmit path?
>
> At the start of __dev_queue_xmit(), qdisc_pkt_len_segs_init() returns early
> without pulling the L4 header if skb_transport_header_was_set(skb) is false
> (for instance, after gro_cells_receive() unsets transport_header on a
> bridged GSO packet), or pulls the L4 header at the old transport offset if
> it differed from off + hlen.
>
> tcf_psp_set_transport_header() only pulls off + hlen bytes before setting
> transport_header to off + hlen.  Right after sch_handle_egress(),
> psp_xmit_md() -> skb_gso_validate_network_len() -> skb_gso_network_seglen()
> -> skb_gso_transport_seglen() reads tcp_hdr(skb)->doff at the new
> transport_header past skb->tail, and mlx5e_psp_handle_tx_skb() writes
> inner_tcp_hdr(skb)->check out of bounds.

I was not able to reproduce this on ConnectX-7 with the following setup
(inferred from the call path from Sashiko),

- create a netns and veth pair
- create a geneve tunnel over it
- on the host end, L2 forward the decapsulated flow with tc mirred egress to
  eth1 (no IP layer)
- a flower filter on eth1 egress matching the flow, with action psp encap
- then, a TCP flow from the netns over the tunnel, so the host decapsulates
  GSO skbs through gro_cells_receive() (GRO off on the geneve device, and also
  with it on)
- bpftrace on gro_cells_receive(), tcf_psp_act(),
  skb_gso_validate_network_len() and mlx5e_psp_handle_tx_skb()

In act_psp, skb->transport_header was wrong (equal to skb->network_header),
but the TCP header was in the linear area. Once act_psp set
skb->transport_header to the TCP header, skb_gso_validate_network_len() read a
valid doff, and mlx5e_psp_handle_tx_skb() got the skb as GSO with the TCP
header linear. No out-of-bounds accesses.

I did reproduce a read past skb->tail with a crafted virtio_net_hdr whose
csum_start points into the IPv4 options. But the skb is SKB_GSO_DODGY, so it
is segmented in software before the driver, and tcp4_gso_segment() drops it
(csum_start != transport header). Since the only effect is a garbage MTU check
on a packet that is dropped anyway, I am not proposing a change for it.

> Overwriting transport_header on GSO packets also bypasses the
> skb_network_header_len(skb) check in psp_dev_encap_ok().

It doesn't though. act_psp sets skb->transport_header from the IP header
itself (ihl for IPv4; for IPv6 the fixed header, as it refuses extension
headers). That is the condition psp_dev_encap_ok() checks with
skb_network_header_len().

No changes to the patch planned here.

-Todd
