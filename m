Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794262781;
	b=iGXy7IBjRPXm69jv9VM0COVvP5EyFYgVm4qN8M6KpCrh6Z1drGe5iC78c31dTDASFJHB
	 ZDdCwcglgsHZwnGuFpM5YzTsewXkQyfVrI5Y7WsjeAlbb+KSZ5izjoibI9nk/Wz4SdekF
	 mN/gYHu5HuKOU7+V1luVdUVb7ZtuEa/oW73imo8VoUGf0jgIV2B/xg86S7eLngvjIpPRD
	 elHLzSINUB9KsHq/oIbXP7GYJuT/mqdQ7o9VtAF/ZrLm5khPSsEnosQMugpedpDJVe7D1
	 fIOlbxvupD76F8boY09pnRCEc10RrYGIsUWW/w0CsETJydZlzw0/mVY0rqncEsMya+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262781;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=MP+WAilXYUhWawcb62odslULgFQa1HZ4MqYuoDALXQk=;
	b=RDTinHO8gnl80xveF8AN1aJBdR2437MhOx82JN/H7Lwj5Xed9ythcLp1oKL/SpT/mPPC
	 Y/s250YGZRQRysQ0rQ4U3DnaiH4KKE5NSU60NoSWvq+5gyNXrGlRmxnMBWNgA8cpgRPLF
	 YGuxeamrn/01MBrd8wmfvWgR/J2J4iGIUPEnNGs4qKeKGCQfvKhVYrx87AwX+7/2PbBmQ
	 d9x3OYsiPSXVQhz3Kh/5ROdNB89ZKLK8QY0R39N/pHvHAa7zLPKtkg+L9UvQnNSyK6n9P
	 wzXJmV3lm5CFbZOt5ynVAUdtWFVQtVodHevCQiUygPykKy66ZP7JXEjk7lQwBM+HsMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=everpuredata.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=everpuredata.com header.i=@everpuredata.com header.a=rsa-sha256 header.s=google header.b=U+7hfUYf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.53
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA4606A325
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8FA4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=everpuredata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=everpuredata.com header.i=@everpuredata.com header.a=rsa-sha256 header.s=google header.b=U+7hfUYf
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-745497ac8fcso483406137.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 14:19:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794262780; cv=none;
        d=google.com; s=arc-20260327;
        b=rdlxozc6mujYDz9X9EYN/uvm3HYVDqHxlqTPRQYt6Rz557MmS3d2BBDrdVbeZybLx8
         /jjT+1Th2jb/FDnH5cfBVDwT/56Su7/cTQkTv3ORwawP6CUnpQdD99TIc0jztVFetl3P
         pZd21lvgIpL+xJCQNsRulWedOvsqOvl23dgV25D/sB0pxNUUIO45haAxbUePCTJzTrT/
         b5CNlt/3VpZd8Z/pgRd1VaVlper+X3YPmekaw6SXAOg7AFVWtHZ2D3ts12caA1L292cJ
         HREM7H643d+gZNhArPTTL744GpH4hS3ZtFVE/Er9B0gkdNOdDpY8LVRlIG2+pa7kwHdR
         gv8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MP+WAilXYUhWawcb62odslULgFQa1HZ4MqYuoDALXQk=;
        fh=brkLLnwlxknjZXTq2faHk9nAzbZRW4BLkRthomr32tk=;
        b=GqPU7+E2pzzWiSs3ulm3HxG8QPtiaWwS9URB/ev1dlbHXD+fiTmH2hvWf7mlDt2IA2
         QuD7FVF6ioRvxsesrOQUE1pnopZShw3Brc3MgrcaWfCJklzqOqnZWE41OKRygU5YUQ8t
         IEERYrB3S9LVc7pX0U+AXjeiiNlFXpp/H+pHhglxzE0Btd0rSPWLRYqO2gU9bPp1szZL
         DPSZkbCQkF26RXd8H1eU9nFfGe5djy+6GX2EWuZ1GNInZ7tojfeKjbthulszhxVwpUFx
         ZAFEY2GT30j69yhdbIjuyWNZU6yJBQ9VhFvH3H9BSTCwGgch9uV1OhVXFoxrK/ABSV2k
         2IVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1794262780; x=1794867580; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MP+WAilXYUhWawcb62odslULgFQa1HZ4MqYuoDALXQk=;
        b=U+7hfUYfJSddCWuUxckhMhwwVvf4YQFBKE3rf1Ffnn40Rejr9+Yh38Ga+vgHW5lrDO
         u9zBamgBF4E9yKrbFaeNuXsqhU7D4jUwYHCs+p7/lLuhc+nD7UZkoVAxYTimQHOY+eEd
         FOjF6Rda6TddzuH8q6z+viwpegCRBhwpbr/PDuXBvjfwd/7wVfQSe/cMW/cw3sBAdxbO
         HrjbeK0dVcCQXC3Z9EPzXDXmSNajinR7ACfLkeWbPE9AeHc6ZU2UJsGI4oXlbjcsP3q4
         +4M5TmhBAX+zDVdunngxvnmR0/Mm8nRnNwnfUQjk0lbY7olcbMW5erdmQYX1KGJ00t4L
         ToNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794262780; x=1794867580;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MP+WAilXYUhWawcb62odslULgFQa1HZ4MqYuoDALXQk=;
        b=B7vNTH2hIDZ0SBno6YUaw5ixu3BSe6I+ial/gdEO3S2BAiyR6+A/1BlRMkSUsxgrwc
         MJ8GrZl0R8Y9necLwB9V3uzJpOPxMqdiTsYzQ4enxRhH1exxsWK0q6j0d0Dty9hpJJzp
         7zVN1AJS2vHRnjFwioEuoX5iAb/n2XgxLoP+P9um6vxuSy8TiziokIPnShcGTzX68Lja
         qItcCsCuN5eXzZdYIOH4nntkItGfbnkZEUPRMUr3yUP+pdgZUS1HEE6JkzuODyii5epc
         UO6SG43IjlJMUXxvRAKdQHS7i2Vv7tgITLqMK7hRTuz/2mXk/RqabvP/BbmvQavutuPU
         vaCg==
