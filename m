Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792477047;
	b=J+tRI1EsIjvtCl8mxJ/VcL5Zf8BF8G8Jh8IZRxJU2GY5aZwRHNveQkKRvGygppmTMlJ+
	 GUzr22SrlQ7CP9Z60nAOzZlie1mxCzpwjEYoCsdOXWi9wY+93ID/6gCnoFdIVhk84qARs
	 b7b3XWzM3aMT0OmrrxSIwPs/yTnhReuqeXHD5e08wu0yU5d9yazXxXKFZlCMeKAVlVLhp
	 JHQVXroKnAhOCMgR8S7mF9N8r4+abpiOJOoC+amVt0svKUQv8CBnzwu1qyu+xVL4LUYJX
	 hK5cM4wCNbYbQkI+VrjC5c2CXZ10IQG3J56pqSN8TTEzUbluDbp+VS4h+5guP46k5eQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792477047;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BrmzMw6cqUI5ufvqtaTGz6/71SoGnJjwK4qz0ikJtRw=;
	b=tEAT9c/A7YXTeuL/KuSBRrdOL5AkVcsW+R0kzoHWPL0pYKVwdVxH5klhDnHmArEV9xB/
	 BEMvEOWTDUPSW1sYgRi8Yk86OWDRVNixd7ZXIyzRXbcLz5zfY3xd+7FGkSeacqILjgsmm
	 9fR71NzhiZT3RdCqf/B54eLhmcbVcjgfa12Yzjq+c3M0Q+Ee4JF6GvNatXW9/zSP3VkWc
	 D4f/FVheI+wcDwXSsXE9s7k1Gj1++KIXaY7UfqiaYI/JL3wOs4Smxybq3A+h/RbUnjeSV
	 M+VSTYUGxpgYtUduXJgB7IjnVoLOf0m0H/NkguAglzc+w+nTj9yrIcUUMmSFar7bBEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=eH6K7l8I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FA1606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 06:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89FA1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=eH6K7l8I
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6afdd46afe0so516114a12.2
        for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 23:17:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792477045; cv=none;
        d=google.com; s=arc-20260327;
        b=p4FRVqkjObZnIFVRthgbwPnAbPLFsOekcdzO+0828MYIMsw1dBjkubS+jEjOQ2FlKQ
         RFqNEaszoEZX1wUZhwlaeCgJ0TwNgAJSK14DM8qFvNd7L3eXpL4EZWyH+u55dOwdukN9
         10Sq1orGSHVG4b/scKI+voWwCOihxB4Tbsg7WR4+vLngIfCaZ2mbiMlLrtOhtidswcaS
         +zisobCt+LRTQulD761/Uc5OsXhI5jRIQxCNguPvf9xRnQd4RY8yQsXnOgx8SGK3UUlV
         o3N9mE75Pskmru4r7mQTgyZIgEK/Elhc+riApvBCzygqq7RK70j06+ZP7TnVoadMR/wt
         tPPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BrmzMw6cqUI5ufvqtaTGz6/71SoGnJjwK4qz0ikJtRw=;
        fh=owXy62yG23FCCpq8RFKdRJPRqYm4vW9LLchUx1waa2E=;
        b=VrXowaRYwh4a73U7z9Tdd9aAftZ8LGsLxmsUyDpOasyV0HJu56YwxubsTsk1YFKolN
         sM/2704A+oy+PbvtCWinYwtg+wYp3QpiZu+9+/7RfLXgSD7Co1aq4bu9UUbzTLruLQ8h
         uobaZ4HqxQebjy3B/4MNB7sietgtRrjlIUhJdjGnO+/m6fVAM50O8MEijsHRQM6egA0C
         ti+uX2mx53HCxY2838Ek2CwQA21li/LKxMOjLYfXuXqGomtiOhG3tCCEPRX8j1T6t/kW
         xTbRRnrG2VQreEHfGhb4YoTzWWhd2GSkM9afWAxB6UoWLG5T1S5A7VhLuDNoZZoSPDQY
         b2iA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1792477045; x=1793081845; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BrmzMw6cqUI5ufvqtaTGz6/71SoGnJjwK4qz0ikJtRw=;
        b=eH6K7l8I3SY1r0RnHc7tAKBD3ywEGoX7EBEJve7cuUHOPVmc3sXZm7N1TZ93YJsy9o
         k2P6itpQ2i+6XFewnrnvprehWmwJedqIdhIcPvtF2Oj9KdWI4QgF6hoAMOS6kFM5qkkd
         AgsdsXlcFFHL4GgTe/pdnm8Gh11Lvh9fT8yl8I91xjC5lwIRFIhzAOoSvJ1Aj9UTmRro
         TX0DlVJdCx7M0YpaBsfYIEdXZ0cS2BHffn5UUJM2byfTb+2z8hrqKlfCAS/Rf/qUSQhs
         k64K5QihWxTl8YgyPvesTCzjsa5NtyhKeVaq790YzJtV+Utwzkeb6Y/anYAThukiSTrx
         dPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792477045; x=1793081845;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BrmzMw6cqUI5ufvqtaTGz6/71SoGnJjwK4qz0ikJtRw=;
        b=G8Uk3iR+p2fhS3ptMqnuhAAtMNmLCUnFeLz/QogBFhNw83Jo1BZb0G8+hDWk56ijwL
         RtdF9nC6MA0PXMnVuWUC3GOD+74nkpD4PV7mG+DAb9YtutZ0VcVcgPqnvpIhym98JhHp
         hppMsnrW0W1XGH7y4YKVHKKV6lUNRSKoex4McXDDZJVVlfC0Frsdk3cLhYCGQR6jsVRf
         T/hRMSIuSJv4/n0mcFusgTFMIKq7hKpTLfDucG4A2aTZ1ZpPqCw7tgc3wFI/kCBFyo+n
         uXv1WnMcm4hVgu59E5PUmzsRMsFn99/D/xeVXOCmhS7kDQ2McfjJA5//EN0V6RUqrTu2
         Rauw==
