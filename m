Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525193;
	b=qmRsK71Kfgy6Lp4RiQR6Ypf4CcybMZE98LGkjDETjIg9MCdupaTxNDcDR4/TJegDFt3U
	 EyKUvZuzNKAbjv0H0hYiY69aCc+1PcR+EbuwZQtPORduPJLwcKJeqIgKxPWoqHVBtw8F8
	 JwlhlB7DJ9VwXFPJ7ofuMLeRotmOs7EAhy+VR77gD8xDIHv39dscVIQvazn99YHThNUIx
	 4SDaCBqSMwWNmDuqNcr9C0pPdfpGonATVQ/IXy4nWLH/ljNK7tP0LZgdSd0OVN70DAE+e
	 4TU0a4Z4W3XjbZRmyF7AVXwfjiuh8ZRYY958RZ75UhpnGnNriUGEwxLJhhljIc9MvaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525193;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=ZNMQYhmju9mqmOBv9DnhF24mCpMaPrR4UGJt4DmlksQ=;
	b=QBRdXexCIrhu30IA18omE+twsfKUVwwxqpDbgsO0D4HMD9wP1FewsbzwD6xOcmPnoRix
	 N//61Msfk28zCP9aracdMyXTGAOkqnyDJagRe9SAH4kC8MXA5IagGRM1nHqxtoeTcMorE
	 ctVjVcM8Pjx9uO37jb2b1TItNYcXjF+XpLqGzzFKVmoBH3eiJj8wqWbA6e1TZmEXwFkkg
	 Wnuy/nAU/MIVGoH9HbbYz904/V8A8s5by2UaD8N5qMWg8r3J3+RGCfkTYiFtAKnieTKQr
	 EQsJ5HqrUYZIWJKaCmtbP12jFjCGEf0pOznbHOzsHI7B5BZI6KMbM8h29eBjkTHdD0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="hiMy/ghi";
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2935E606A334
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 12:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2935E606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=hiMy/ghi
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5365d26ccbdso53705421cf.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 04:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795525192; x=1796129992; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZNMQYhmju9mqmOBv9DnhF24mCpMaPrR4UGJt4DmlksQ=;
        b=hiMy/ghiDM4b7ovoy+0Vn77oiyDHFAWvplcvAoT9c5Bp+SZGFd70KgjQmeX3O+6D/H
         8Z/kk8JL67ig1R4KaAncZLGOqNqOV4AZm4MlrJi4m60CyVcnFQL1NhdxgOz3vebtEiiv
         pFcblJcTuxW15Vksp9sDj0nvFx7ojVnkjlKrFFVUXhshCp9HoCo7OHxaat93LJ7lSyyZ
         jBKVoZfSSjTFYGO2eBI/YlfiHl0Ku6cf1QYEVk4HJ79gXTTCDD1pErmMU2Yj+U0YjBpA
         0V4vbm4++wCpTCgcmuM5fAQ0O3ARdRzBRsUsoNz3dkh72Qejgo7Vo/vaxhtjeqM0Q2fr
         ehyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795525192; x=1796129992;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZNMQYhmju9mqmOBv9DnhF24mCpMaPrR4UGJt4DmlksQ=;
        b=QBCfZHz8ywd3SMMEKQDGrpeDpaV4vGTZ2lskpPF5vxwZ4oVm1jjX0a88hZaBFD2S2T
         0nvwhQdx8ljB3Uoe3Cx/1XB68yYZ2MwI/z+5hPVzfVK+gfG+A4CLYw2G+vbaKB8Mq3Ve
         FvrqUlHuABI605rqhae52k815XBMER3SVfOJbkzWwPWn1fu1Jp6KoMNHOPHuC9TBti8j
         d/Py/lAEUG0RFSOb1LMdSdmk0dfunMasV2ufxxnJFx8WNdN+tHhi6e2rM7//1jsbnR8N
         XKYgLbwD04VQRbsalPvWQRs+WVdX+H38q6tcXzb7ZhPcFyQiGICdhl2MSFswaB4atYCn
         v91Q==
X-Forwarded-Encrypted: i=1; AL+hErGT1pBxe0IbM2ENnc77r5PLntZfGCCyntk3kifUQJ/MHUMjIvt/QaArVh5OmVtiUch5ZALiD/L1VoyV@vger.kernel.org
X-Gm-Message-State: APuU4Z/flNfmKR1sJ6/MjapSJssdEU6qcoxZwLgIL+5Rp4gPr/+G4m6L
	gBpQ5bjk+0ZMjUx5RJ3y0GnyUzA74Di6gDQzn9PO0cTtznAdahOnVLfBkwOMWJ+0/Xk=
X-Gm-Gg: AZFdTZdBLwjNwxUpYn0tKvdu+iKQ/yH5vtfCIuAXpUAB4/QALspORZFbgEVqv/PQKST
	+dDfygsB58WiWFVljFYhVWEghuaxV32efRWSucI01wjcJkQxIMbWC+4NpsYfRBMKk+wxcMNog9B
	N2p1DWc9GtkJ+10pMBWLC/kYHpzreprY5HVLOcM4pV0BrXfc5pexwDOGUp0Z4gpVPjmYArzGbBQ
	GjwvKxoUgm9+JmcM5qRUWpnV6jmlBdeaAQt6Y0s/+PNJiZ1tQPb1q07INdo3tbdgi/NTSFB0oI/
	JP7N5H6cwytNf0eAZf/88l2RBDN5/gxhi13G6Ft3HLJbVhVILnb80OkvgRgo+nw7VjypptGHBrp
	LtqGzv4RABHB6cPDsq8JKCQ06QCAD6j580u+ssFotkRPzGft83eIOxkBUM06D18NW+n8YX5T7Fp
	Mh9Fh21xBYy/ecHF8QgwIyHj3xFZBOJFcU1xPlo/0S9q0R3AHHs482smReRrrvYm0cVS6nhA/9C
	MU3XVnuE0Dx3gzHR9ah65BCkA0jpgtwyqTNAAYq+WdiNE4SyovGRCxAIyXiZoowoeRnJykRp35N
	bTyM5EPKhXKoA1/ngIvTBR7IqbI=
X-Received: by 2002:a05:622a:a0a:b0:536:691f:b7a7 with SMTP id d75a77b69052e-55d76a1f9c3mr267446301cf.29.1795525191976;
        Tue, 24 Nov 2026 04:59:51 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78811fd5sm127268421cf.8.2026.11.24.04.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:59:51 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVq7i-00000000Nz6-18ee;
	Tue, 24 Nov 2026 08:59:50 -0400
Date: Tue, 24 Nov 2026 08:59:50 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261124125950.GC9566@ziepe.ca>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124125327.GR14811@unreal>

> > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > 
> > In adversarial mode the NIC is not trusted. As the kernel protects its
> > own code from it, user space has to protect its own area, e.g. the data
> > path that polls CQEs directly from the HW.
> > 
> > Hardened user space might use a different data path, with extra checks,
> > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > space must know when a device is in adversarial mode.
> 
> This information is part of trust level series. Why is this a “must” in RDMA UAPI? 

Userspace has to work differently if the kernel driver is in the
adversarial mode, and the kernel should not permit an old non-supporting
rdma-core from loading to prevent a security downgrade.

So it has to be in the GET_CONTEXT handshake to do all of this.

Jason
