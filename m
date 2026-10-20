Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792534217;
	b=gWK7uvSiXixoyl4IIM8ckbiK2r2ddYrzbyBlReeObrS5XiypIIsbtcTFht5J5trieOxt
	 /jVMGEgkN3CGoWBQDhWyaptEIBn00BklyYhTYvI6djb9bQCDDGJfkEL7nRhnb+NzbAvbe
	 4sDnhc8SKOlNnRAeLhjBq6BfZ+Ms0xqfJrtXz4aiKaktvV0JuQYe1ojAl5URn6MPqnnDf
	 yLzlELjCi+SpizKofR7ZnKnI1xThVIkjeoMVY1BNVKXzJTgI+uiDAJTXgopkwLb9zscaj
	 Ho9WwLhdceKzxaUoOatqF1AINpkF/fJ8OTiFiLkJ10WjqMYSh6IUbddvFsEpA7VNRFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534217;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tl7GK25Ew5sPTNDqInllcRJZPijbAjxuuEYSDtAi2Yg=;
	b=K9J+JmvJivhfNoT2dP0fLkXFsf0hPYuE875LLyH8BMRFMtnWyK9/z/nG/KvxVOPj0lMV
	 wyFRawQpYXQdEPeMDaR7oanjzBPFM2U1bvo2+Ghi46ZRS/dhAfeOPGnAjVTikiSWxPnhg
	 uwzscShYw4Y6MAF87Mwgi4riNC71sPRHkREj1P9KoTPI4YL1ZU/l7nwWv5rzlBpDbX2Z1
	 DY1iMminESfWYAhszeeBHaDE/SlI0o7/U2VXNH8Uj6OSm3H8dAyO4xOFjZra2D7VcdgIs
	 zYTf5hC53H7BeF5xK8K/vbtM4CiVgXrzQNUlS3BzDRsnTcn0ckkXVpsWAt7bo9wAYJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=I9foUfAp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7B7606A320
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 22:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D7B7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=I9foUfAp
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso2076a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 15:10:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792534216; cv=none;
        d=google.com; s=arc-20260327;
        b=G+RndM4mNhW/MQ+sLjsTL5vWVl7fBsG/ZeFrglRQvUb16zUTRcsPIynEvdbqtkK6fh
         lIewabaeWqaFVr/gNwMcFtJ9pdEOLeKIwou5nYlHpX1KlOYRP9Br1pp8XrT2zp7EBbQx
         XKjty8+qLmq4kBexEMB3Tu4MC/9ySJTar4/g2fwZC1GPzUGxcdAEAhsD5YCkk7zyPTCU
         GgTG9BPY0wItCRQ2HBnWezYxOT6EnSvlcEQyhYphE7UrfMEbtpMc54g5ioeTINT8AbXI
         rCVS/qPECmRL4l4Aw4hg/W2lMxQi1jXdyQf3UB6+OO0juZ/6cr+mjlmm/Pfq9Pb//qOr
         tI+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tl7GK25Ew5sPTNDqInllcRJZPijbAjxuuEYSDtAi2Yg=;
        fh=55nQGFUj3Az+qhGPahuvhohq2lp3Y17x/mcMuVWBKyw=;
        b=Xe5jw9wvFvFNdCv7rPjX5soVyrHmsdui+Ma6en7twRoTkoxEyRXS3SLfoJSkQWEGBV
         RLipt4rkdgch9cCDH4Snvn9aahmccTITO4xA53Z27HnDim+/euD0wOVys2i9jJatqoIm
         mBpcslHKcao7rPVwZfD5JrQhZDckkZRgPuLXAp5bCmSk/YzIqeghU5Kt+EqCx5ORs2+j
         JbWKf96L0blLkSIwAc7M73AYqV5CDDsTkYbf4tBrAYJHteJyotYbo9Z1/gt6HAa0Ccmz
         QqmIuYkeArQBne8xe8wZSlnwbFdYb8JXIE6vjlEYam8MPim1GRfR/okrRxibMEowm2OB
         1ooQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792534216; x=1793139016; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tl7GK25Ew5sPTNDqInllcRJZPijbAjxuuEYSDtAi2Yg=;
        b=I9foUfApie8pgiZYfjauz9V97l8g4NY7YWU34Ms4vzqIiWzmDpB6SAaaxEekO1Ln4b
         c8MNWhWbPFk/vCJM+YBYqGFY57jiIrZ+7fJImQDXwBRlBeaoLdQ1beDrYnDSzhfJiCib
         hsFfdqtoj/lDRsFzW+hluaVqKh8H89NS+SuLcpfXQNl4HCwmaVmOYfxihZP1pizMtFk0
         SdTKRjQiEYXwKziMKFxUVXS2nBERdwR7JzAPUl/fDLwyJWWOy88RBh7nm8CKPWyw4nuJ
         ROWXaKIaP4ZdS/NK0g0qbrZTY+3srupeCZ3c6wEcJ3wpqH8EuhEd00haIcRuxsSlEVYn
         tUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792534216; x=1793139016;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tl7GK25Ew5sPTNDqInllcRJZPijbAjxuuEYSDtAi2Yg=;
        b=b50s630KaPuHRgpvEvSmNZmfiAFSpq0F3HEj/ExC9n7GYcpelLBqceXClFgjb1JABv
         ocjjbUkw7zwNGuaWtwpYSOAJlDo4ASwz4E7IkxNU13ejz37OF6tHgFd42+bvzHGUrmQE
         YJfk6kcbZymu2S5/Tt73yjMuWTyU9QRC8txwbjJOpR0bEUv9bkmWAYjLvxhbCr3ZkgVS
         BKtAewPmJvhQ88Rsbms68X4jCN8m2p9Vin//quX8lncbWKryMsyESnenStfoNM6Xt+hO
         5UlxWr1SKEnr3UmZxBdtOzmn//8gVoAdgX8AOggMP66AdY3GFO2B9OwFkCTRqXJ9SOVS
         nqsA==
