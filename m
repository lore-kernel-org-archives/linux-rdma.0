Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6146D2A9
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792157473; cv=pass; b=eXm4NxH29EYWCAkbBu9ETy2efRCWig0bBk/PZtAj0v0JGqqkh5nbmRSD0p2JMu86+qFTIn1bJrfmFTZy8FXU8EAFX74Oftp27DvP/KP+R0y34HoDHxpfUzAeSpKJuruBpIK1WsmiKgdYT3IcTixCVsV3YNs7kZOR9klf0dsTwu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792157473; c=relaxed/simple;
	bh=7vSGrATw8OiP1xs9dIzVyOW/1pb8qSe4yANpRII4cbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cvsINYPLmh83wTL97LkjiILHgr0ASKiOUOrrSZrcQyMUntKkNCCjsApPc3jmy0sIBAAzoN5Rcf8RvlEOWuqb+xBNjtjbo0l9CmvszUFlOBepL3DjBbYeB5+OuxR8UgOYqJLNJ9gi8EpUxy+he2RXLIVgKbq4fgg9DMM/kGkQNBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmhiU3iT; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmhiU3iT"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3a772ec8389so50149061fa.3
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 06:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792157470; cv=none;
        d=google.com; s=arc-20260327;
        b=FHiJnsFA5DpOKd6hFa902hybbnoPKp4vHnPQNAunKUraLH8c/pYe7C+SIH2t55E7HQ
         NtPBDc4N+6T0Cs3xfzhAVQ3cBXgMycuJpmOSEdOMF5GVoPvHZgluUjG5m2BipXJuUDe5
         I86z/Gn+X9xyyB9uuRKmYVOFpDd5+IevkjTnwoFqocodWABGoO7H3M3o9zDqSubuYlJy
         FpW3eIRWCitfxvVNiOscpEpaE+A73LeIvgSfTpoijsiQVOZvOgEHThbhTchhlXQuoekE
         twEDTeT9csp1MnAdxD9A72rHpGDxt3Mm85HXEiXVQEjw+jcRIa0uFrDz3M3iPxf9Z2aQ
         QM8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7vSGrATw8OiP1xs9dIzVyOW/1pb8qSe4yANpRII4cbI=;
        fh=oSAxMQOhogbQo4p9I0zbAYNaDcp/3tLHvnPls2DX6+0=;
        b=DPEqPen2A1gPsLKImz1b48wmZNETveGfvzjR4VuGLko1G6hFbiGm/UrQQHZhlhrOT2
         NIRHom1Eeg78YiP6ugK33pvuugeAts7ySbbN3LUis6mkB7liF9RdMvv6JQW3U9moAmLa
         EEytSlIjhA8gCNO4o/0fMPp/Jp/YLB7q8lYkSgnadadiO03K6qFj/RFw3s9YITRHwDKK
         0UzfJm5ce6G0pjDnt5EZH0mLHAkBHNtdvaiY1WPoCQ7OiDpz+VNrWwemS+GeDikpWpYQ
         wMFLAM8z8tiNle9iHGRR2d6rdsPsv+D2CIG6uhNDPYi4LYHYD8zpVQV2p1aC/n7cAAED
         wywQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792157470; x=1792762270; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7vSGrATw8OiP1xs9dIzVyOW/1pb8qSe4yANpRII4cbI=;
        b=SmhiU3iTtEO8oyTs+3mydLekqmQlUF+n7S2VcttqUDTu2PUoXpIcte1+33rzh42U3r
         Uyv2lyBGZUykP1y4Y8QsAJsw4Ral8iry48n/mWYmufIaB1qiAtnbAGSxVGHuquabPeBt
         yBNUoIxF8ole1DpUbKwZZ+KFvu8ghBvAaCFdjzMU4UPrzYOPjAtZmlrYk2ggoJGRs0bd
         TfcKDOwF2KLjMX+OUWFksev66U5nLJ0rkrZCOPLSItAfmYBf290g8WwM+oppNlWKvxLN
         adbJ4ojUCxF2JnvXrZtkrkBDebZ3qbE8GKp6bPzRFSXNEfV29U4ubsio7rMrQBg8od2o
         nItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792157470; x=1792762270;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7vSGrATw8OiP1xs9dIzVyOW/1pb8qSe4yANpRII4cbI=;
        b=hOOGMVaClIw0RIJUzVwC2k8RcBCHIMGiA4I4acJ+Ep9d8UeCRuBEXroLhwzvJvf6Xs
         /HUuY8bZ/A8/Ngy4zGubp+FfqsHLo603OY2QFUexXmI/gIZpXEPKNbA0EY2PqsLZiGCz
         iSvT1OvFDodKoBhc4lBgRq2bufAJyjLB2qxdsICP1VpNUgfQ8uJ/c8Qq6AMNLe5/E40G
         HLbiplP4z6qbe5jfy04x9YYGqYmY1NYloFka3PKb4ifPu4+cgi3aAbPl9PTU2uRJ+TXg
         qxi1ozsG+vjq/SyEq53FvYjHxfdra+OG08cOGPyaSP7AzMd+dOycbK3A73HMAUPihaBa
         suWg==
