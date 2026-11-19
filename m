Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053894;
	b=BszTFsc46Guor+DLCb4x3Q6eSCS3o0L0hogmcmoapgeRm93IFXelRLLQA4qcWpyroQek
	 +4bWdI7ctxceHjNwoMRdhYeK1GXivPSE1wzNViXwg2hFK2zvDUANhF7fr/x3PVWjr7D3G
	 xkhrpzWPP/Y2+y2u8VO3dQExGkbxJ3fjN13xPgW+HP2vwe0dW/4Efk78WhIwUne70mlAZ
	 q5voF3rKP+KjfEqKCjx9npTE3rDOlEwiXCXCxTusRpgMpWT9dwuPEWa0oivdfoqfuNJYv
	 micoRxUmNokb8T6Wxm9Rl3MsSzIh1/PaHOuxGcAmd+72tXfnZ1XKENdhYScCZ7CY4EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053894;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kC+uhz3Afjp9Cqz8zh23wNboDVMQQa75pZ1niNRa9cE=;
	b=chs73/xfZGgP4Z2SIpNT/SVRAEGVcKu2IjJPDj4km5a71iTQDdnrmPxRc1sI5US1kKVv
	 ST+psgIvuPZ0dQiEPQGCWiZhdyctor7M9AaZ08mdTa4bZ2vC7+Q9T3VwAUs4x9oH4+gM/
	 sCfTMBXdynSGkI9nA9ONiZtR/LfEcF1RAJzw8eBvNQgtHUOVWlqi1BtzmTCOfR7cpmdVC
	 o/OeQ7MQ7N0wsiw8/Nu4fDbNS12f+cCvK4zhj0DEND1uSyq/zzS5jjc52RdM7ypxaYgR/
	 c2QC2rA12vZdgvd5vkSuqND9KQ5kRq96BWmddt1FYtlHfsouz8SBDcxo4h1FOLEDXDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YodJU3G6;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022BB606A334
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 02:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 022BB606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YodJU3G6
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b1bb072438so144423a91.1
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 18:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795053893; x=1795658693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kC+uhz3Afjp9Cqz8zh23wNboDVMQQa75pZ1niNRa9cE=;
        b=YodJU3G6HOVaHj6WeDt5Y4UHHP2vfW9vVNUgTmANxu80UmKCDlelZ4zcRR33L8Jm2K
         VswI4nIIqlVSIxBF0tdChGfztska8+jRizlCyMVGMW6uzwjEUVtNom2NNrBrrNNu/FsZ
         yQjf+rFOh5JWBC4KwmazJkkyKrtf0xGwBmIEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795053893; x=1795658693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kC+uhz3Afjp9Cqz8zh23wNboDVMQQa75pZ1niNRa9cE=;
        b=E8bqdPZxIpyNVJyl4fFU7IcLQ7RbwHyy+GXVt1H7jG+e8piQLL+oAJWTL805C6X4+S
         37i/RlZllZrjoAqoPDELD+AE4jGBRXGmqSTDWP1040+Qx4chi4H36eLmw1HXEhgymzSw
         fVAgXoFoqWCU5Iz2hWsO36N6gMBaC8MMUY5l6XxjDIQedZbyVx3T6mddfLTKKGW2eIkF
         Or2FmPykT44ucCVGEBM6wSxqsdBLQJLXXKMezUG54rbJRT8oH2jr30BDwJWdJfKlmBzF
         A2N3I4QU1nXx8p+NQLDECBbCFIjeeynSClR2Iwyrn+UyT8aflDikbVmRjxq2utplb1CC
         Rmdw==
X-Forwarded-Encrypted: i=1; AL+hErETTUM59khpfbaX0jRTD2QblBA1MleZlJoIYqFHnCt5bQmOtp11cT1T4Hm9sLB95m9ObdN7GV35hiYG@vger.kernel.org
X-Gm-Message-State: APuU4Z9ZJIsfXJS/MXYhM5nFMq1gtIrL+E7aNlvK0bQW0xAlbFIMKCcm
	eyEJP0gcw5xFF3sbgczwdyUmQ5ZeOvkuCU2REISa43b8v+WEEE0w5ZIQSbKtVHTRvQ==
X-Gm-Gg: AZFdTZcugymkxCnG4/ETIr+XTT37D8Mpr16Xv+3jiELzzl1mAlPE6iShunowjCdbDH2
	VG6M49pB885WfBWj65zI9CCHpW3qsZQCUgtgqjZNCNkP4nOoGt0nrFoZ5QQW7Ueg6fE/0TbdKOQ
	YQr9XmujE2iAYn5tl4CflEAF28hAbInjrOm0viiEsqt3hjKl/q95lR4mKgf+rpmj+811ShnNXTc
	82wYhnrvm7a5pBbco8OOiOXz6hf/YJgeFVORg0hUarbbqOgZk6pEpoO9EutxUQ04DRukfmS1z7j
	2L8Tl3fKspPnrweveXJmHOPHpkIiLR+5QP8BQi/2It+JeEtzOKX0ee1gXWLp4YInV7UXDVMCgxC
	GErrXXNbKALWmh45i6dsfW1Qoh110WtspCV36a/PpNoCzKoGgbr1Z2dnFIxho3oiISVVn6dNs0E
	nhaR3IzUPiUoUYYjzPXEWRBkXkLkaFJohgR5etuZrrYp1fVKA6NncGeLGpxfBxEd9SXMK/OlkJ9
	Q+tQoWxwh65d9aVNp7pAfnTDrL1t30oI5uSltdnytC2LtXanqdSyToi6p1ntP2w7gN9HhBhbqEZ
	mAM7VrgrAHndtd7MsO9aZc2f0b4z1Z6S1FpZJD6kByE8nZdtMEEukbTYiIBP0Wtx4iHWRw==
X-Received: by 2002:a17:90b:2805:b0:3b3:c92e:f523 with SMTP id 98e67ed59e1d1-3b3d0764320mr7560562a91.3.1795053893354;
        Wed, 18 Nov 2026 18:04:53 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3fe0e5bd4sm772079a91.17.2026.11.18.18.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 18:04:52 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: David Hildenbrand <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Wed, 18 Nov 2026 18:04:45 -0800
Message-ID: <20261119020445.1096831-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <332f315d-ea27-488a-9a3c-28cdfdcd5f27@kernel.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org> <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org> <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com> <20261118012858.289236-1-jeffxu@chromium.org> <332f315d-ea27-488a-9a3c-28cdfdcd5f27@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 10:46 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> > 1) Simply keep those 4 cases under GFP_HIGHUSER (drop patches 1-4 and
> >    7), reducing the series to just the GFP_HIGHUSER change and its KUnit
> >    test.
>
> That's what I would look into first.

Thanks David. I'll wait a few days in case there is more feedback, for
example from the KASAN side, and then send v2 with approach (1).

Jeff
