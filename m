Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A1F247291
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054141; cv=pass; b=KnVq087D6W2acAplnJJtkLoTW3UgfjjwjO66X/PL6oiHaRVkFRdNb1DTReQAnEawctFUqLKIwkX9zizOf3vnsw/OHKSwGePyX2jurSogSZfmP3SvJuUHkRYEhC6u+EOzN0iKbP8KhjaaRN471/TGcRnDS5/Nxno0JGyvxeJQV7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054141; c=relaxed/simple;
	bh=MHkYdeuq/GQ6cy9KhsMnCwJnFdIAwA10VuPadJacYhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gpJDQMbjCDKpN2ABcuPTSe/SXcCHGLFgZ9UjdUes/DJio8kd9igTfWg9O/pdbdO9TA9oJbzZVRIPgxgLzbG595ushmaPc3emRyt1RLoAC1p1Oy/FWpRZy7u+6JtananLkHflTdh5JVbaq+zEWVFR5/qBLov0+nF/JKuX4HpF+6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=HJNsURa3; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="HJNsURa3"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa917bfe8cso88780a12.3
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 22:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790054138; cv=none;
        d=google.com; s=arc-20260327;
        b=eBWpkDqDFPh0hC2PYbhP8JEiRzRSHbXMhHAifs8TO7BXbptPhgtZsPM1sWAFa3vn6N
         QbDCJOFDgzxjrVa78B1WniJm3tNCLQ2HZwrO2vEjGPGtYjVXIR7sL1sujdavhUv0DZVT
         rnfdwCz6+1m/wmx96B8El091Z1CDmIFywxk3tf9uZaVmbN2eyHmGeG2Kx6wJNSM4v1lt
         KaWtppng3e9+ciSrPsC0c3MbRpOvdr0Q4F4naL0qahfJJ5iB1HuGQFJrTYq+2FI6ekAC
         ltoe6tan96LOcdT2dcEOCAfuSA63cDJxs1qsv0t//HcL36d0WhDTC9ILeEq5lzB606f8
         pezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WgZFnKxz3ST32YIA6Z0zQdHgzABZKQB2kumQfi8K+Zc=;
        fh=oYPdTUy2uzCuUO5HNUk4vx8nzwfGYQ91o3e7PACIbC4=;
        b=T+RYUGpbdIte7MHdjVk+Ox80nanbyZzGRJ153BLeCfemE1rjDGlnJifoMNPLCOvGQa
         sWQoPbMjzy6Z0f4sK8XRtYIRRdebZrBOe8U12vwNQPDNegFGGAAwj9YVaSAt7UtuFay8
         TFPhQQPzjI87sX7qyHL0nBo9iLMeVQompUwynIBUEZR+ottR4E2whQCUpLn1ucpZVP/k
         ORiuouC5QeKYWXV3meQ1zQ5vQb/b37w4OSrCktBX1osJW64u7w5gfn4lYlDd74zZYLhS
         KX0aflD+SLZ1GhAsqi4TJtpPxKSCYvKJDX4WcBq64A78gcCTETHeavRAlNkBvq4HiW7w
         O4Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1790054138; x=1790658938; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WgZFnKxz3ST32YIA6Z0zQdHgzABZKQB2kumQfi8K+Zc=;
        b=HJNsURa3/SqygroKlnoref9VfzDdeHNVgDoM04f9UNlTMmAX+Wd2mOl4YCdXVK1XQr
         LXOC6sNN21qPs4uUGtWlbL659Wrtu2Ec75aXsHpFXsKQ7Hm4E0b3sLbP5Onw2I6Zu6/w
         6g2urWbIfMPPc5U7d00rgTDddjbMI/Zw+fEgigvo9vrtFKooRmwm7dlD5/9Mfogq1/sN
         p6mXsyysi3utiV+p6TvuBGI9w7o+eHdLHt/+CHQ4UVvYj4KVmszRFtrUyKMKC3BreYeW
         KVkzB/AX8uNYKmNU8urMKtFHf0QTZoFUnnaDmYoISZYBb38fxqStutrPBKV+Uecl7x45
         3Ang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790054138; x=1790658938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WgZFnKxz3ST32YIA6Z0zQdHgzABZKQB2kumQfi8K+Zc=;
        b=zjA/tQr+BRSKG6C+5zYTPtAIqENfqVT3YqA7VQnxooLTOorH4gupco5z+vTNrRLCbr
         nnsTwI+piEo6MmuYWYdoWh64hufu/xKxp0u2hRntVulLgz5j2PGuhFmzy3TDWG1lnePU
         jS2a5yHCQznmXbHxRiBs6f+KDYRvNOaJfDgwJ4Jm57bhvlKFC1jH7nedM594NGkajQZA
         C6kbeFOwB1za4kut6Vr86Gcmm75C8tDKIaQu3Ntx6v05ftz02SVCK4sYwhCiGBoY7D9W
         PogmpF922B1+LYdbulcd2AQk1OLgfYsKaIU5v9TjifCBnddp5Z2ac9NJjhaqHQiBhRuN
         GBhA==
