Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6965E4E4328
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971129; cv=pass; b=BV0poobM9yb3lHkVcuJT0XX2TTE2AjmpJEGl+fK6eglRlulwNqZy19yslQWti1vSKnBv6b6JTDZCCEp8caLqErrIWc/OZb+M8WWAKqPmfqtDSnbQlYHi+QY3anAwCLAYX3HqmzP5CFgImiRJ1UCkwCgM2Ym6rwLU//Fq9ng9Coc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971129; c=relaxed/simple;
	bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XgA1bJD5pPqTD5L9zY0Fb6Ij9mYshAogOVv5dZg6bVipJmCp1XTBT7IzUegngKFNrQAfFm4jMZQhgxi4+3dgqkMnhUgRITjO13PDN6cc4PyvBMxAQcVyVhIqcuGLFaABpUK5fOwy/WtXhiLEU/OwrZblle37BJhU0y5mHkJdEYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PK1r923x; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PK1r923x"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-676804a3a22so3644194d50.1
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 02:45:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791971126; cv=none;
        d=google.com; s=arc-20260327;
        b=euT3ttk/Iv03qOs+Ub/SxoAXGzRGeT0U9j3cvhzTpHvq9RjnjIGAM1UoeoVqanrU48
         DREjskIKGB2U0P7ZPHPzwoi7A7J9sVseLNVnqMUPhUGgYSiaxRXElKRIH1aMbaQLjg6s
         0321a79Ex2lujDcIBx4dZSn2CMz7rV20KliiCaCA7s1wFNZTjBF33+46HS25gHRlfG7F
         KncU0EYyk7JX3KDnfsNlu5YlWciKZ00xaPhy0qlqhK45Yjj41uqYCqlVjTA4fRd6oce2
         O/EUSQ+N0JHW9SwimGCYf2TwwAypvqSpbz9fSEN6yCvcnINtM/KX6aMRsEb2aqdYs65i
         aJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
        fh=XrZ44tigQ//zy8baNRlotkxrc9ZyokMaVGO3+/rrrsY=;
        b=dQIgvd5YoGf/EKCwhBZ5DTQ41gexj2hlupZ/0g7MkmLwZ5LrB3w79qUp6Un4oDSIzS
         6iA80oqwv2KH6hWlzTlBIfVzz61zZxDJRQredhFiKrwHv9LhscvZqLR8qiIlIKNdArI6
         N9NdnAbWALYOOHH/en5jNwrje0e0PPNsdUv+/0BA1w3ogiyBzCQx/pjG+9xiXkWhyOsA
         +V/YPIABk3mTe0XGKeVPwYWOlkO0q9AH41Waf3j3oGlPIyIfDsKgL8tE+gdZZhzAEoFp
         kfY31muVGZ22ETTn77dXyfIXC9giPoqblwJZF5ALzBM1EQTdUKu4Mv6+w2gf8bK/U5jC
         d/2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791971126; x=1792575926; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
        b=PK1r923xhU7qDZUbZmXe0yFUiSBca3J8XHIHs9qS+//TYB4Fft+Qo2Ljqk3oG6sPvs
         ExQCXNC1AHfaOK+vCwWLnwkjAKTf2UBbROgtrQXr86a/xPPl6cnW8uxv3/TF1HaeunIL
         WDiDbbme6gyhDZGG95JeVXsSEylcaz4DknthCfgSWs5Ausu5ByUHgSsm7wIUQRywIF7U
         6L6dKDQwf2C+Dc83KQaib+KmDPGD3y03epzqW/Cg6zX34bmKNG+1EutwDxzYAA5TyPdM
         vvgnoK8SarlTBCqLg0ZTdzmtuFchV5igeEa4cykI2Ygktz2Ux2qUDOT2+uGnWf2ewKNE
         z44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791971126; x=1792575926;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
        b=rLEcptA9nN9NYqekKp8T2dnsO04HoDMrbOvhG9eg7uMoSzJBzYiY7E6KcyVg+CW76g
         jpJUkDkN+kevUERwgm1+degGwJ9q30/bb1THbPH2G3BIUoMlPBvjJfXr/heu3jCuUB38
         VfaZTmXI3dyomYkphcEx7yPrw5Gl/luQVGyo4HiIxvI/Vsio4n5/q9HWWtz0l00Y3qUL
         oS+OwCSVZNUqf0RpPciAiG5og+GJdOUgkD9nc5zTkZwrPwa1hkoTKEfN8XaN9lyvWGzt
         jvtp3OOG9etXtrcrQpgfA66aspo/Je62ieq1CdxvXwphzaCGh921NND8rGz6/GkDuh4D
         45qA==
