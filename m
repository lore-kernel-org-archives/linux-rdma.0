Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D183515CE
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337429; cv=pass; b=iXUxjOMy4oSMqcohNMxyCZcr9RuTvazcXJQxQONktgw/RP2dQ6QAkLszWusS2yIfXfDvw3/rsRmwYCgxMNN1F3UMdee5N74LTb5zhIq8bzShJgkHCfcymwHfI2o5YrP5tH41JNw2lUXMFwy9zO/k7FkeyoyO/MnG35z1slpo6OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337429; c=relaxed/simple;
	bh=MBWdR1GxlvvVqaEyNujZIDbcJb/clAS5HIycWC0LYf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cj8yTO5CBYS7nrvwsUKaz6WaDrwtxnVOuB4yu4B3B1ZlttBEa6g0JtoDDid4oLom27q04FD54u1oja7NS8Zq+zxVMMtwW08FHY5s7S/Jcz0ZEdHJQiqy6LTEONCW7e7sck6aEI78X+4AMygksIVLwsXPHwnQAgPUZoRj/VI92Rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=octane.security; spf=pass smtp.mailfrom=octane.security; dkim=pass (2048-bit key) header.d=octane.security header.i=@octane.security header.b=VIy4kl8K; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=octane.security
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=octane.security
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=octane.security header.i=@octane.security header.b="VIy4kl8K"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b02b1b4cfso903453f8f.0
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 18:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791337426; cv=none;
        d=google.com; s=arc-20260327;
        b=A4luj53dy1G8iypaLp7ZDVTQDyBDMF3er5hkLe9esK3vn0rtY3+lNSPzFZodFCuBO7
         TRefa5D4CsF8sFwIMqr0W60bgyQDiyUPVUkw4sY8TySvr/Fgdc8Fl57jZdrz5NcACOhu
         UAiaiRr/alxw3MMHL+S4eSh3aLpzlW7Asfh7nCqaZBkp/d7Es9BILZ4+XVtp4NMiJKYI
         Tqo9dpbZ1T0wM6INztCffgdKyRF/2gOaVDTLHye3FanlQM6S2dVdZb6PO5MpEJDldEUG
         2TkugE4ZOpiNmdvILg5RNOeWGPPnuMf0LOHZgcST3RO7gj+9tkAzGIGgWbaYlA9ykQ2k
         tmQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z2R0isuQWmYfjmDBBvPENUql08JMDQxxwrQkmjzWgTc=;
        fh=zGkRwm4CpTZBURNg1pOTO2WNAI8xDZ/TxpL0Tl2mfuM=;
        b=NV+VsJhgV78Y/RrAV05Tzf7E3FV8SboOBMZjIwCt1GyHlthX50lCheQmiut2VEPMGO
         fatC16tkggLPcz4tcDkK/zwX4UjfbV1MYabWiiMho2M7Xd7rw4zd0IWNvvMoKdStZ8fI
         cOyWAT5XCK09W0zkTfqlXlbGzPumhI+dN61Ty7XLM/sDDSlWlo8tGhtPcRFdLypgE5JW
         TYN84nTJ/z+Uk69cKvE3Pl/IxfH212GgdTbcZRtaOiEeaNh35T4UQsvdcZCzXCUwUlcR
         y/NrCEMZYkvCsE8BDyVjgp7rsODWLplR6Sc5SdfTHDNGJlKrgF5Z85fdS+Ys+zDLjdqo
         hdYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=octane.security; s=google; t=1791337426; x=1791942226; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z2R0isuQWmYfjmDBBvPENUql08JMDQxxwrQkmjzWgTc=;
        b=VIy4kl8K9nyYoJ4xTaIvuOA3XJmxtego6NP/Ovxz2YwHq14dsATF9Xh4SapdlJs+CQ
         /x09sWIL4C0wt3+QbNVyKeMrZziS2GNd/ysyZG87MI5kC/yRzi477L5C3V6tCTwvleye
         X+wb+N2Ala64VzrjYlOCm+rToIPHHRhctloxc93rgGhabklyurVXeah5ZJpfg8l0nPJY
         y+h8I8t51fp8wJj4dhBV8CVjtPZQY3YUeChHLeJ0q2KDG+3fxuM5qyyyUnwuxJuHSGOF
         wAbWM7BiabaQjuWnhDnfVcBuoDGOcBr7PSdFMjFFtxU0cQbfZjEH0tUhAqAbrM4TPksA
         9sew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337426; x=1791942226;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z2R0isuQWmYfjmDBBvPENUql08JMDQxxwrQkmjzWgTc=;
        b=sWp504LpPENCRMpvB6cMCq3S4pke5aMJYputuhKDVIFadIu+55Wj0cUNJbbD6TdQUE
         w3VtTAS/wHmL12doXG73b/KEEhVOEXR5rMM16eqHTmAoVBx8F0DHesNBP8BVQuRGZlcE
         sEJDt5OGj3tDjjxIp/D3HqGoWyKmfjXf40G0RN3E6Q2sVl8AtLbkA9qxhtjjR+MIWSsM
         yUVcX1mEeALeFAQ2nTO4e+CeyqdEFuapiO5vJLJPx7quqNZRSlel7LLTfhlKYx4cnjZ4
         8FxQ+hSLrUokTH/Jme27APM7aYrNc5zFKCgVOorlVTwMrgvOSFIGnXdsIAy3AuyqDNsC
         BtFA==