X-Forwarded-Encrypted: i=1; AKwUvBwL/17HwYhS2WRWHCiR8lk7Jvb+zyE6CTdth07Zfr64AK7gzNyPYVv3cotylc5FajWhAFI4f+3BI/To@vger.kernel.org
X-Gm-Message-State: AFuF++n/ylgEW8sPnD1B1Xs55fkoJmu7dFkvhVAVsXO071Dp9cNFsqrU
	jfDV/dd7PvKm9sfmlmwmO58k2xnaef+YL+dIDTit7mtkg/Z2XhF6I0vzv6yMmbv8HAp6Y5aUTXk
	Usa3pNK1sHwL2yjM63J4gfiNNVSg+cwdZmfYYvxc7NA==
X-Gm-Gg: AYBFou1DoqsuMf4n1qGIIgxlt9u9AIVR8Wf2Oq4fAoa95hCzHYda5O1OsR+d1uNGgsQ
	kd7IBuM1FNLqLLW3txvj2AJ3/8NbX7MwH+9lsmK9xWJ5dGE5MOnuuVxAhQPemi5jxsIywKqVwxv
	OzD/1RWB5vjpVDS+oOxlil1XX696W+/RTNAbEfgngZ0xbvq2lxvL0wlQi0ugdoTV5k1VSxyiY1k
	SiuBzOVqTBNIuq/bW8cFM80c5+csJmVrZT26cVY2pgWOICosLYxnZ7LQmD8NcNUzR4ciNuRe/D+
	AoQHDJzPpOoIHD6PPn9r9XNIQwIGAa3bzi1jg/7Z12hOGZ/KBcSSNDo=
X-Received: by 2002:a17:907:7b88:b0:c16:604a:b2bd with SMTP id
 a640c23a62f3a-c2a1a9180aemr1226088066b.3.1790054137823; Mon, 21 Sep 2026
 22:15:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me>
In-Reply-To: <20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 22 Sep 2026 07:15:26 +0200
X-Gm-Features: AcwNN1UyR_asqLal6G0VDs_es5TmRoJuJKO4azcJK124CAiyAS2-MdQZQ0pBpKc
Message-ID: <CAMGffEmNYih7sQ7SFx670T+rgzmmE2QrtrkzNsdpuwgZEdPDZA@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Don't WARN on unexpected info-response opcode
To: quanyeyang@proton.me
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Danil Kipnis <danil.kipnis@cloud.ionos.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 6:25=E2=80=AFAM Quanye Yang via B4 Relay
<devnull+quanyeyang.proton.me@kernel.org> wrote:
>
> From: Quanye Yang <quanyeyang@proton.me>
>
> The info-response receive is posted for a SEND.  The completion
> opcode comes from the peer, so RDMA WRITE with Immediate is a
> legal WC on that WQE even though it violates the RTRS handshake.
>
> WARN_ON(wc->opcode !=3D IB_WC_RECV) treats that peer-controlled
> field as an internal invariant and panics with panic_on_warn.
> Treat a non-SEND completion as a handshake failure: log it and
> keep the existing CONNECTING_ERR cleanup.
>
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/linux-rdma/CA+0ovCge-K+hcGHXZ4R3Ww5+cg159ux=
HBeVbKeUSLBRSMT8OWA@mail.gmail.com
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index eac38b57b00d..3c23c27725a5 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -2514,7 +2514,12 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *c=
q, struct ib_wc *wc)
>                           ib_wc_status_msg(wc->status));
>                 goto out;
>         }
> -       WARN_ON(wc->opcode !=3D IB_WC_RECV);
> +       if (wc->opcode !=3D IB_WC_RECV) {
> +               rtrs_err(clt_path->clt,
> +                        "Path info response has unexpected opcode %d\n",
> +                        wc->opcode);
> +               goto out;
> +       }
>
>         if (wc->byte_len < sizeof(*msg)) {
>                 rtrs_err(clt_path->clt, "Path info response is malformed:=
 size %d\n",
>
> ---
lgtm,
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260921-rtrs-fix-rtrs-clt-info-rsp-done-3e5d47cfdc44
>
> Best regards,
> --
> Quanye Yang <quanyeyang@proton.me>
>
>
