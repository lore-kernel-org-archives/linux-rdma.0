Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A1353C3B3
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 17:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085417; cv=none; b=IoW1ISKG2l8SX2J64ouEHQlfJsfusblKjQ6Ip4nCyl4mz+Pf1Y7Tc3qPz8d9FvYTUbSkHSPo9woxiekTLo/FA8PxIABKGSEUCWE0YJAqzeySY4RA/VASLlo6wuM4+IeHrCN44QRa93gO0qC17T/vI6nTnl0PqbSej0uOANAE/L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085417; c=relaxed/simple;
	bh=a3qw7FpOix6g/wGV5bXQ1nW64xCim7gqGsQjoN0BNjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwNYRL+bRiB2fm0yYpwirnGl2G+E/GC+xkUw9jfWtfFdFwLBP6sx7f0utLQXHakXyqzoX8KsELtCdrV5rp/5v9/61jaApDicOHglzHddAlsrYrzQ29KD7qaaZ89iAEKUDV1MF4zCtaqROMdtXE2UKOtc2xtOHiTXUN4PGDsnFkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=o9AEqTRb; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="o9AEqTRb"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-9178d514951so14706946d6.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 10:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792085408; x=1792690208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a3qw7FpOix6g/wGV5bXQ1nW64xCim7gqGsQjoN0BNjE=;
        b=o9AEqTRbJVE8SfiU32KImW5wnz4ik+sNrKGsStk3cwlUMyK9dxdfzCXdlYFyUJl59v
         99PHgcIbDhrU1k8MxV/K9WFa0Qest9oVUVjeyIsiaXerag/zKPqOy2qrdB1PSpiUAUKe
         6P8mBWr4uLc4WUB2k1dgEeAOR4DjNCnsDIOky0doEPeKbrsjaoYsGYO2lqg7JYplzZQU
         PHr9a66aFeBmcyaVETqInlJhChhZxfFV4Ffp42SZd/Rlcip8+W1u+ejg/mhkFc64hGfe
         GHCxE6J47XQEccySkaJy11whNRiZWlIbQoBRs5yR0vrerhzgSSEXXdQRYcnYGNEMdY5g
         zzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792085408; x=1792690208;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a3qw7FpOix6g/wGV5bXQ1nW64xCim7gqGsQjoN0BNjE=;
        b=f3hzZSQa1nXbb2kHJrSMXCMD4TEb4Tfe6hD/AySX1OOnQVkmDs4tryil9SWUbe1Y51
         /3qHzNdSCnrcB1SRXU53YCebCGqhQ5A/LLPVg1zafkYL9nczAyDe9e917EwvKPrDipDp
         UpNT82Tt+h/CZb0zdN216Gkol1gPkwvprZ+XB+XhOHvAbHYG7/ZG3RsYI99wyyUwYT9B
         mX7qbtDgjtS78d/nbLaBh89dEsLeeak1PExg/gN5G+WU/tF1AJbdFylce+e0+RXl9Jz7
         Y8mbyiJGiH3FvNcK5vJpFmIMbofyadINHtp92gqte5rYw/i87IFodoASp505znlpEH66
         HEFA==
X-Forwarded-Encrypted: i=1; AKwUvBz5QLoxgA2fBojvGciwQc9caVyKPx9cY+kCqiXEbo5dJ0pG9nn5dJN4iLay3FhYk9g3BSSMAkyY2VdQ@vger.kernel.org
X-Gm-Message-State: AFq9FYI4JXpQhcpDMeAIulm2dyL+L1rI7bySC9Dm48Mtyl+TaZQQbw47
	mv+yWirTNq3fS2GdY6xdHa2SsgNDSJcRBx2GuuZtzRlJZUkloeJoa93nc+OJUeNN4PY=
X-Gm-Gg: AYBFou1/OD//bVSserFkkG6R1wyYAD1FG6DRY1nEaPYo8WlbyDk/bhUeYjpkAs3yE92
	+mMKXKYF+tUOhlmqoxH3I6vJvpRsu00UbbiFH9rYLgHyKx8z9Fq7YWA/2NnyNpvhcYt1yHIPXjZ
	zgdNwFCrIKuSm4hcju0Wjy13A+MGv8sTH25zAjWvAay1rE9N5vrYto4YwBXkUc8QNLASJzdPy0k
	Bza8iAzTxbUqjjT6QG+eMW3Ao+8biGHDSMEt4XQ5VN3VePijp/QJ+LWiSMKalZrjhzj2zKOK18k
	hto6WZQNmRpW2ApGFWKnZQLQ1/wTzuR6Iw6rD6jbq502YEoHnxfPA/6Jn+RLyVJzvWJxYO68+CV
	2bMSd6cUVDLpwPabhphc4l/rAHw2kBBlkfM7qFzWNBureLA89QLuEHlUgifIKbdwJERTbapCibp
	pPT2HijxJpIwmMLuvqmfbWXuvd219MyiGir6fUT+c7E4SD8Jlf8BvOA3hlifMRf865H0AKfdFrL
	bfczIGtEpo81DWJp37xn7dFECsp9szV3AS4R8PLOuZmVtP7VeharLVW
X-Received: by 2002:a05:6214:268e:b0:917:a8ae:26d6 with SMTP id 6a1803df08f44-91b5557f525mr339715216d6.34.1792085408413;
        Thu, 15 Oct 2026 10:30:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbb80515sm646736d6.44.2026.10.15.10.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:30:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHPHJ-0000000H5RJ-36Dw;
	Thu, 15 Oct 2026 14:30:05 -0300
Date: Thu, 15 Oct 2026 14:30:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Eric Davis <eric.davis@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 04/13] RDMA/core: add the reliable unconnected
 queue pair type
Message-ID: <20261015173005.GS14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-4-a0e626117113@broadcom.com>
 <sashiko-outbox-172001@kernel.org>
 <CAMouMYKADaQjsjeGZZyB+eWvswpf+b_H=aT-VZHVoe=vQFhxZA@mail.gmail.com>
 <CAMouMYKo+z70vA86P5gG-Kz=5TCSUZVfuLS1wAaCLKopze=R=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMouMYKo+z70vA86P5gG-Kz=5TCSUZVfuLS1wAaCLKopze=R=Q@mail.gmail.com>

On Thu, Oct 15, 2026 at 09:09:20AM -0700, Eric Davis wrote:
> If it's preferred, v2 can make both post commands return -EOPNOTSUPP for an
> IB_QPT_RU QP so that is explicit. Let me know.

I didn't try to undertsand all this ai output, but as a general
comment if things are not supported please return EOPNOTSUPP rather
than pretending success.

Jason