X-Forwarded-Encrypted: i=1; AKwUvBzDQ+P/4rc7XJyUFa2ZQsdi0dch0Wa4m4DmBggjV4gG3dnh2jo34kI8464a0N6VgsSTfSnKZzBrmjp9@vger.kernel.org
X-Gm-Message-State: AFq9FYJC+A9TJ0ghmY5Egujw1FgU+jQNLVcO+fS9rsS+4LUL1i1g9idU
	ooXdxCpl32F3FhqrVlz7HO1bKEiC45yfgJRpjiXtHmV4s8y6g3toYURHM0rbVSJ3MMSdb5tVIx+
	cu0k9dTZlpchgqAH59Ui1QFjF7ug2TzyZW4HIqmlwYA==
X-Gm-Gg: AYBFou3roTWJVKplUurewofXxJE9b7dz2OXaRMO4e010bKeeZ54o/pDG6MZT1cCVBAG
	I4tD4IwcHW+QwsYkiKcfZvbBg8fGA6chp5dOfURNkpygnjAC9CQITvvBgERyK3sVFOKyUDAj8sX
	sOq6AGUAQxU1NIkl8vi9ipj7VRo5R8cciV/cKf+JRjX/FVw4xuquWeiqH8FGxsB1CqzuvMojUAJ
	5WtpeaU53bMy6u3TKWkqLJuh7f7F9/qNJ7SRTiUrpYq74AZ+9raFAGtH83EcniQEMfHzJg4QxDf
	lGU7FDB+OGvI2KL/ZF5uME8CP+Jg/PzUzdCs7lOjNZXduDGKmMpesijmKFShlcxSfQUBJvEk4wc
	dMJlAE3szVDDQ
X-Received: by 2002:a17:907:6e87:b0:c40:b180:db3b with SMTP id
 a640c23a62f3a-c419e03afcbmr741266766b.3.1792477044765; Mon, 19 Oct 2026
 23:17:24 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261015125118.2966247-1-me@andrei-z.com> <20261015125118.2966247-4-me@andrei-z.com>
In-Reply-To: <20261015125118.2966247-4-me@andrei-z.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 20 Oct 2026 08:17:10 +0200
X-Gm-Features: AclHuK8yK-clpjX1OPiZivKHfrRa7B-1lxRg4XY5MMZMZt_hU0VbFUFNU3sACZ4
Message-ID: <CAMGffE=qjNDYdwx1PYgK1K87A4NhJ=cuR+kkUhdYH81gSGb-nQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] RDMA/rtrs: Post client read requests inline
To: Andrei-Alexandru Bleortu <me@andrei-z.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	Max Gurtovoy <mgurtovoy@nvidia.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrei,