X-Forwarded-Encrypted: i=1; AKwUvBxZCrO9lKjOJLjYgGNmuF0TrmuOVne8sZoMO20BiNjQQcWPNI5BxqmlU5IWI/mQdDt1btCctWBR87p1@vger.kernel.org
X-Gm-Message-State: AFq9FYKeDkmhOKKjPRfdxosWKwJAKhmg0ogOVBeX3x+PBlpABn8fjEEI
	2KVoFT6sE66MlI/I3Twec0wvFeSpCCZ5Xh8rKuk6KtBAUrLr4gnA35VuOwM8UCvxF46dEwl/438
	lK7QB2VGY2bBwxl0H8IJXff/g55RFulA=
X-Gm-Gg: AYBFou1wNPVJQlGM4pKwBvOXL2MGrVAAd9miVNvIBFjctGsYTS4lRBcWCbEd2x+PpmL
	Ru/xsuptgS9dAQJY/bYtp67jOmbb82J5UbsflGdQ+WKBs2qBH21RMf+Md9Yw+QADYpuJ18RvADv
	Gb8rnsiNMOL9GmRR1zXmmABi9Y6HIz8JSXgRVzLKN+kSEs8XICzo6Gf598uXd5E33351RWBEE89
	1ZPf9zz7E+nHt5MBv9Ii6v8OQEo90QFvYHGigCEspWl2l2ejt8+5hwbp5QP73HoFRJroyl6ITOj
	ULkoWUn6Toi7lZUGay2nLutuyExySx1vxy2OLM4fgmE6VYUWfWJSbfI=
X-Received: by 2002:a05:651c:a10f:10b0:3a9:849c:b169 with SMTP id
 38308e7fff4ca-3a9c55cd2d5mr35171861fa.26.1792157469757; Fri, 16 Oct 2026
 06:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016045849.813696-6-oss.patchbox@gmail.com> <1ce84c99-7f55-a146-7333-4ad791434097@hisilicon.com>
In-Reply-To: <1ce84c99-7f55-a146-7333-4ad791434097@hisilicon.com>
From: Yuho Choi <oss.patchbox@gmail.com>
Date: Fri, 16 Oct 2026 09:30:58 -0400
X-Gm-Features: AclHuK92JpH6uH1vJ--axFEUId5jRlivHf0QixSYU0dCBZsoLZYYe7ajIOxpcAc
Message-ID: <CAGG=RgDgreAd+dSc=XwkuduLJZfJuR1AJr9pXSd35aQoLQdQTg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/4] net/mlx5: Don't free CQs whose destroy failed
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Ariel Levkovich <lariel@nvidia.com>, 
	Jianbo Liu <jianbol@nvidia.com>, Alex Vesker <valex@nvidia.com>, 
	Yevgeny Kliteynik <kliteyn@nvidia.com>, Itamar Gozlan <igozlan@nvidia.com>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 at 02:59, Junxian Huang <huangjunxian6@hisilicon.com> wrote:
>
> Are the buffer and object freed somewhere else later? Or are they
> leaked forever?

They are leaked; nothing frees them later. This only happens when the
firmware is alive but rejects DESTROY_CQ. A device in internal error
still frees everything as before.

Freeing them later would mean tracking them until the device is torn
down, which seemed like too much for this failure case. I can look into
reclaiming them if you think it is worth it.

Thanks,
Yuho