X-Forwarded-Encrypted: i=1; AKwUvBxD3sWbCd/hE9daRDADR4kkFShs6gKMLbbeK6y2Jegy8w6zXOBVDGbduD2HBAmfNJV4/CrjqcBwUiRR@vger.kernel.org
X-Gm-Message-State: AFq9FYLGG+1AsIlcY8tZ5gSmJGdyI57TCbKqhyQr9/ujrj0MLH2gwg3E
	AoskxiuxrIU5Qnnq79vT5YOrqm52AujOlQshtYp47p42vdwoLPP3HsCDbPc2tg0QAJU9WunsnQk
	5e7ddQEJm+pEVYB2SLSk/G1QqsNBd72NMNzxNAWrm
X-Gm-Gg: AYBFou0u5++k+SdPH8eCK/lQVIt1Kb6XiCuXud6LRIpUvNp20RPRiEBX7nTxUVtUixy
	JCoKltspb9hdNtYsbKCAp9NHpQvJBkW0NdB/EQVnvr6/YMnbBPkb1W0Ecc42bnTMOYMflcCEc15
	DqIdAv/PbI+wxAkPFq4TUdL6Dlh2pNs6DkrBv5uG8E4Co/JTR+u8h250yXIteB+6E09RENJdFE3
	r4J4+J/I80xXcxRARiJYJ5cY+0cnF8VWXNZyRPY4p/66wVtCBE6MuZ/4qSxWLTPt8xapKs/KlOy
	j4UMoUZQeF+iEfLm0TpCE1cYEbpBaUgBVRsjZCbD71Zls6GXXQCwlt1nhC2GgxXg/BHfb8futeR
	oTPLgBWsDoEgueBArpzZI1erGeLHuc2vbwA==
X-Received: by 2002:a05:6402:550:b0:6aa:7db5:ad39 with SMTP id
 4fb4d7f45d1cf-6b3e5a00af2mr82366a12.5.1792534215024; Tue, 20 Oct 2026
 15:10:15 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com>
 <179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
 <CAHS8izMRSU3AyVf+sP5uXShiSKuLumZwT=fsgW+bhJz47UoPRQ@mail.gmail.com> <20261020150307.258b00e9@kernel.org>
In-Reply-To: <20261020150307.258b00e9@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 20 Oct 2026 15:10:03 -0700
X-Gm-Features: AclHuK8BsF2XH95JeQFPf6l-JaNozEbyLRQcmco_5nfrlR9V-h8rfRnrpx5Opf4
Message-ID: <CAHS8izPZ18v_1CnRkaAAA=d94wutJhoOZdOFO_1CEXSexd_=EQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/6] net: unify symmetric netmem and page_pool refcounting
To: Jakub Kicinski <kuba@kernel.org>
Cc: patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	ayush.sawal@chelsio.com, andrew+netdev@lunn.ch, davem@davemloft.net, 
	edumazet@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com, 
	j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 3:03=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 20 Oct 2026 09:23:03 -0700 Mina Almasry wrote:
> > This is awesome. For years the skb refcounting annoyed the hell out of
> > me. I couldn't fix it on my own; there were too many edge cases I
> > didn't thoroughly understand and could break. LLMs made this possible.
> > Thanks!
>
> You should have followed more modern naming patterns tho
> get_netmem() is pretty bad IMO. PP naming is object_action()
> so netmem_ref() or netmem_inc_ref() would be better, no?

Ah, I didn't know about the modern naming. I made get_netmem mirror
get_page. I now notice it's folio_get not get_folio. I can follow up
with a cleanup when net-next reopens. I assume that will not be a lot
of code churn. I was also going to try to look into deleting and
consolidating some of the now-redundant ref-ing functions anyway.

I can also make it one of the design pricnciple in the page_pool docs
so that the LLMs pick up good naming practices moving forward.

--=20
Thanks,
Mina
