Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578647;
	b=xbfu/aZnNGOi8ToknMBUBbtplEbyafaoVe4xzuJHvCJBjk9rpdGAM+nwQyfUzSCQgsgE
	 6abbeniOrFX58f+7v3XrdLJ7fM2b9kQRzrtSBJqlnA4L1SCQjE/pEOlmEL5Cg7RPlP2fG
	 w19KWvAx09QcBDspya7mRmN1FNIZNf/aVk7+IBdMHflYzcmpgSJdm1gJ8HvUTdsOmFirU
	 y264MECLe7HKvSUp9E//XGT04L3M+3N39U7xq7vVCpm8slsfOBE+vwwbwQ5QzBjRUG7ol
	 nUyjl92lJQHaaONSrhxJmIc02xrbej2wx2MEbOBSsin56Q7pYQ+yhrwxPZOsDUrZg1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578647;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=y2MXVuSopof1u2e0UlPr5RPihuMcVA09Qb/rkeKWPFM=;
	b=RQ0nBwB9LDVQJrmj52pYeqvcv3vUoZbyHhfFVmu6aJvVexSa7xyKNYDaQ85e7yrkxZ5z
	 04M4RLeaF8+DWuOMbL4MaUQEWih9e0vnFcPjH8J+/c8mD3qvEL6KF74tjrDFHmkeiNq+K
	 OHPvZZqkkQmY8fYW563GZmdeIKX12+cnznbZ7cvIEirDyAQJoDbZYyB7ggJyGCwb9seoR
	 EbxwNsOGFYOWK2+9bJsP9D3GLEdJhX5US+ivs07FAS7ySzyEzQ9X82zId2CBHrTDRC2nq
	 LeCxQhSRRi2fhocWSevGphvjk6Kp9GAguEdvMVxCU1A//dHM3uOB+3SdWA7cp2N7n4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NiN47LXO;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92309606A31B
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 10:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92309606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NiN47LXO
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f20b304c0so64859785a.3
        for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 03:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792578645; x=1793183445; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=y2MXVuSopof1u2e0UlPr5RPihuMcVA09Qb/rkeKWPFM=;
        b=NiN47LXO04v4hyKr+QhytOE2XBZual7D7I4CjlAT49XnuIDnsILBroE+wzeG3RgHkf
         aKpPZ6tOC2iWHiRrGVpHjfOW9OWSe1El/yQ1bVWHaF68SnV7s2Tbz+Q9dGKuyBiCOOUI
         k1EfZRvJ+fJtsb8u7/K2kBo5MwX+4RKW+usn0kgiAOynxgT2NrGxhYERUWSTH2ttDANg
         pDNURVRkiKuubm2NanbZUE9zrgUoHUuCGWQL9bFZ3usxAgFGpoOnRfkifri2ViO14ywh
         Y8TVetp1OAUKuKxNbhcnCBmJFMoKFV6xHqdMK+03JZDA4b8Y1M1/rnfANyYCFSwODd15
         +htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792578645; x=1793183445;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y2MXVuSopof1u2e0UlPr5RPihuMcVA09Qb/rkeKWPFM=;
        b=jaFuC6HV5qagyIfXYFMn0V07T+WKQXFL+GCSW/z7yIfN0sucF+Nds1DJqzhsmSypjH
         UwV0b4PUDYQYy/etX8IbPHMr6rsUL9Nmw+UDYhsEwNBxMi45ZcnxeQIDbYtFCL6uaCUP
         WiMnESLmgriPYKhsyYYLyGbRMum4dMm2I7TIaGt24nfVUh60Q57+K0TSnjxiq8CE/uvf
         +EDXx8SDFvkhlIFCwNKTemF99h9MvmBCWbmY1pQofdID+EIn8ab5R/XNIa5C+vdSJ27N
         MWTlFWs5/tJ7M3nrrwjAUe8xzxQF+6HSKB3dTvHMjJGNkWs/Oa64A+07ghswU071JlQ4
         pLuw==
X-Forwarded-Encrypted: i=1; AKwUvBxW9ttyZTuBbbFmUteubEDrDx3+fvZGU2tObksDKwYmR83hfK/wOwdZdNNIEbxqOjCVjMrIhpcCyWnC@vger.kernel.org
X-Gm-Message-State: AFq9FYK+g9BWdxuuq1ZkH7f5qc+4Xuh0wpHl2bSAF7NpkZuKRzv9xsyn
	Y1/KMBlWC+e1/I2y0fgI842zNK4ZbSxtmh2gGMoH7BNztMdABLZhKXv+
X-Gm-Gg: AYBFou1YNcayYrJAxo0ytbIaXHGm/gqARyKmzfb5QfADhybRruTWaOky9RQoap12KBr
	BNbiiVBbMNkSUq8WCDT9YbDWRA8tpvtcssvzfmL4O6yiVdbw8etUTgaRMTRXzjLTxu7UKWVujHs
	ZklnokfZMUI8u5RAWNxhbykRJFmQsw7uPDLIEzTG3VR38ZxyTTF6g8PpWkSYAhjlWG/QUtY1eHS
	4G589Nwhk98HiNFW5Fuw1HgiYNZ9V4GExG/TkVb9lyj4GB3OHdjKsgLeZITrBz2wLJIZu/Q6iqi
	3PyXTBvqrUBguWBrVtlSkN1BSMNxKS2hYoX8WXHU0FemaYDjExp77i3hNpQhsDCJSXSFezWbw/Z
	VzVasmRNmEx/INbxHYc/KQThmSkCRlL8eyvrVvqop2fC1x6O+2hMlMBTF5W/z5S6z4D5DEd4SuO
	SDftBoKzYsLiiQUIK408EnftQnBp+BRVtV3Tyw92ECMtxx6JvR9Zm4ajaLNH2bYa0iskCRgannn
	wPfGZsLPQc6GG1jlM/lTABuN6U/EVk9HGwH2NjXuzmxqJ1Q0uMWRm+ZGwcz
