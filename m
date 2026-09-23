Received: from mail-ej2-f33.google.com (mail-ej2-f33.google.com [74.125.228.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE73A05C4
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.161
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170334; cv=pass; b=qAn7iUEslGFM5lP9R871F+2mSMok3ESHQSdm2JPXpakBpZjkvCq4GIdr661AGCGMHLzYe2POrb1gQZrK0zQI3WddqoPUEoQ3BbpchZyMI2h8bbFkvCZvTJMynG3Fc/L+1c4Hgu/zJg7pk/zx3yZ+9CDvWE1dbVgls//p1W9yhJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170334; c=relaxed/simple;
	bh=+0Qare12DEG16J0RTiw2d8rZiqSc1q+82VNYMNxwBkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c1Yey/r6qV77ClMwKozhhhnhf2BlcHWxuv1PtKpdQdFHNFK2kmtMa/I4+1BkNV/P0VYwDXi9sc2O4spFtSVVbMGg1yyoQSs6e08YPEu+8z+Ejvj3GQSTZDZr2pDwRxWUYFrkzUTRMadga9ntgqBhRhE6pjWbI4ZEnU9EsxLdarw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=SRVclZrX; arc=pass smtp.client-ip=74.125.228.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="SRVclZrX"
Received: by mail-ej2-f33.google.com with SMTP id a640c23a62f3a-c2507a0a24bso9939766b.1
        for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 06:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790170331; cv=none;
        d=google.com; s=arc-20260327;
        b=OX5aJSXkCBMRDyOvsASnGTK4RSDwqiqtpYvXWmg/r71Iap5xjHDNVmI62f/iRfWdip
         fuy3TvvUu7iKw6Q7NJMJVIv4K6u6imfoIP8V+pnth7yoMxnbd5OswpPyYFcV/0xzKqD3
         N10bC9frhvtqTCXIoIb+Hy/Tn+aCHnu9D4jENlaWwdNH4X3iPB2x7Phvrfc8tGSt9+Xq
         eFbLe/zg7VPYX73hUq9fWF4nz3hBxDxeMy68bbl5cc7uHJ2pQCfh2peKB3ZqXSygjgPd
         6+X2/4Mi9FifShYm8rLO8kS5kzIVJrOVE4t/Yqlmo9wEjN1PlAXa4Wz3rThMpZCjGl3g
         TkPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H4MDp5PgB8jnunTOrYD+WPuYfJ5AZ033iUvzzeSKz7I=;
        fh=/qA8gWlncmtpcP0elWEABhT0p+gLdCi39ox8tcXXNrg=;
        b=DEYe8BzMwSZxD3maVP6dkWI5pDE17LMgNUCIViJWtnAdDX4pJV351/06Fc88zRbjYT
         GQSgqJvXMO6F/yCCJbU2tv1YLH/bxd1wIG3w8n8I9GQ3MMNVqzGv0/KvdHzvHLl8DRWv
         kFZorgdVyNMYmyAMGbfeAhGcBy6395dfcpvukRUwFEliaNDGKsGWL4YnI2JNzDuTugG6
         4GW+g8QWYZo5sK3CQWL0iXNVXnJqk8eIY/2R6BQe0AQ/kv6bjpOuHYHvId6NGUzZuGHY
         N52Z8jxmg2QT3neBGicRkZZMfU2V4HSaThm1V8ZOPE9KI8BjAi/1eCxzyFUNxCjH1NtC
         jXXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1790170331; x=1790775131; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H4MDp5PgB8jnunTOrYD+WPuYfJ5AZ033iUvzzeSKz7I=;
        b=SRVclZrXByFayujKHoeDlVyJyf0ZR5bJS4tDmTWLddN1I9oVIYnBktV0XXDjZWlXtQ
         0SutMaAM4Uzvuo1izxezZ6r7LnusHArRGs8gKy+BvKVpA741K0bOWAItOKPdzZ514Edj
         AWOQs00XBn84A8kfv316mV2QnzQ0hyhNnqQ/0CISiOyUmw4cnZFVxQnKrUxu0WmWrm5i
         uhd9WtQjhutE8p3nC8iG3+wPyd1f1f7vTXRxakm1tA033vNFukweWU9gjhx5fdk0NKpN
         p+af7rSA3ojRJMeaqZvBKyNLV+ejpkvu4XWFNKfFJRl5rQqqpC55nUYy2g4YpMd6JhBe
         McLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790170331; x=1790775131;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H4MDp5PgB8jnunTOrYD+WPuYfJ5AZ033iUvzzeSKz7I=;
        b=xFn/tumBeAlH1nYD2/jP9mIbRGvTiR8I1aN3qFkjdm7WggL68wg4FVmxCsU2UYuiJ9
         02/TATCo/mRL5v6EakQyKEHlFlQvb5ZZTjIxdXSDovuKMn9fV4GxKcLP2uFnCnMrYf+H
         Z8sS51GiiUO+eGg+xVU6a3KDY2yX1xc5fHXKLABeT2gFpsVNGC/6UB4JaFSqYti74xPt
         ZRpC2CNFsQm1J2qlPaq+KAxz1n5v5EW1O7hK9lpNVr4mJ5MCteXU+K0FMRrTXH40dBmM
         GeqDx2Xsmi/TZGS9c7ZgKzW9lRcCFwqGJNnWEP4BVyEVD8ObbsYdawqjod7glD7n6CsO
         ajZA==
X-Forwarded-Encrypted: i=1; AKwUvBzBg3edvZ4PPQQH/6Iid3DaNpNeTg4WxaqMbaA06qxkPCHxnT4vgRhVz1NqWGeCkpP1KiWIrWuwsFvi@vger.kernel.org
X-Gm-Message-State: AFuF++me+Kp5NRENZXR20bAv2GKlRMw4vmpqTQVNEFBmCC1JlrmLgNKh
	Nf5Fww4Dr+6208jSDsFZd5HMweYlC5ABT+IdLyJF7nu0AeMmwE6k0vm3e7G093rIMLs5zY8suNy
	6742CqUPb71dM6cYyfoaD8KQd5V1JyOjN3ivvv14zag==
X-Gm-Gg: AYBFou3Oy475/n9f9+UdgYzXPfLCIzgMZdghuYRzFNc5TLdxm9EsSaP9jiITYEJIHIS
	7idRcSGT87YC8NZqZapFcXA6iV+FxZpcZSITX1ueD5ZDNdlF8xMm3rlee20VslW+sT1Oa1ikAJe
	K5bFtNY9me3a354dAUesG+UJpNlb0rUtMhUVsEQug4BhHaSBUbmdz5RjyQddFQfhf7b7+yvsdl7
	qUORaIwwAFj/zj6dULTniQAOS3eZ5jya6McRZOInGFgn/1Bn4dk6TP7jxU7HY78HNXrsLmLKgEX
	UKTN+qPHDBEu0WvtCrMQlcXaij99uCCEiVmlEwiaZAk25EI99QFIKGGYC47dxVT7UyQA+tbOcGG
	gkk4idmjWH2Q=
X-Received: by 2002:a17:907:1c0f:b0:c29:39e2:4aca with SMTP id
 a640c23a62f3a-c2aadf99d35mr234469966b.1.1790170330903; Wed, 23 Sep 2026
 06:32:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
In-Reply-To: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 23 Sep 2026 15:31:58 +0200
X-Gm-Features: AclHuK-JI9gNDHI74Pa7OJ16UAjS44ttJQLfTEw80Hvw4-kf-qxNSlBP2Q8proE
Message-ID: <CAMGffEkQ8tZZcrLp2Sc7UyZoqAyBoYMdkPhGvHX7RGqrwSmJzg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
To: quanyeyang@proton.me
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Danil Kipnis <danil.kipnis@cloud.ionos.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 6:10=E2=80=AFAM Quanye Yang via B4 Relay
<devnull+quanyeyang.proton.me@kernel.org> wrote:
>
> From: Quanye Yang <quanyeyang@proton.me>
>
> queue_depth is taken from the server's CM private_data and later
> used as a session invariant.  A peer can send 0, which the client
> stores and then trips WARN_ON() in create_con_cq_qp() when the
> next connection is set up.
>
> Reject a zero queue_depth on ESTABLISHED, same as a bad
> magic or version, and fail the handshake with -ECONNRESET.
>
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/linux-rdma/CA+0ovCg_sG8gaZXXj9zmOrpxRt=3D8+=
-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
lgtm, thx!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index eac38b57b00d..7fbbb9a53607 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -1853,6 +1853,10 @@ static int rtrs_rdma_conn_established(struct rtrs_=
clt_con *con,
>         }
>         if (con->c.cid =3D=3D 0) {
>                 queue_depth =3D le16_to_cpu(msg->queue_depth);
> +               if (!queue_depth) {
> +                       rtrs_err(clt, "Invalid queue depth %u\n", queue_d=
epth);
> +                       return -ECONNRESET;
> +               }
>
>                 if (clt_path->queue_depth > 0 && queue_depth !=3D clt_pat=
h->queue_depth) {
>                         rtrs_err(clt, "Error: queue depth changed\n");
>
> ---
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-2160ee358b4=
e
>
> Best regards,
> --
> Quanye Yang <quanyeyang@proton.me>
>
>