X-Forwarded-Encrypted: i=1; AL+hErFEJ9cStlQufdINHSCAYYEjrvb3FYFV7xIMqepIVfAGkModhxORV+XI38scpzrrclK2pgUJsF7YGkL8@vger.kernel.org
X-Gm-Message-State: APuU4Z9BWzuVTSBd2Z9/vW85hVIbCRMMULTYcJl5UVIrzkRGRaGcv/Nw
	OrSI4/iIkOaiWQEi5VbCAXhnS7IqsTOtqjETXtUo5rnzzFKtKP8ks5sjRTjZ1QesrTiBZf8Rbbs
	EmhT/T0CtYRnH9SN8B0AqVQM4C0kkw9l58aU0Y/MrtA==
X-Gm-Gg: AYBFou28Jjh4xx4OFa19BgKLnqg2mA7ppZDnso0iFtWL2iiaWjzttIdxaYzKNNUCRU2
	XNkZfgcvhmpBHJtaPhg5EvzHTjVY+T3mX8I/u8whVcsKXj+sQiUfFslCrBhQGvdi9JRbH80gg5J
	OBrfzVb+iUnPbLCvrVUZtr3uxO9Frduf1vT1Do7tRM57H+E6EqWfD5PBKWXiM+u/jdCazFzNZkF
	2YTnOyhVCzhpC93AoRaGLkbUt9AW1bWFlcu7YEqZcHnzSRwannnncIea+KMlSL251pD6/MYFpSp
	1b2St99KUXeUWxGvv+Jke4DE0/wU4fAAyeyotDjfqnVoew+//FcC7E6ZO3NOLPXW+kjv9DLX5Ar
	WUw2XNDaG0ukpXnFYPjqT9iSv1G2OmIPbiqLSLwHKg4ru+zoWT296GzbBbdIN7SK1mpsq6PtNWV
	A7UT8K/zAz67buUiTx2zY/iG0QV35oylIO3hLUUkmN/1CZ+PVNsZiuMPFOrV1gvYHBNOJxqVY9p
	NyfrlgmukYIcteLBgLG376R
X-Received: by 2002:a05:6102:a51:b0:7d2:d159:f425 with SMTP id
 ada2fe7eead31-7d301bd171emr279481137.19.1794262779351; Mon, 09 Nov 2026
 14:19:39 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109114734.2087878-1-tariqt@nvidia.com> <20261109114734.2087878-5-tariqt@nvidia.com>