The change looks fine to me, and I did some testing on it. However,
the data doesn't seem to show any clear performance gain from posting
inline requests.

Best regards,

Jinpu

On Thu, Oct 15, 2026 at 2:51=E2=80=AFPM Andrei-Alexandru Bleortu
<me@andrei-z.com> wrote:
>
> The RTRS client sends a read request as an RDMA Write with Immediate of
> a small message: the user message, the RTRS header and one memory
> descriptor, about 60 bytes for RNBD. The message is posted by reference
> and the QP asks for no inline data, so the HCA has to DMA-read it from
> host memory before sending. That read is on the latency path of every
> read.
>
> Let rtrs_cq_qp_create() take the amount of inline data to ask for.
> The client asks for RTRS_CLT_MAX_INLINE_DATA, enough for a read
> request with one descriptor and up to 64 bytes of user message, and
> the server asks for none. If the device refuses, the QP is created
> without inline data. The client posts a read request with
> IB_SEND_INLINE when it fits in the inline size the device granted.
> Write requests, whose message travels behind the data in the same
> WR, are not changed.
>
> Providers copy inline data from sg_list[].addr as a kernel virtual
> address, so the inline path puts req->iu->buf in the on-stack SGE.
>
> Assisted-by: LLM
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 17 +++++++++++++++--
>  drivers/infiniband/ulp/rtrs/rtrs-pri.h | 10 +++++++++-
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c |  2 +-
>  drivers/infiniband/ulp/rtrs/rtrs.c     | 22 +++++++++++++++++-----
>  4 files changed, 42 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index bf3a0377da3f..4a552e0459b2 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -489,6 +489,17 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *=
con,
>                                       req->iu->dma_addr,
>                                       req->sg_size, DMA_TO_DEVICE);
>
> +       /*
> +        * Post the request inline if it fits in the granted inline size,=
 so
> +        * the HCA does not have to DMA-read it from host memory.  The CP=
U
> +        * copies inline data from a kernel virtual address, so put
> +        * req->iu->buf in the SGE.
> +        */
> +       if (req->sg_size <=3D con->c.max_inline_data) {
> +               sge.addr =3D (uintptr_t)req->iu->buf;
> +               flags |=3D IB_SEND_INLINE;
> +       }
> +
>         return rtrs_iu_post_rdma_write_imm(&con->c, req->iu, &sge, 1,
>                                             rbuf->rkey, rbuf->addr + off,
>                                             imm, flags, wr, NULL);
> @@ -1714,11 +1725,13 @@ static int create_con_cq_qp(struct rtrs_clt_con *=
con)
>         if (con->c.cid >=3D clt_path->s.irq_con_num)
>                 err =3D rtrs_cq_qp_create(&clt_path->s, &con->c, max_send=
_sge,
>                                         cq_vector, cq_num, max_send_wr,
> -                                       max_recv_wr, IB_POLL_DIRECT);
> +                                       max_recv_wr, RTRS_CLT_MAX_INLINE_=
DATA,
> +                                       IB_POLL_DIRECT);
>         else
>                 err =3D rtrs_cq_qp_create(&clt_path->s, &con->c, max_send=
_sge,
>                                         cq_vector, cq_num, max_send_wr,
> -                                       max_recv_wr, IB_POLL_SOFTIRQ);
> +                                       max_recv_wr, RTRS_CLT_MAX_INLINE_=
DATA,
> +                                       IB_POLL_SOFTIRQ);
>         /*
>          * In case of error we do not bother to clean previous allocation=
s,
>          * since destroy_con_cq_qp() must be called.
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/=
ulp/rtrs/rtrs-pri.h
> index 59529d593869..bcba80d3c214 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
> @@ -97,6 +97,7 @@ struct rtrs_con {
>         int                     nr_cqe;
>         atomic_t                wr_cnt;
>         atomic_t                sq_wr_avail;
> +       u32                     max_inline_data;
>  };
>
>  struct rtrs_path {
> @@ -286,6 +287,13 @@ struct rtrs_msg_rdma_read {
>         struct rtrs_sg_desc    desc[];
>  };
>
> +/*
> + * Inline data the client asks for on its QPs: enough for a read request
> + * with one memory descriptor and a user message of up to 64 bytes.
> + */
> +#define RTRS_CLT_MAX_INLINE_DATA (sizeof(struct rtrs_msg_rdma_read) + \
> +                                 sizeof(struct rtrs_sg_desc) + 64)
> +
>  /**
>   * struct rtrs_msg_rdma_write - Message transferred to server with RDMA-=
Write
>   * @type:              always @RTRS_MSG_WRITE
> @@ -325,7 +333,7 @@ int rtrs_post_recv_empty(struct rtrs_con *con, struct=
 ib_cqe *cqe);
>  int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
>                       u32 max_send_sge, int cq_vector, int nr_cqe,
>                       u32 max_send_wr, u32 max_recv_wr,
> -                     enum ib_poll_context poll_ctx);
> +                     u32 max_inline_data, enum ib_poll_context poll_ctx)=
;
>  void rtrs_cq_qp_destroy(struct rtrs_con *con);
>
>  void rtrs_init_hb(struct rtrs_path *path, struct ib_cqe *cqe,
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/=
ulp/rtrs/rtrs-srv.c
> index 5314599d29fe..30fa4c7f64dc 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> @@ -1759,7 +1759,7 @@ static int create_con(struct rtrs_srv_path *srv_pat=
h,
>
>         /* TODO: SOFTIRQ can be faster, but be careful with softirq conte=
xt */
>         err =3D rtrs_cq_qp_create(&srv_path->s, &con->c, 1, cq_vector, cq=
_num,
> -                                max_send_wr, max_recv_wr,
> +                                max_send_wr, max_recv_wr, 0,
>                                  IB_POLL_WORKQUEUE);
>         if (err) {
>                 rtrs_err(s, "rtrs_cq_qp_create(), err: %pe\n", ERR_PTR(er=
r));
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/=
rtrs/rtrs.c
> index a642626e0ecb..08b8b1abb1d3 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs.c
> @@ -253,9 +253,10 @@ static int create_cq(struct rtrs_con *con, int cq_ve=
ctor, int nr_cqe,
>  }
>
>  static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
> -                    u32 max_send_wr, u32 max_recv_wr, u32 max_sge)
> +                    u32 max_send_wr, u32 max_recv_wr, u32 max_sge,
> +                    u32 max_inline_data)
>  {
> -       struct ib_qp_init_attr init_attr =3D {};
> +       struct ib_qp_init_attr init_attr =3D {}, attr;
>         struct rdma_cm_id *cm_id =3D con->cm_id;
>         int ret;
>
> @@ -271,13 +272,24 @@ static int create_qp(struct rtrs_con *con, struct i=
b_pd *pd,
>         init_attr.recv_cq =3D con->cq;
>         init_attr.sq_sig_type =3D IB_SIGNAL_REQ_WR;
>
> -       ret =3D rdma_create_qp(cm_id, pd, &init_attr);
> +       /*
> +        * If the device cannot provide the requested inline data, create=
 the
> +        * QP without it.
> +        */
> +       attr =3D init_attr;
> +       attr.cap.max_inline_data =3D max_inline_data;
> +       ret =3D rdma_create_qp(cm_id, pd, &attr);
> +       if (ret && max_inline_data) {
> +               attr =3D init_attr;
> +               ret =3D rdma_create_qp(cm_id, pd, &attr);
> +       }
>         if (ret) {
>                 rtrs_err(con->path, "Creating QP failed, err: %pe\n",
>                          ERR_PTR(ret));
>                 return ret;
>         }
>         con->qp =3D cm_id->qp;
> +       con->max_inline_data =3D attr.cap.max_inline_data;
>
>         return ret;
>  }
> @@ -296,7 +308,7 @@ static void destroy_cq(struct rtrs_con *con)
>  int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
>                        u32 max_send_sge, int cq_vector, int nr_cqe,
>                        u32 max_send_wr, u32 max_recv_wr,
> -                      enum ib_poll_context poll_ctx)
> +                      u32 max_inline_data, enum ib_poll_context poll_ctx=
)
>  {
>         int err;
>
> @@ -305,7 +317,7 @@ int rtrs_cq_qp_create(struct rtrs_path *path, struct =
rtrs_con *con,
>                 return err;
>
>         err =3D create_qp(con, path->dev->ib_pd, max_send_wr, max_recv_wr=
,
> -                       max_send_sge);
> +                       max_send_sge, max_inline_data);
>         if (err) {
>                 destroy_cq(con);
>                 return err;
> --
> 2.56.0
>
>
