Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9CB442B2F
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746830; cv=pass; b=T0N64pRZTPh0m3UO62g7O9lDBL8JY6j6PbXglCr1Y/wnT5OUUqTh7mBiaG9iqJsJC9iMOLOK686hbOof0USNX/Y3ZcTKyyBcqnm9cHOFRL9/sKcRGXIfCqqB9CB1vzihhCOBg6ToRLhshQ+99ZuiA6PrciQyv+HX6sUk7FigbIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746830; c=relaxed/simple;
	bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nb3QwZqq5gPMj7rjR648DW5RgJZwwlslgCI6oVuLtezQ9tKQGIaoRPQrx+IcGP8f59jg5kX2FgNdVspDOevi6VFHpSJUuEBwqITNFMDhJOiAAFm6lctgNiDZhctX9bFQUNkO4OSRuT21e9+nGc9On0VyBTk7A4QhPTDEcGgfiqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=bmx8IWw8; arc=pass smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="bmx8IWw8"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e58034d05so5088351a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 12:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784746828; cv=none;
        d=google.com; s=arc-20260327;
        b=m3vXeBF9JJXIXNe77Cx00CZPOXGK1T5QV0h8TJPlsrGsC8AzMNJbAoIwnqbHVHL1VB
         xn/QTc9588QntuQmf7a4qN6+1x8lZz2k4xZ2GHclEPSZUqcCk5hgDfEOBL53tWAHhDgf
         AJ1dYo5rM1lKmpak5M+n0ggIEnPrBeFm392J+G7CobYmb2Go6InFpUm03CpwuditPcYp
         s9nV8tUGRmoQTxCr2bkVZL3G3IoMkWHFwM6jutdjV/WdWywCBccXq3U4V66N6wjzD4lm
         RgOYSc8p/X9RSbbSuh8up/0y9aZJdaRstTiGxIAgHkm6U/kd5pCTo7nadfyUCISAMLdn
         U67Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
        fh=jYI8RUX3c0oZwnMZ+mi0aIAq+W+vGBfie/3RwZsyy7I=;
        b=Mxb9dE7xMqwbIfrOhcuk9vOvf3IQuEfRb8VxSOz3Xqk2RIc+8355CXc3oVrhJC/QEP
         PuSirbsobz1Z4ztL8069OyGeOPQyahc7MVVCYNbiAdtD3avQVdLZ02iiJQCtYwbY4CrP
         ly8hUZuQjwiHRsU84i8n17yAEqYKXvtiwRMPqMfW4r6fZrmzI/7NHvY9glaAd/5cO9oN
         gKsoMCrnie2FBR1q4PGfB5whZTORKvJ7CFWpU8J2gbg4T45jF0EtlaGvsL2moqdHgaa9
         nTYn3t50AkRhNeDh8T5oCyi9NsdIDvqA2BIqlBEWgSeofJtgDYlKhIebrEAmONw0Zxmx
         ST3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746828; x=1785351628; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
        b=bmx8IWw8EccXq4m0q2xSFHQsBaM7x6V5/xPOZKKKJ9H6I8O7Lq8jQnEF/cVXbC869H
         jofO3O+ROTrCELauECzFq6zSVarnp5OCXBfAmSGShwoD/+ZXWAtnt77BtELaIqs1ex8s
         JDEYbaQnaEt47S64G1iz43BPk+bRmqYGTERDiSpnKK5kpdneIOaS1REu18d15SGDbUJ+
         V90ZfDlC02gHOefOOoSra+QBljTR4RXLcm1sIarf+EQ9uE5F21HDnFwC0gQWSR8lyQFV
         ofZeMsCKBd/CMn1SA8HxJMgdEs1x/in/zXtjvOa5w8O/Ay6z8fMcIEQwFKzKRBBcajOF
         dcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746828; x=1785351628;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
        b=Eqz+zsNJfb/dGxA0UglCW7hw4omPz3p31ob5bHxlVbQ6tfcN45FwEOv/BmQEqukpKf
         sNxoFER2+2RMEUCrwr8PiZpqNII+QVNpBpRUnBSsNecpiAICHYEsBISGtXO3NK9cOMXU
         NktQI4ff9Xj9ulxT3YBKOK+eJtN9EfJjViuz8ikpY/Bs46HmiEL/RjNBZ9q7koBieh9S
         La3w8QL4CA618a81N5/ceNdSkTNNVY3cHLTPQ/utmyoVSgw5LRKa8gMP5kAXtm/S9Cl9
         K/S+1/+14ikSA5zff2ARPb1EiEOh699JxSdamiucFnKyMaGOR2BltHJtUDkLQn6OJHfA
         H3Rw==
