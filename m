Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00033DB326
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784390688; cv=none; b=Pdguitg23jov1EVGaJJhF+EeLCuVIDpTT7PMHG7UJ2TqW2SkxfQypmBQ8TITcwK5qBEwbA4VtWpZRljBY9ZQYdxVykhBlfsmEgmwFoLOa6yM48YKTDWZ6dUk3RFrOM1TtLg8CY/BiP21Q2YpCa+0csTyDaF7NpixJ6J9+8367r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784390688; c=relaxed/simple;
	bh=ObBl2TT6fkqb1ycB/6fG953huqnqc6cUmP96XRVZ/+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GK/gF/2NcEgMlkIOZrKlhNhnrq0Jo23kk55/0oC2/1tiejh1pHFO0sfYwKMdV7P2mp3kE3fKanQNC2NxVwkO4Q3J0ZsKjoHdKQd2nyKz2g3HpQnKB8m1ySFzW7BtVYcs83PD8h2LsCDljUtYLJB+/cKnLM5fA4NEX/ZSGHomNig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZaurwVqw; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZaurwVqw"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so63252116d6.1
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 09:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1784390677; x=1784995477; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ObBl2TT6fkqb1ycB/6fG953huqnqc6cUmP96XRVZ/+c=;
        b=ZaurwVqwc13bq4f4kKV9boV3tmELjS8SgCrHsRSt7yhzhVJs3Q27BLolKg7lV42pDK
         P4HD2LEq81bAzQuIPLAT4DgjWzz/r2utNS3gZfS2R67cHUD+YElZ7QDifSk/OGjA86ea
         ZTPuOSOCRjN0laSSwWCdtxTkdQ3uiHd8mIGmTWW22NZG2AW7GpSzTFzXdt+qoK7ALZDS
         39DCcxn9wszvke4LOsdYiLXZTfRVdRC91P1P2R5P1+n5Vdu9T0RVtcWitPstKzoOT0gH
         96HdQI/mT5q6Wc0jp1OpjiPqNZVQYF/F55gfUmBkS7oUPbcAItwhS1YJbSwv5PE+9UA0
         EOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784390677; x=1784995477;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ObBl2TT6fkqb1ycB/6fG953huqnqc6cUmP96XRVZ/+c=;
        b=h4904CQJcAvyobXSG3CrJUAL0iYkUgimk2Hf0B5KlAZiesXvRXpejmCpktp+y8G+vb
         QXRovL7bmBQLJ7VexNr4VUuFZn2pqvCbC9o+ia0D5BbAts3k9mVJng0IbDdx2tKo0Z8g
         rnKWG+bv3ntHGNWvnVAFyK+rgpBNoEZZi+OA8DSdkbmJaxt7dYH56Gx8E9aOa8Yl5oYh
         lQNMq0GwauJ8cF3A+O/mpJAajs1Fq9pdWcxuLXwtDT0ymoqUt7tSK2rIXs9ygvoWTJzy
         jbrafzlFBCOzxUgIr0DQivvwxu+OtavkDNrrBrlGSNyAOIXFPlcwOGYVt19yQHbx1tc8
         5SrA==
X-Forwarded-Encrypted: i=1; AHgh+RpBEd64Wt59sjjhb+tOwvNUv+WhSsb218TSpa8Rku5j/2mrgELjsOgM7zqr1GzUvhptFbVuLIy/jy5O@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6tPAM9OQScoyoIUr9klEYGWTW6Sg2+LlrKAy1xGKh6fHWylKM
	Rchhq8RdvRdMebVsijYz2VnceKtdr6IdWivqRoNBn14iUEVcDPYmENWaQJhdWZzYuxw=
X-Gm-Gg: AfdE7cljbKc6l9nYBLt3ZbI1PX7a4ICLOlfKSV7IEu+b9wbEnsMn1ovjDQn/kotrjNz
	k1NK6yuOD9kEZUlpUYo7Oqz2gqi/9S18xEDMddKg2qShHhSNxU6Lvp5ToMPU8KOxXbSbXXCoPpM
	y1IUG5Bxb/ENoHm9Jo5oTCrvXiqEiBte9aNTuNcQuaeXHDqFzoAx97s8BJz30iiAF7IxxTnQUi3
	TqnIXfWDibfz5b78CH2dH6w3TBrTBdN3nakuAiC9nlNLxXEqBN542s4pi0qOxpJ9iRWObWAm9G1
	3q7A3vDdlV2WxPmopQhMLMkxoNnyesaEBt1dpDaAcp9kpfiTPpG+3eUnR3m2LDRa1PKqRPa4SmR
	YSQGldXQLAAz9hbGa22fak4ECMax2fV2V4CMHiDTxX7Zqhp9yJw==
X-Received: by 2002:a05:6214:33c2:b0:8fd:6df3:b379 with SMTP id 6a1803df08f44-9077853d176mr83985206d6.61.1784390676807;
        Sat, 18 Jul 2026 09:04:36 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9078b6d8cd4sm12607736d6.29.2026.07.18.09.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:04:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wl7Wk-00000006axc-46kQ;
	Sat, 18 Jul 2026 13:04:34 -0300
Date: Sat, 18 Jul 2026 13:04:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <zyjzyj2000@gmail.com>, David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
Message-ID: <20260718160434.GH701389@ziepe.ca>
References: <20260718142642.102924-1-serhatkumral1@gmail.com>
 <f1794905-27b4-42a2-bce8-ff420dd13c6d@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1794905-27b4-42a2-bce8-ff420dd13c6d@linux.dev>

On Sat, Jul 18, 2026 at 09:01:50AM -0700, Zhu Yanjun wrote:

> However, hiding the socket setup failures from the user-space netlink
> interface concerns me. If rxe_setup_udp_tunnel() fails during
> rxe_add_gid() (e.g., due to port 4791 conflicts or transient -ENOMEM),
> rdma link add will return success.

We don't have any way to fully deal with GID creation failures due to how
everything works, but we should be to arrange things so that the
failed GID is at least unusable. This may already be the case, I
haven't check carefully.

So the failure mode is not silent and is reported to userspace through
missing GID table entries.

If you want newlink to also return a failure code we'd have to make it
synchronously create the gid entries and ensure that they are all
created.

I view that as a followup topic though

Jason