X-Received: by 2002:a05:620a:29d6:b0:93c:635e:6f3e with SMTP id af79cd13be357-93f57f1d225mr356392385a.35.1792578645233;
        Wed, 21 Oct 2026 03:30:45 -0700 (PDT)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d9af50sm215318985a.8.2026.10.21.03.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 03:30:44 -0700 (PDT)
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
Date: Wed, 21 Oct 2026 06:30:42 -0400
Message-Id: <DMAG3G194BUB.JJKBBQWZCU5C@gmail.com>
Cc: "Boris Pismenny" <borisp@nvidia.com>, "Cosmin Ratiu"
 <cratiu@nvidia.com>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Dragos
 Tatulea" <dtatulea@nvidia.com>, "Gal Pressman" <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, "open list" <linux-kernel@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Raed
 Salem" <raeds@nvidia.com>, "Rahul Rameshbabu" <rrameshbabu@nvidia.com>,
 "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5e: SHAMPO: Do not merge PSP packets
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261021062805.3466208-1-tariqt@nvidia.com>
In-Reply-To: <20261021062805.3466208-1-tariqt@nvidia.com>

On Wed Oct 21, 2026 at 2:28 AM EDT, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
>
> PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
> makes it possible to merge those packets in a silly way:
> IP|UDP|PSP1|payload1|PSP2|payload2|...
>
> That happens because the HW GRO machinery doesn't know about PSP and
> considers it part of the UDP payload.
>
> Reject merging when the incoming CQE has PSP marker or the pending skb
> has the PSP extension.
>
> Fixes: 29d7f433fcec ("net/mlx5e: Add Rx data path offload")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h |  6 ++++++
>  .../ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h | 13 +++++++++++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  6 ++++--
>  3 files changed, 23 insertions(+), 2 deletions(-)
>
> V2:
> - Separated from the patchset.
> - Moved the PSP merge check into a helper in psp_rxtx.h, with a stub
>   returning true when CONFIG_MLX5_EN_PSP is off, and an en_accel.h
>   wrapper, replacing the #ifdef in en_rx.c.
> - Also reject merging when the pending skb already has the PSP
>   extension, not only when the incoming CQE has the PSP marker.
> - Fixed the commit message diagram and capitalized SHAMPO in the
>   subject.
>
> V1:
> https://lore.kernel.org/all/20260917175433.4090878-8-tariqt@nvidia.com/
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> index 3f212e46fc2f..5a340f1435e6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> @@ -218,6 +218,12 @@ static inline void mlx5e_accel_tx_finish(struct mlx5=
e_txqsq *sq,
>  #endif
>  }
> =20
> +static inline bool
> +mlx5e_accel_shampo_can_merge(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe=
)
> +{
> +	return mlx5e_psp_shampo_can_merge(rq->hw_gro_data->skb, cqe);
> +}
> +
>  static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
>  {
>  	return mlx5e_ktls_init_rx(priv);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
> index 2b080c39cc37..9fd1ee789de0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
> @@ -85,6 +85,13 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cq=
e64 *cqe)
>  	return MLX5_PSP_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
>  }
> =20
> +static inline bool
> +mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
> +{
> +	/* PSP packets cannot be merged. */
> +	return !skb_ext_exist(skb, SKB_EXT_PSP) && !mlx5e_psp_is_rx_flow(cqe);
> +}
> +
>  bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct s=
k_buff *skb,
>  				     struct mlx5_cqe64 *cqe);
>  #else
> @@ -110,6 +117,12 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_=
cqe64 *cqe)
>  	return false;
>  }
> =20
> +static inline bool
> +mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
> +{
> +	return true;
> +}
> +
>  static inline bool mlx5e_psp_offload_handle_rx_skb(struct net_device *ne=
tdev,
>  						   struct sk_buff *skb,
>  						   struct mlx5_cqe64 *cqe)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_rx.c
> index 903af3b3e779..d49f26323b1e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -49,6 +49,7 @@
>  #include "en_rep.h"
>  #include "en/rep/tc.h"
>  #include "ipoib/ipoib.h"
> +#include "en_accel/en_accel.h"
>  #include "en_accel/ipsec.h"
>  #include "en_accel/macsec.h"
>  #include "en_accel/psp_rxtx.h"
> @@ -2268,8 +2269,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct=
 mlx5e_rq *rq, struct mlx5_cq
>  	}
> =20
>  	if (*skb &&
> -	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
> -							 page_size))) {
> +	    !(match &&
> +	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
> +	      mlx5e_accel_shampo_can_merge(rq, cqe))) {

nit: we already have the skb from the line above, why go back to the rq
just to find the same skb again?

>  		match =3D false;
>  		mlx5e_shampo_flush_skb(rq, cqe, match);
>  	}
>
> base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d

Makes sense to me:

Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