X-Forwarded-Encrypted: i=1; AHgh+RpABQTm4cClAUQJXmNJT8lAXee7gASTYqgw2yuIoltqza2xP4Oy8o452faEDtpbuoY/Otdg9qT3QsDk@vger.kernel.org
X-Gm-Message-State: AOJu0YzK/MJj0SIyAYY9igrg+OymYZi1XTppXt6Erj45KVItfvpPUF8l
	nLKdGXSKECwdulZKUvugknnMCbinTNuk8aEvEvXzVfRNRzwKjdadW4STUa9nN0V9uVnzPk3otIf
	kGN8Ak8IMxG9AOUJaZyOQDGwUgd8NfuYmBFIiQezB
X-Gm-Gg: AR+sD11rNadP1yTrxt/GHhzWIs2Si7mmDejLC3Ws1/Cofi7huPMTeOSfr5y5v8WrFyJ
	eLbx4E9twNAseF9O1Q5wtkXb2gX0fEQztNCDsVf5cz+ArGGhdLBbQohJYKn/FQEGeMCOodCQ/kb
	s9wbdmEiBjU+FdAWWgDN5zsuRZ8Kg0WwOGtLY4254N4oIAhhg/WCO7T+8CRx8DZioKs1QEDtKyO
	nB6Rx4r2QeFg6uKb1KSOyMErXQLPJTF5N521EAqWo6Ou9cYZQd5dAbrMGeUCgYetK/Z2YycxUWo
	FbgGn2Ecdglc9WXM5fGe+ZReqniMSiNSUQ7gDbLboTMNSq8N82L0AQKy8mbNiGXDTPGm9mlyCDj
	N2feclIg8tR72UyyYeCHbGNZ+lO1WBpokCuQRsNM=
X-Received: by 2002:a17:90a:d40f:b0:381:11eb:d78e with SMTP id
 98e67ed59e1d1-38e4b430c6emr27167946a91.14.1784746828497; Wed, 22 Jul 2026
 12:00:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com> <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
 <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com> <20260722083015.GU110966@unreal>
In-Reply-To: <20260722083015.GU110966@unreal>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 21:00:16 +0200
X-Gm-Features: AUfX_mx6Cta37C8DCF1XHW6rVQfC4bnrtxly1T6dzUQd_16ovjA21XsyVTPdIOg
Message-ID: <CAPzsNDuGfneEmx_nWqw5vYLyPyK8krfWChNRcsxO7icTEDDX5g@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Leon Romanovsky <leon@kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> I had thoughts about this series too. It seems best to avoid
> the P2P path entirely unless all legs support P2P.
>
> Can the md/raid code determine P2P support in advance?

Yes, and it already does: the block layer ANDs the P2PDMA queue
feature across all legs, so an array with a non-P2P member
(e.g. an nvme-tcp leg) never advertises P2P at all.

But that flag can only say "this driver can do P2P in general".
md cannot see which HCA device does the DMA for a fabrics leg =E2=80=94
and with multipath failover it can change at any time.

So the up-front gate covers what is knowable up front.
This series is about the remainder.
In mixed case, one local P2P leg plus a remote replica, with it:
1) a failed read just redirects to a capable mirror;
2) a failed write records bad blocks instead of retrying forever.

Mykola