In-Reply-To: <20261109114734.2087878-5-tariqt@nvidia.com>
From: Rishikesh Jethwani <rjethwani@everpuredata.com>
Date: Mon, 9 Nov 2026 14:19:28 -0800
X-Gm-Features: AclHuK9TsNUujWmbkc3zBgB09FhFzj4OUSQiMJsQdVHQFSB58CNhyZd_ZNz-s24
Message-ID: <CAKaoeS0AC-czE9g8OWi=+oenZYRsgXjRkSX-BsX2imHhKNW+QA@mail.gmail.com>
Subject: Re: [RFC net-next 4/7] net/mlx5e: Drain old TX SQs before activating
 new channels
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Willem de Bruijn <willemb@google.com>, Alexander Graf <graf@amazon.com>, 
	Aviad Yehezkel <aviadye@mellanox.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Boris Pismenny <borisp@mellanox.com>, Boris Pismenny <borisp@nvidia.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Costa Shulyupin <costa.shul@redhat.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Eran Ben Elisha <eranbe@mellanox.com>, Gal Pressman <gal@nvidia.com>, 
	Ilya Lesokhin <ilyal@mellanox.com>, Jacob Keller <jacob.e.keller@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, 
	Mark Bloch <mbloch@nvidia.com>, Martin Karsten <mkarsten@uwaterloo.ca>, 
	Randy Dunlap <rdunlap@infradead.org>, Richard Cochran <richardcochran@gmail.com>, 
	Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Tariq Toukan <tariqt@mellanox.com>, 
	Wang Zhan <wang.zhan@smartx.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 3:49=E2=80=AFAM Tariq Toukan <tariqt@nvidia.com> wro=
