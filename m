Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06934040B
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 02:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792291097; cv=none; b=dJOII+6N8d0YuotXCQoipWcGbuvlnUVF6L3vTSUxwV3m8yLrrApRaY7QG2hBJZe2M7mvN1Q8ryxuzZEu/CdNYkx+9sxkwgwCTfqPoHYnx/aRvKFJnZn1VyYtkuRx2tsHErfnnp3qgzfo4RHkN8tftp+IAzgS9dgnz5xOptkFgbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792291097; c=relaxed/simple;
	bh=OprDKVD3dlInOK+EtkJkBGY3nlx9HocRm71U+En4ns4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX8ebRiVISazO9MlxNb2L/6p1oOF4SnVupS59CwKc9w+442uuV4RN1P/PczYhEo6foAMxZHsW4cXtzU2yLP3YExjuGkGpRXcZve3ETOFBTQWtCvQUV8Kz2goWfI5OSm6xHoVGsDRs3/U5K8CfDdcnd+RzuoBooV9SbS3iyxsam8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=cFtqatdM; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="cFtqatdM"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso1603967a12.3
        for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 19:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792291094; x=1792895894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uuVxX/jLPtohDOq387cSqeqHjD2U6i5S+xDw1QtsGiQ=;
        b=cFtqatdMQKgmQSYSq39dS9PbMTjb/oOnEnOFu2GDA4z+ZyGbjIyySV5az4gfb4NtR9
         AVD/yCtLpvN0/YjkCU76bBR4Pnsj+PgIlEzafq8WYIpazHeQh6l6rsLdenVSs2FMa2ja
         5uhksrEELgmHbcewXdjdG3shuBifY6ia8hdn1DvWvYQvp3eaqb8Pck0qAPrhu7tFOfIa
         9YsX4OvnDOxe9pDGLESLlwC3Tcxur2p9YkEXHh887S3AN10uKePWr1El2P6t3TQUIJf2
         a9s+SJsSn8KYtnawo9kY5Ca0RkzAsPej6F8ZT513+kjcsYEmcE6zs2Si6xnd/tZUKuk3
         oLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792291094; x=1792895894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uuVxX/jLPtohDOq387cSqeqHjD2U6i5S+xDw1QtsGiQ=;
        b=Zt7cNswBq1eVJ2LK8sAeLmBMG51S2ALbmgfulPGmthZ/nFoPmiV1XXDnRXPVamiTQv
         O0V4M+49mgDv/fK4hPg2Rq//gfqTdvTeGge0R2dd1ZMkX1qDL2CEhvrodaz8Er2GNQtx
         70/X94lgUr0AiL5qMPkxXghIKpl5iGGyLDn44POXBH1xbU+f8E+9qfvjAknxM9XcVQeh
         vWESzWA08HsyN7z9cz1LaRvX3NYH5jzIFAu8bENTpQfCC5NwFOS7+lwbWUO4wImrVaMt
         gYkKq/QxH5vb6XdqUmtJVaLdnlrxIQD0F9tFYA8Y4VO2DIlAJpfLRi9m3Uf3OpezGX3d
         +WuQ==
X-Forwarded-Encrypted: i=1; AKwUvBylwI4053WKViaMIoS0UtnNIppFngW76YqXdd1qf74kMx6s2vjoSAx802H9cDo/hVsU/nesZuKWYmip@vger.kernel.org
X-Gm-Message-State: AFq9FYKqng+/arMRmxOwZorD5WY8pnjd+Zsks2Tk5fk2RfWLYuWVTi/r
	px7vKiYgwKvqHov9hAfBywZJsKVyF6D+Da+AfZqTBw566SoUx5uOfKGp6Bz4Kj5DIKTOwSy6DaD
	iDw5GT3wFfXM=
X-Gm-Gg: AYBFou194VI8U8CGH/6yd2+WOJK2FzgqEqynCgC2rxJTB6LuDb9GqdRfngG1T/bDpff
	vvAyAlEywjH7RT45R3bMZ/WtVu4PKCDDorHhxTf+dmvJoQMld29OrOFRvGTJToVOlIA3NtC+aDs
	m+RlD7GkrtOEgluMN63WSevqjS2TXhLf/A0xdhTdHPYjdm5h/zsXA71FOrFIkT4JSEHokt3i4Hh
	Flz4lN1MYK419+01GHttNIs/pNxp1v1D+6D27AXkl7EXoUMXf3/VjY4AjGLonXwpekkigdqgl03
	VVCYxMVlNZ41RGUecZ9L6UZyQrVV3yhQf/2r1RhJaFvhpzIT3fEI3fEaHZ2qJhOTB5eXR7VPEok
	+imzT/jY7EZvsTSYAfwz8bknIlj3yb2vgX08UVEj2V9p85VjhVUROsECRbyroClj7UJHB4TQKfe
	9PiBD089hWNyp/9pMI41G3Vr+c6aeB1p6bsKiGKcu2uZWEv9/YOlH4CJbl9GvvSVP6Ab+LJyzGW
	hGV97KE93KdaSYb6elGcVckMjDcH5EDYXLPlBWFCkdbZOdN9M2x1bhw61SjYInEKbLBLHJe6jb4
	vRAliuntOJsEKb+StnGEEGM9xIb3AZaFEBuOZgpTmBIalg073lnh3nHCbJBKBPr/cfpxt5JMfud
	64aUbBGqqErNLeEcEx7mZV2MIvdMdeS52sy0Ty2q5x3BojzgxEZJUwDrCi6jshf09dnEGXom6Bf
	yOxqw7yvity6/qwKGNWfI=
X-Received: by 2002:a05:6402:2489:b0:6a9:850d:bb38 with SMTP id 4fb4d7f45d1cf-6b3a81766camr2392870a12.10.1792291094015;
        Sat, 17 Oct 2026 19:38:14 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1c80desm2356771a12.20.2026.10.17.19.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:38:12 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/3] netfilter: flowtable: carry a priority into the offload
Date: Sun, 18 Oct 2026 04:38:04 +0200
Message-ID: <20261018023804.562323-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atQk1d8Tv03iPN7d@chamomile>
References: <atQk1d8Tv03iPN7d@chamomile>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 03:45:57AM +0200, Pablo Neira Ayuso wrote:
> I don't understand the "one flowtable per class".

If the priority is a flowtable attribute, every flow in that flowtable
gets the same one. To give sip 1:3 and https 1:5, you need two
flowtables with the same devices. nf_tables rejects a device in two
flowtables of one table (nft_register_flowtable_net_hooks() returns
-EEXIST), so you also need two tables.

With the per-flow priority it is one flowtable and the rules that set
the priority today:

  udp dport 5060 meta priority set 1:3 flow add @ft
  tcp dport 443 meta priority set 1:5 flow add @ft

v4 waits until the fdb series is done.

Julius
