Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792423042;
	b=dbRpadvYSTe93db8bTAgKlY8VK2w8+KsPntG6/75bYYNDQxDIQK5muDUgYkhAfuYpugn
	 y2ITVHO1rwx3NxQPcXlxx61vD+Bli5Wc9RbcV6r8MKchk9fIGcAEhTQiM0QSbDfVVq09Y
	 0TrPG07b0xpjQg2CiefCCc/j6MqtDIwXARptVA9jhN8rSmw6GJi0aINMun+xZGEp39rBJ
	 w6AoxNhBavX3rxaBeQB+rG7J7qd4XW6Jvf+V/KEpMac8P/KcXa1Iw069qOpV5lYnnulL3
	 PZ77Kq7G2RIjmUMv7txyiBcdV6MOs6ZD5SEqVxG2D7+8demRAtliInXHBJU6VBIsBZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423042;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=g80TJgftAYOuY1eEY8Pj3cKxe/RJlcWG/Y9dI5fdM0I=;
	b=xTGKqWs4bAgsChDuevMMz+zoYvdPgDM85+PcsPfelD25xB15gNqyJxSibVYWj8Hcq81k
	 x4k6LpEeJdgLq5LYGMhWDjrVrjY6+8biT6hNT0rlS61PaqTROPFueRKgAEGAFUXg57RR8
	 Nb/4t1OX4GzMK06AONVGFDIX1i9h/bOo7E/IMXCsbYWdu1ZuKbaUTXKwraiMGrvm0/Lqu
	 gOvEJEF6cqlRmSjQ355f7OUZ6znUd1U+ltBAdxPdNZnAdjK70EpmSTbGF8Efil44d/8A+
	 ZRnVRJNBG7HtK2DoJJFsEi2Aq+ZwrEo1xFHFIHpsC9pCI85y7rj0FU2y2A53bt89WPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ezLXwHIz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AAC60A0ABF
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 15:17:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91AAC60A0ABF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ezLXwHIz
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso16076a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 08:17:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792423040; cv=none;
        d=google.com; s=arc-20260327;
        b=O5AdOP6GN0/aTAGOeWHjOK/ns0TrCEGZR76ha2dcyr9JbUMP6eqIyjuwljgqaJm92H
         4dN7KBYzJ2Hons5CWFu3SJgqRMHFH8T5q0juYWdYLjfNH5Py3lPd65/e2qS9BLdON4Xp
         6JwTMqsnX9p2xZe8vLYJN/cGos7Jn/2yVTC0mMNUTi0JWNKLV7aPcijc8avrO9+bDbYx
         OAW/VArvMDIcqPg6zGiElvmVcYVW1OG1AawCN/hf6PxSqXopF54x/ueIHs7I/LvzTcPX
         qSgRcy+twO8vIBo+llt4A9niXcuJ0/Dggq/qT2XzqnuVNsbjCCW/eWEgLMVixkkPhBkV
         pYgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g80TJgftAYOuY1eEY8Pj3cKxe/RJlcWG/Y9dI5fdM0I=;
        fh=MTk3bm5688q4bBH0pQxYwxEX5JN4oEZYDWL7hfNrbq0=;
        b=pjAO3U0c4M/54jVHc/d/eNxkq0eSN2pptsuWrwX4XOBHjG2G6Ln4w1uSfneTLzKBWf
         ibttyQaDvkMtkNAvBXVT/Rm8IvYVu2Rgx+uEYJnsy9H9QLtS9E8ytWnXNXgHlOTrObn9
         H5A3NTNIkO52p6Zn6ZAxiN2879M4+z8n4I/Wiz2V3ia3X+LZ2AbaTf2gDm4luBb2i4Zm
         ykVrZtm79bL8QMKPdI96Kdcc2gc4cCZ/UKT41l3ZI764ugHwvB/vmsWd/vYOgUZXR4SZ
         A3F3I9SMlXdnLNCqG+Zy5lFBTbdg03DYXWYWhHtZF4XRaEKEcNB9x6E94nnjd4TkZ4Gi
         qAyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792423040; x=1793027840; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g80TJgftAYOuY1eEY8Pj3cKxe/RJlcWG/Y9dI5fdM0I=;
        b=ezLXwHIzPfS4sEb4a/lZXhXGEhuDtOUs1if1P/9Ak+Qq4maPAojdQ/9u0w1JCobLs6
         X2qdgAH/pLcQQVTxacqSHUYx6U1JRUcIZn4tCqNb3LkXxjpcgVHNqa3WoTOGvqyOills
         BiT2SHvEyuzjoiUDwEqrkKaqqIzh6GuaX4ulvYHeJnHQYLR1ElbgGP4U4xx7Lagi2fO0
         Vynf2ZaV+Wzz0LcbAkKRjY0IP9jZkLPwazVoJg22qEttAj4FtBF1o+o2OJakE541fU8u
         FgKrm31Dik2dQYyZFm8ilfQpMr5pGVDf4JR9znCUx7KiyvzqmlL+y1djjhWdf7HTbGCf
         568A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792423040; x=1793027840;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g80TJgftAYOuY1eEY8Pj3cKxe/RJlcWG/Y9dI5fdM0I=;
        b=biAmvpC7pGMCOX9p2CGh1OUwkBvCUdYo+0m+ySWqnRq9eZQOkB33d05qn2yOwnfnpI
         ElXoP+GMEIo5MfNnJ9HfxB/pZ1xROJlflV3PS0F/rmME1JrSLmox2Q2gGl3HDVI34DEY
         dJ+XB0JGN+rKScPBFwBOg2egM5lggwLcU+pTWRNmlsVdMzxtqb4ryU9HDfGa/MWjjjN4
         ZTBnQSE2Ng3fbR9tS0obOVn/PhYJDq2rfB2vd2RK8W0RKOGs6xxWBnrO/4hFwSkOcOSl
         WvzTy2JY0jc7wT1tUDyvdlnM5EIovFIz+FSZ0za8fvei/h+etc8Oku2o21OAqoCvgmn2
         dl8A==