te:
>
> On devices with tis_tir_td_order, commit 3b88a535a8e1 ("net/mlx5e:
> Defer channels closure to reduce interface down time") closes the old
> channels only after the new ones are activated. Their SQs are
> deactivated before that, which rings a final doorbell, but nothing
> waits for the HW to execute their pending WQEs: the completions of a
> deactivated SQ are not polled, and the SQ is destroyed only when its
> channel is closed. Meanwhile, the new SQ of the same TX queue starts
> transmitting. A flow's WQEs still pending on the old SQ can then
> execute after its newer WQEs on the new SQ, as WQE fences order only
> within an SQ.
>
> Besides reordering packets, this breaks kTLS TX offload. The WQEs of a
> connection update its TIS crypto and record tracking state as they
> execute. When old WQEs execute after new ones, e.g. because a PFC
> pause held the old SQ back, the TIS state gets out of sync with the
> TCP stream, and the connection's records go out corrupted.
>
> Before activating the new channels, drain the TX SQs of the old ones:
> reap their completions until all their WQEs have completed. If they
> do not drain in time, e.g. under a long pause, warn, and close the old
> channels before activating the new ones, as before that commit. Move
> the deferred closure into mlx5e_switch_priv_channels(), next to that
> decision.
>
> Pointed out by Rishikesh Jethwani while discussing kTLS TX TIS reuse
> for TLS 1.3 rekey on netdev.
>
> Reproduced on ConnectX-6 Dx, with 248 channels, by changing the
> channel count between 247 and 248 every 2 seconds while 32 kTLS TX
> offloaded connections stream pattern data to a software kTLS receiver
> that checks every byte. On this setup, the new channels are activated
> about 230 ms after the old ones are deactivated, so the old SQs must
> still hold WQEs by then: with every TX queue rate limited to 10 Mb/s,
> 9 of 41 connections failed decryption in 60 seconds, and 11 of 43 in
> 120 seconds. With this patch, no record failed in five such runs, 7
> minutes in total; the drain timed out and fell back to closing the old
> channels first 7 times. At 1 Gb/s per queue, the old SQs always
> drained in time.
>
> Fixes: 3b88a535a8e1 ("net/mlx5e: Defer channels closure to reduce interfa=
ce down time")
> Reported-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
> Closes: https://lore.kernel.org/netdev/CAKaoeS1hj9XuM7ojLBCjGA=3DEXc2M-b+=
eRjC2Sk=3D8L_8XYeJ18w@mail.gmail.com/
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  1 +
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 88 ++++++++++++++++++-
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 41 +++++++--
>  3 files changed, 118 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/txrx.h
> index 24e91279243e..b5bd1b6e8601 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -112,6 +112,7 @@ struct mlx5e_xmit_data_frags {
>
>  netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
>  bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
> +bool mlx5e_txqsq_drain(struct mlx5e_txqsq *sq);
>  void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
>
>  static inline bool
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index c3c2c5720c6f..a721e30bcaa8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3421,6 +3421,82 @@ static int mlx5e_switch_priv_params(struct mlx5e_p=
riv *priv,
>         return 0;
>  }
>
> +/* Time for the TX SQs of deactivated channels to complete their WQEs. *=
/
> +#define MLX5E_SQ_DRAIN_TIMEOUT 100 /* msecs */
> +
> +/* Returns 1 if the SQ still has pending WQEs, and records the first suc=
h SQ. */
> +static int mlx5e_drain_txqsq(struct mlx5e_txqsq *sq,
> +                            struct mlx5e_txqsq **pending)
> +{
> +       if (mlx5e_txqsq_drain(sq))
> +               return 0;
> +
> +       if (!*pending)
> +               *pending =3D sq;
> +
> +       return 1;
> +}
> +
> +/* Returns the number of the channel's TX SQs that still have pending WQ=
Es. */
> +static int mlx5e_drain_channel_txqsqs(struct mlx5e_channel *c,
> +                                     struct mlx5e_txqsq **pending)
> +{
> +       struct mlx5e_txqsq __rcu **qos_sqs;
> +       int num_pending =3D 0;
> +       int i;
> +
> +       for (i =3D 0; i < c->num_tc; i++)
> +               num_pending +=3D mlx5e_drain_txqsq(&c->sq[i], pending);
> +
> +       qos_sqs =3D mlx5e_state_dereference(c->priv, c->qos_sqs);
> +       if (!qos_sqs)
> +               return num_pending;
> +
> +       for (i =3D 0; i < c->qos_sqs_size; i++) {
> +               struct mlx5e_txqsq *sq;
> +
> +               sq =3D mlx5e_state_dereference(c->priv, qos_sqs[i]);
> +               if (sq)
> +                       num_pending +=3D mlx5e_drain_txqsq(sq, pending);
> +       }
> +
> +       return num_pending;
> +}
> +
> +/* Wait for the TX SQs of deactivated channels to complete all their WQE=
s,
> + * so that none of them executes concurrently with the new SQs.
> + * The PTP SQs are not waited for, they carry PTP event packets only.
> + */

The regular/QoS drain and the timeout ordering look right to me. The
PTP SQs can carry TLS data, though. Their indices are in
real_num_tx_queues and txq2sq, and egress skbedit can select them,
bypassing mlx5e_select_queue(). mlx5e_xmit() runs the kTLS handling on
any SQ, and does not reject a non-timestamped skb on a PTP SQ.

If a PTP SQ holds TLS WQEs during a channel replacement, the drain can
succeed while its TX queue index is reused, by the replacement PTP SQ
or by a new regular SQ after a channel count change. With one TC,
growing from 247 to 248 channels changes index 247 from PTP to the new
regular channel's SQ. A fixed skbedit rule still selects 247, and patch
7's owner-index comparison permits new TLS work there while the old
PTP SQ is still pending and not yet destroyed.

I'd prefer to include the PTP SQs in the drain/close ordering.
Rejecting TLS data on them before any connection-state change or TLS
WQE posting would also be safe, but with a fixed skbedit rule every
retransmit goes back to the same queue and is dropped again, stalling
the connection. Excluding their indices only in queue selection does
not cover skbedit.

> +static bool mlx5e_drain_channels_txqsqs(struct mlx5e_channels *chs)
> +{
> +       unsigned long exp_time;
> +
> +       exp_time =3D jiffies + msecs_to_jiffies(MLX5E_SQ_DRAIN_TIMEOUT);
> +       for (;;) {
> +               struct mlx5e_txqsq *pending =3D NULL;
> +               int num_pending =3D 0;
> +               int i;
> +
> +               for (i =3D 0; i < chs->num; i++)
> +                       num_pending +=3D mlx5e_drain_channel_txqsqs(chs->=
c[i],
> +                                                                 &pendin=
g);
> +
> +               if (!num_pending)
> +                       return true;
> +
> +               if (time_after(jiffies, exp_time)) {
> +                       netdev_warn(pending->netdev,
> +                                   "Old TX SQs not drained in %d msecs (=
%d pending, e.g. SQ 0x%x txq %d cc 0x%x pc 0x%x), closing the old channels =
first\n",
> +                                   MLX5E_SQ_DRAIN_TIMEOUT, num_pending,
> +                                   pending->sqn, pending->txq_ix,
> +                                   pending->cc, pending->pc);
> +                       return false;
> +               }
> +
> +               usleep_range(10, 20);
> +       }
> +}
> +
>  static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
>                                       struct mlx5e_channels *old_chs,
>                                       struct mlx5e_channels *new_chs,
> @@ -3428,6 +3504,7 @@ static int mlx5e_switch_priv_channels(struct mlx5e_=
priv *priv,
>                                       void *context)
>  {
>         struct net_device *netdev =3D priv->netdev;
> +       bool defer_close =3D false;
>         int carrier_ok;
>         int err =3D 0;
>
> @@ -3450,7 +3527,10 @@ static int mlx5e_switch_priv_channels(struct mlx5e=
_priv *priv,
>         }
>
>         mlx5e_set_xdp_feature(priv);
> -       if (!MLX5_CAP_GEN(priv->mdev, tis_tir_td_order))
> +
> +       defer_close =3D MLX5_CAP_GEN(priv->mdev, tis_tir_td_order) &&
> +                     mlx5e_drain_channels_txqsqs(old_chs);
> +       if (!defer_close)
>                 mlx5e_close_channels(old_chs);
>         priv->profile->update_rx(priv);
>
> @@ -3462,6 +3542,9 @@ static int mlx5e_switch_priv_channels(struct mlx5e_=
priv *priv,
>         if (carrier_ok)
>                 netif_carrier_on(netdev);
>
> +       if (defer_close)
> +               mlx5e_close_channels(old_chs);
> +
>         return err;
>  }
>
> @@ -3499,9 +3582,6 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *pri=
v,
>         if (err)
>                 goto err_close;
>
> -       if (MLX5_CAP_GEN(priv->mdev, tis_tir_td_order))
> -               mlx5e_close_channels(old_chs);
> -
>         kfree(new_chs);
>         kfree(old_chs);
>         return 0;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tx.c
> index bee6f0bf1eff..eb20e3d14d46 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -780,10 +780,11 @@ void mlx5e_txqsq_wake(struct mlx5e_txqsq *sq)
>         }
>  }
>
> -bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
> +/* Returns the number of polled CQEs. */
> +static int mlx5e_poll_tx_cqes(struct mlx5e_txqsq *sq, int napi_budget)
>  {
> +       struct mlx5e_cq *cq =3D &sq->cq;
>         struct mlx5e_sq_stats *stats;
> -       struct mlx5e_txqsq *sq;
>         struct mlx5_cqe64 *cqe;
>         u32 dma_fifo_cc;
>         u32 nbytes;
> @@ -791,14 +792,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_=
budget)
>         u16 sqcc;
>         int i;
>
> -       sq =3D container_of(cq, struct mlx5e_txqsq, cq);
> -
> -       if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
> -               return false;
> -
>         cqe =3D mlx5_cqwq_get_cqe(&cq->wq);
>         if (!cqe)
> -               return false;
> +               return 0;
>
>         stats =3D sq->stats;
>
> @@ -891,11 +887,40 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi=
_budget)
>
>         netdev_tx_completed_queue(sq->txq, npkts, nbytes);
>
> +       return i;
> +}
> +
> +bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
> +{
> +       struct mlx5e_txqsq *sq =3D container_of(cq, struct mlx5e_txqsq, c=
q);
> +       int i;
> +
> +       if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
> +               return false;
> +
> +       i =3D mlx5e_poll_tx_cqes(sq, napi_budget);
> +       if (!i)
> +               return false;
> +
>         mlx5e_txqsq_wake(sq);
>
>         return (i =3D=3D MLX5E_TX_CQ_POLL_BUDGET);
>  }
>
> +/* Reap the completions of a deactivated SQ, whose NAPI is disabled, wit=
hout
> + * waking its TX queue. Returns true once all its WQEs have completed.
> + */
> +bool mlx5e_txqsq_drain(struct mlx5e_txqsq *sq)
> +{
> +       int polled;
> +
> +       do {
> +               polled =3D mlx5e_poll_tx_cqes(sq, 0);
> +       } while (polled =3D=3D MLX5E_TX_CQ_POLL_BUDGET);
> +
> +       return sq->cc =3D=3D sq->pc;
> +}
> +
>  static void mlx5e_tx_wi_kfree_fifo_skbs(struct mlx5e_txqsq *sq, struct m=
lx5e_tx_wqe_info *wi)
>  {
>         int i;
> --
> 2.44.0
>