X-Forwarded-Encrypted: i=1; AKwUvBwLQjc3LwXPM+XBV+qByN566Sc6uv3mCpEW6HRUKeSIHSaqTZ6rrwRRyQPsK/67WZo3Pv481cJnAQ23@vger.kernel.org
X-Gm-Message-State: AFuF++mMftkeayoKyw1O8C0h/8QZbzgGeEKLo+9iS/62jcjyUgSl+OYd
	7wNSbxtvusgjCUrUaal4MmPw578aR56g6OfyBshrCezA5WiAcmfw6SnioX7AkDVpcnenmLAVAKx
	0ax8oYdKU6fdOUpr3dBws4x/1vCF+ecJYsfQTwbi0kg==
X-Gm-Gg: AYBFou3QKCi9Qz1dv1hAk57oUyv8Ew5zBYqD5OoZKYlvVmlW2s35tnPuNDK+X05GDCH
	9A4+vRxXYjNWqktuejFDMilCwNN/C5vP2y9hFCpjiXeErzWHnER6wT4a45hwuwpQ8aj9Wb7Zg4e
	RJi89iJpdinivC+g9bJmyfJfhZgIe0z1No3vo0q2lQmBykedvO4AibMy//0WPm8wH4sGxjuU6LZ
	t/M140hBcAphib3qCASCCs7RDoPZSWSZwYOCv8Sk4gADkCeLs4wTFvGRgm5AhjGH71edf9LahNV
	S/IfnfRRuURfidk2NWnNv9EsJDpY8fpqFIMeXsR0804GpxfRybWG0QKm6tQoA4WN8u+7Fg9zzqG
	/ES0e7rhc6XygMQTI6FwhEZBW5bOdNgzvnjMgCUUEWoM=
X-Received: by 2002:a05:600c:3f0b:b0:4a0:ec5:46d9 with SMTP id
 5b1f17b1804b1-4a180080187mr8701305e9.0.1791337425901; Tue, 06 Oct 2026
 18:43:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261006125720.81227-1-shubham@octane.security> <661e8b900c97d701382af26462bead7277eaa41f.camel@kernel.org>
In-Reply-To: <661e8b900c97d701382af26462bead7277eaa41f.camel@kernel.org>
From: Shubham Antil <shubham@octane.security>
Date: Wed, 7 Oct 2026 07:13:34 +0530
X-Gm-Features: AclHuK8z21OahSGKxZJkHHl4QwGCa6UFLpgcI58u5NRwTzLJWRTQgLKYVsOlN_Y
Message-ID: <CAEBzjKEFZdKWHa5puYH6dKvaesCf-KGmZ+Z=fFECRi_0PhiY_A@mail.gmail.com>
Subject: Re: [PATCH net] net/rds: ib: drop fragments shorter than the
 header-declared length
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, Giovanni Vignone <gio@octane.security>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Allison,