X-Forwarded-Encrypted: i=1; AKwUvBzK/yKstgWBkYcmvDXRTZQMlzM32bFgyJbTEPMBQtv3ktt3wBCOjmAJaro/4JyjB/5k/NO+v+LBsga9@vger.kernel.org
X-Gm-Message-State: AFq9FYK1psoDT0QMXi2f4UMVsNw9QSCfy9dkok7XheSj30i5EqfDTPSa
	Cvov/B3RuuTM5izJLWUkoWHc7a80nFcifrvIakBRUZ5gSsLztLHrC0szTdflZPtLkcgG2NGPCqI
	M4dZFG8adPHej3bHqsb1J7LUzoUHd+FVmw829FfTT
X-Gm-Gg: AYBFou28UXv9lGQUGHedg7nFFuO7EttX49F+XrJQgU6VjtTm5QyUQHoOL+zPR1EOTp2
	UAPiTC9GlOqf8aks5d5bco2Fx//X34l6gocvi5OQ0stmWa/bzVpj7C6QYez67W6dEic4CoMiOnc
	Qk9rHKqRrLdn8XFPHTjSkcPmKlrGdGXxAEVcB8sQIi1FZ7cXMEKl7CVvcm7VYaqka3jVr++U70K
	cMy4NjHxmvDW6+0PVjwyghA/fHCD2pXXVFySnR7yPdZ0Q5PY4kJkVaRAIj0+m3/giTBFAJWvwPl
	vXT+QrWV1XxtPGsKk/SZEGIMVCwnJvRz0+yc5sVCjwDYORWC+kFKuxPSvbiV4AC6SLzx0U3oyey
	axPUGPTyUTw==
X-Received: by 2002:a05:6402:24ca:10b0:6b1:cee4:8d8e with SMTP id
 4fb4d7f45d1cf-6b3c73e2b3amr54877a12.14.1792423039402; Mon, 19 Oct 2026
 08:17:19 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014173945.373295-5-almasrymina@google.com> <179209666252.434549.1850964039919625643@kernel.org>
In-Reply-To: <179209666252.434549.1850964039919625643@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 19 Oct 2026 08:17:07 -0700
X-Gm-Features: AclHuK-S5bmzvfsy_xN2FySxs-CZRN_0ke8ew0HfEdZQ0PJrgt9ujVcZv4HD-hY
Message-ID: <CAHS8izPkWy4mMj+mDyHq8rKfthzj3n7dj7=Phzq2sut79JydkA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com, 
	j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 1:37=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The commit fixes reachable page_pool refcount imbalances but
>   has no Fixes: tag, so the fix will not be picked up for stable.

Yes, this series completely cleans up the skb frag refcounting IMO and
makes it all make sense and touches a lot of the skb frag refcounting
call sites. It's a bit too drastic to mark this refactor to net. I'm
suggesting just fixnig this forward for net-next.

--=20
Thanks,
Mina