X-Forwarded-Encrypted: i=1; AKwUvBxxnY6tTJOZq2Gt0Gq7zwzTUK2MLTZDIO9qiY3TUBb4bSikrNGdx9e4qnb18a8qInSsEq7pBhdW5wTv@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7mE06YctzogunBMV5SmcBV0bCeiUdGJqSyuC/fbzcSd1AAcX7
	b1KjNNqYIkNXwqo0VVAxoQqoin2qECT2FnJggoJ+F0qJD1nI9gy0HK2NBPc+0NhGxQ5ZueUQtQd
	+Q70+5GuZFwKaSqdkM1eVx/DPAbBEp8L+VZdzUG4y
X-Gm-Gg: AYBFou1fzc1YPL7gOc0xxaVtvWIoto+NQYDqeK97nQ4AxVg06q1UL2nJhBop0GdH0Hz
	fBJYFT3HY7yncYG1IojJ2Lb+3RnheW1506JfIO6VIdPyj+RzXa5/XliEuzPNx3TaR2jgHEldmhT
	IxClVh7GLIssLkpTiXO2bNRzlctHpVlGSwIseIM5favSOJ0LYSjAQ8MyMtBmGjzOLED7PD8Fjrz
	b43bErm9/WIIXKDbbGwDSvRv51YErFhnVC3TBGG1HDfPzpaMatkLlgt9usDcXQLIW8N22iw2Pce
	JJotyVeH+m2kZSmPU8TRBQN+zhvUCxaP6un8jcMivgBwSMxJDJQUYuULMIJQSFgxzPh1asDgTD4
	cA4QSo5W7BGOBWcNFYpcG4E82crp2vM7O2cHxmTYtw8ecS7qlICgdALfxfT39yp92fxV5nNSwKO
	/uCHzFWbYqb+z6g6wFFK3tNLnfMl2jimu0EZYQRSjzrQ5DfKL7zfUq1unokpAnjKJmiqL0K71Ob
	blwlZ7r+Le3r8uVkm4xchld3yqTRfRHVfddnDWoPOdjEFpx+m72aD3dV8tSMexsswER8MeH8Kl5
	1iqBW4fo2y9eTg==
X-Received: by 2002:a05:690c:c4e5:b0:8b0:9e22:2651 with SMTP id
 00721157ae682-8b09e22273cmr36219317b3.7.1791971126209; Wed, 14 Oct 2026
 02:45:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004171636.3545085-1-julius@bairaktaris.de>
 <20261004171636.3545085-2-julius@bairaktaris.de> <b4aa46a5-dd8a-4520-8574-d008a3877f28@nvidia.com>
In-Reply-To: <b4aa46a5-dd8a-4520-8574-d008a3877f28@nvidia.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Wed, 14 Oct 2026 09:44:49 +0000
X-Gm-Features: AclHuK_at13xJpgBNhwlZvLzlUVxJXDvkN0LGkLWSuS73Rn7U8oFN9DIXlg-t_w
Message-ID: <CAC1t37K0tEMzxmRhLeHnH-TPx61pZmCHt0xxTJ5Wq2Wxvzv8Jw@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY on
 flowtable offload
To: Jianbo Liu <jianbol@nvidia.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, lorenzo@kernel.org, nbd@nbd.name, 
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net, 
	rdunlap@infradead.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, saeedm@nvidia.com, leon@kernel.org, 
	tariqt@nvidia.com, mbloch@nvidia.com, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 14, 2026 at 03:17:00AM +0200, Jianbo Liu wrote:
> The handler is only in tc_acts_fdb[] and only accepts flowtable flows,
> so NIC mode and tc flower rules are rejected as before. Looks good.
>
> The comment says what the code does, but the consequence is worth a line
> in the commit message. Because the action is ignored, the priority only
> reaches packets still on the software fast path, where
> nf_flow_offload_forward() sets skb->priority. Once the flow is offloaded
> to the FDB, mlx5 forwards it without touching skb->priority, so the
> offloaded packets do not carry it. Refusing the flow to honor the
> priority would keep it in software, so ignoring the action and keeping
> the offload is the better tradeoff, it is just not obvious from the code.
>
> I checked this on ConnectX-7: with the series the priority-carrying
> flows stay offloaded to the FDB like plain flows, and without patch 1/3
> they fallback to software.
>
> Nit: "prio" already means flow table priority in mlx5; skbedit_prio
> would be clearer. Not a blocker.
>
> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>

Hi Jianbo,

Thanks a lot for the review and for testing this on ConnectX-7!

I will send v4 with your suggestions this weekend.

Best,
Julius