Thanks very much =E2=80=94 I'll carry your Reviewed-by on the next revision=
:

Reviewed-by: Allison Henderson <achender@kernel.org>

And no objection at all to crediting the earlier private report:

Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>

This bug was found and reported by our team at Octane Security. Would
it be okay if we add Reported-by tags for the people on our side who
reported it along with the first reporter in the V2 patch?

Reported-by: Shubham Antil <shubham@octane.security>
Reported-by: Giovanni Vignone <gio@octane.security>
Reported-by: Robert van Eijk <robert@octane.security>
Reported-by: Paolo Gentry <paolo@octane.security>

I'm happy to send a v2 with everything folded in - your Reviewed-by,
sungbyeongchan's Reported-by and ours. Just let me know which you
prefer.

Thanks again,
Shubham Antil

On Wed, Oct 7, 2026 at 6:43=E2=80=AFAM Allison Henderson <achender@kernel.o=
rg> wrote:
>
> On Tue, 2026-10-06 at 18:27 +0530, Shubham Antil wrote:
> > rds_ib_process_recv() accepts an incoming RDS/IB fragment once the
> > receive completion reports at least an RDS header
> > (data_len >=3D sizeof(struct rds_header)).  It then trusts the
> > header-declared total message length h_len: for the first fragment of
> > a message it stores be32_to_cpu(hdr->h_len) in ic->i_recv_data_rem,
> > and rds_ib_inc_copy_to_user() later copies up to h_len bytes from the
> > fragment pages to userspace on recvmsg().
> >
> > The number of payload bytes actually received into the fragment page is
> > data_len (after subtracting the header), but it is never checked agains=
t
> > the amount the fragment is accounted to contribute to the message,
> > min(i_recv_data_rem, RDS_FRAG_SIZE).  A fragment whose header advertise=
s
> > a larger h_len than the payload it delivers is still linked onto the
> > reassembly list.  The fragment page comes from the per-CPU receive cach=
e
> > and is not zeroed, so rds_ib_inc_copy_to_user() then copies up to h_len
> > bytes to the PF_RDS reader, including the uninitialized tail the receiv=
e
> > never wrote.
> >
> > Reject a fragment that carries fewer payload bytes than it is accounted
> > to contribute before linking it onto the reassembly list.
> >
> > The issue is reproducible under KMSAN with two hosts over rdma_rxe
> > (Soft-RoCE); the same reproducer confirms the fix stops it.
> >
> > Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Shubham Antil <shubham@octane.security>
>
> Hi Shubham,
>
> Thanks for working on this.  This patch looks good to me, you can add my =
rvb:
> Reviewed-by: Allison Henderson <achender@kernel.org>
>
> Also, this bug was found and reported privately by another contributor, w=
hom I had
> counseled to send a patch publicly before I had noticed this one.
> https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@nav=
er.com/
>
> I find that patches equivalent, and this patch was posted first. But I wo=
uld like to apply
> the reported by tag since sungbyeongchan was the first to report it.
> Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
>
> Thank you both for working on this bug!
> Allison
>
> > ---
> >  net/rds/ib_recv.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> > index bd6cb3ffa..fee77b6d7 100644
> > --- a/net/rds/ib_recv.c
> > +++ b/net/rds/ib_recv.c
> > @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connect=
ion *conn,
> >               }
> >       }
> >
> > +     /* h_len must be backed by the payload actually received (data_le=
n),
> > +      * else the unwritten frag-page tail is copied to userspace.
> > +      */
> > +     if (data_len < min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
> > +             rds_ib_conn_error(conn,
> > +                     "fragment shorter than header-declared length; fo=
rcing reconnect\n");
> > +             goto done;
> > +     }
> > +
> >       list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
> >       recv->r_frag =3D NULL;
> >
>
