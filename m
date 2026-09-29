Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8064038A733
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 03:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790654033; cv=pass; b=emMITQeZGbF6KmVqYmeWAYb2bvYjbykPbxxQVFRRJ9iE2rmUB8LH7MVVEnmHIzBuk7PeMDOjIVBXnQjRFTndgJ3cM0Ob/UX6E1dQ6pncG6HZ7zA2bA+63OW57DiMUnnyHuDq/xkkwaLZcB/faPMNKf6AFU6C7vGsZ0NvdvQJ9lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790654033; c=relaxed/simple;
	bh=oDPU1YPGO7/v11Pjp8y6wBhZmRZ7wJ3J/ADnhDXmgp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kAggzKRz3m8yZQriqhuAFCqYrUTl4csp6pUfqfu9Ce1BrjPoztVFYeErICg89wAePR4T8wVjkYvGCF0ckpWZTGnEtYXzQtiJv7n1aFYTz3J3BfpZYuMWN9w8e+br9YFuCuKdfmptiFoJkV6ESY5Q6dPSRfL5YdxsyTli2eFk510=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=ha/HYjI7; arc=pass smtp.client-ip=74.125.228.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ha/HYjI7"
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac9a5236b3so181963a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 20:53:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790654028; cv=none;
        d=google.com; s=arc-20260327;
        b=mTuqwMzq1gmVInFwn7vEg81TraPiMDGd67C9ALHlQtw4omBYAV0r5/L1jIISl3STk3
         LxCAo5NanAnOLIdxcbqs3x6eYMb6r24BsfdeiGyuUwUcpNE1Hga/K+PHHtocA80ad+hY
         9Kg/dP86b54bmjD5JcddLZKDvOZK9a1RaY7w/ZT+2Hv9CFrqidWli+BxLLl3oqfCTDc9
         CR7Iv1N0Q2MDNrR/Tv1gT/4cSw2aLDs8mHwHW1K29uWwDjLy/6Q6/fDnlQthbY/tc/y2
         agxb46u42Aak4w96sY7KKA+Lp7Lz8Xbd9gn5XQi42ngPvCvaYR/GCjiDdz1263e0MM+N
         jSOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sWUVfweHp7S7+yh/aJ3eFYtiBr5kHFUHVTYD9vlOULE=;
        fh=HAH0/jUZNtKIfWSh/AM8m4Ir5qrrVJrzcn8/B7LVy5A=;
        b=Bw7D0cjeUdgAfMhv1mwQ6cuKog9LiRHsQ1S3rDXb00TqcEcAr5AQiOUWBnlazfwL6t
         LQvvUwjM3Nf2CIzEHVfcDFI7cmMK0ObWY2ynuKdIiIgEK6Zt8u0jNXzXTB2ILjlP0pT+
         P2uxUwDDSFUsxWOrmksthvsYmdjOj2IqdtC1Lzfw7SH7zJjPd/R7MKWtQgfXUE94CjSc
         MziKnoJJQ3fuqlzj8jgcEufyo4FqSqrudsqnDHsuKVkRz7h1rQb9pwc3DOa4ndhX7jad
         Yl/5ggNeOB8dR5SMX5kK24Wgb77+aTM4B7iMgYcUD1153/JTyrku3UdD22tTf4yR6DNB
         kp5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1790654028; x=1791258828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sWUVfweHp7S7+yh/aJ3eFYtiBr5kHFUHVTYD9vlOULE=;
        b=ha/HYjI7M9cYdlJ0wA+WrN+2uiHc4yTFz6yZS57ZSxLotwKhsWfYQxOURUSKcURsD3
         BjuDtSd65dySNVTQfXov2PawDSa+dl943mYzFp8HxyMmfWP2Tg3S5k3Hy1S0LRiPoTuQ
         NlyYXwXBNErzSPm+gfndWkZVM4dld7vNWoeY+4pPIjKKEbyR0lRDLI1oyRsuCa44F3BP
         92bwCEnarEN4CCaX18xRMp8I1FV5ihvVrZsnUK620iwFsN3Dha2Da7B50daC5FHSs9gT
         O2t+ouVtZoxb2QFwfeq+57JVxNRjMcKBVYP2yZ+KptYC5HpemSBR1XZ7h/QrJ9KXbcoW
         lbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654028; x=1791258828;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sWUVfweHp7S7+yh/aJ3eFYtiBr5kHFUHVTYD9vlOULE=;
        b=ElhxlLhLlqOcR5O9O5LCenb3XQvwCqCmt5S5lQhT8Eg9fdgVXBY/EoZcdKugolVj3B
         a2N+RGVd20hKzPbIuiXyrbiFlGDtyQ5ouBWl+6zdMPqfHKCtciSvMIcGw8mdzYEp5mot
         V+/BLQf2Ivhr0e8f9B+rqCXm2jJwoMc7rsALh6JZI3+6i9eOzRiNFuV//5gijFwwTmSW
         NTiYWATFtGysuYRQF8Sr2RsKD20MAe+8jJrv6oTKRE4XhM5Ceid9MFQwojNruuAvn1lQ
         lhjoeqBzIKUIVw8az7JvotD3K7QHOJvzc2dQs1KKkpnXhzv57/jqcgo0vGlDqMdrTv41
         l8tA==
X-Forwarded-Encrypted: i=1; AKwUvBz1QrbLI9n9i3KMFRKObK85ZF4JO2LLMLi6XnYfcrka+DD+bo7KBYJ1qiomVSNT7CfpzK700s2gwRfI@vger.kernel.org
X-Gm-Message-State: AFq9FYJwBSOxf3oINIpDjJ31lc+86FIhyzZt1T+kkZQLx3uTlP/xXaUP
	dXE3ooeI0e9VaPGu9tOsQBTFJId/hQ+aIYNh3BKxCWL43eZVpqCHcsWb4RpVFF/C/wz/owzxzx6
	OnwOArErUYnPoGpuKactuW2/niCm+55I9u9mcT3zbZQ==
X-Gm-Gg: AYBFou1++UpG+3TGtH9LqyOUPua8cBCBImrI7zLD0PTE5tFt5Udekcd4Ak+T/L2mlt5
	IvQ9etZYAWoPa9OPDuusKY7ahmkNVrXWaVbhTDygF41WKIqR90i3BJ7Pjdvs4ICEX6lhqpHm1DO
	NG3NijxrPUaGuX+06az3WUPvAhs4SZ8pzymbbrTrBwVGmZ7HksrW0jdNTjDTv/N3T7U3qZSRGuU
	sRdHYo69TsCeWhQpkcbGbcSMJdSJJ8j9SsE+korLkwnWBvZcGS8thUYnFapBiBJKuEoeT/bCjuM
	mNYP54jrtpXdjaY7P9KRBeC1vWqw3pnndTqtkYw2f0fAWLqObos0gks1dEpiRnhBVQDEzOH1O/I
	yTr1vPByaSqM=
X-Received: by 2002:a17:907:9409:b0:c29:4634:5c8f with SMTP id
 a640c23a62f3a-c2ada647ed7mr1055260066b.0.1790654028636; Mon, 28 Sep 2026
 20:53:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
In-Reply-To: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 29 Sep 2026 05:53:37 +0200
X-Gm-Features: AclHuK-5Ax-5HRhJj79aeHp660dbmq9BrXi-hDQnBQk_mf_Pyc_xT0DQAfYRBLk
Message-ID: <CAMGffEkMp61Q4EOp+WEVH42mZSd5BMWVbe+dm-Gnr3CUN09E=Q@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
To: quanyeyang@proton.me
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Danil Kipnis <danil.kipnis@cloud.ionos.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 12:52=E2=80=AFPM Quanye Yang via B4 Relay
<devnull+quanyeyang.proton.me@kernel.org> wrote:
>
> From: Quanye Yang <quanyeyang@proton.me>
>
> process_io_rsp() indexes clt_path->reqs[] with the 19-bit msg_id
> taken from a WRITE_WITH_IMM immediate. That value is chosen by the
> peer. The only check was WARN_ON(msg_id >=3D queue_depth), which still
> lets a completion run after free_path_reqs() has set reqs to NULL,
> or against a slot whose FRWR is already gone. Either path
> dereferences req->mr and can GPF; KASAN reports a null-ptr-deref at
> offsetof(struct rtrs_clt_io_req, mr).
>
> Treat a missing reqs array, an out-of-range msg_id, or a req
> without an MR as a protocol error and recover the connection.
>
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/r/CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-Wra=
tpUE6jczHw@mail.gmail.com
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
lgtm, thx!
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index eac38b57b00d..f8d3c6f37e3e 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -489,18 +489,22 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con =
*con,
>                                             imm, flags, wr, NULL);
>  }
>
> -static void process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
> +static bool process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
>                            s16 errno, bool w_inval)
>  {
>         struct rtrs_clt_io_req *req;
>
> -       if (WARN_ON(msg_id >=3D clt_path->queue_depth))
> -               return;
> +       if (!clt_path->reqs || msg_id >=3D clt_path->queue_depth)
> +               return false;
>
>         req =3D &clt_path->reqs[msg_id];
> +       if (!req->mr)
> +               return false;
> +
>         /* Drop need_inv if server responded with send with invalidation =
*/
>         req->mr->need_inval &=3D !w_inval;
>         complete_rdma_req(req, errno, true, false);
> +       return true;
>  }
>
>  static void rtrs_clt_recv_done(struct rtrs_clt_con *con, struct ib_wc *w=
c)
> @@ -562,7 +566,8 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_co=
n *con, struct ib_wc *wc)
>                 if (WARN_ON(buf_id !=3D msg_id))
>                         goto out;
>                 clt_path->rbufs[buf_id].rkey =3D le32_to_cpu(msg->rkey);
> -               process_io_rsp(clt_path, msg_id, err, w_inval);
> +               if (!process_io_rsp(clt_path, msg_id, err, w_inval))
> +                       goto out;
>         }
>         ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev, iu->dma_ad=
dr,
>                                       iu->size, DMA_FROM_DEVICE);
> @@ -634,7 +639,13 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, str=
uct ib_wc *wc)
>                         w_inval =3D (imm_type =3D=3D RTRS_IO_RSP_W_INV_IM=
M);
>                         rtrs_from_io_rsp_imm(imm_payload, &msg_id, &err);
>
> -                       process_io_rsp(clt_path, msg_id, err, w_inval);
> +                       if (!process_io_rsp(clt_path, msg_id, err, w_inva=
l)) {
> +                               rtrs_err(clt_path->clt,
> +                                        "Invalid IO rsp: msg_id %u queue=
_depth %zu\n",
> +                                        msg_id, clt_path->queue_depth);
> +                               rtrs_rdma_error_recovery(con);
> +                               return;
> +                       }
>                 } else if (imm_type =3D=3D RTRS_HB_MSG_IMM) {
>                         WARN_ON(con->c.cid);
>                         rtrs_send_hb_ack(&clt_path->s);
>
> ---
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260923-rtrs-warning-inrtrs-clt-rdma-done-3a72d73550b1
>
> Best regards,
> --
> Quanye Yang <quanyeyang@proton.me>
>
>
