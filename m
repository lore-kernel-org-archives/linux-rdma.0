Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692954;
	b=VvnCwEqul4L1lsnDyk5jQHD2n+4mefXoDNsDU+tJs8r9qG8kxA/beh4H0e/OaIbo5eyL
	 HIsTkgzmjtPZa/eWBcEW/iE4+pErEkizSHjuv/8HQfGPj85+VzwLB2sPuRif8VfJRhbPd
	 R6bOGOScN0y/+yipXEte9xFB1XFsaOu7ZJ7Nf9A/ZjNPFY/gm07zFDxjBQxIwQ+cjE3hC
	 elF6urjLgpBP5M7NGL5WQ6O19N9NT1+pcnvOLATAGKCii5+cJ2fhWhVWmBiYBuBRYH6C4
	 zmYs/F0K3WXPxhF+4zh06k7Z6cK+/wtI7uuA0zsicZDyQjtpZeNwf3opByMNqW7zVmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692954;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PaN8bw/YeTmYvJNsbSyjovsCwKlcPndZnsf1s/btpFU=;
	b=ho3zJD/SqE124PyRn/BEVd25rLmPY3ygPowqFFkYu6Mi2/p7RNmoxjua0XTaV78NoIE7
	 x6dZToaLkn1DkoS9eFx/7j2B9iPsVMUjZr4oFUA4TL87BC+XIwq5i/F3GVqCLf+WKbSaI
	 BnB76y5zEJGoPu3jNb4DPwjmTaaYm7/GLInYvVgyrFlGK89iJrJAOvo2cO9eodbyYSE5U
	 e7N9/y5EJsbsLKme09p/LfbMLe9Cf27l/gCYLGphseOBIhval2YWiYfK7kWx1hd7Aq0dK
	 lVCe32PZUdjwNBYxLtjdP4kq7Qm9M6CQKTk7VpKk5p+lDT3Sgxdbfwt9gIADYbwVdHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HUdkciLA;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD83F606A31B
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 18:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD83F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HUdkciLA
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so14391a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792692952; x=1793297752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PaN8bw/YeTmYvJNsbSyjovsCwKlcPndZnsf1s/btpFU=;
        b=HUdkciLAp5pcrgIMeGlsE49QqY4c/gj8GGPVNzXjaemqOnDMlsMfhrFlrzH0TK9E1j
         M/NMp2TN5BE5twQ4b6AQzmZ7l+6ZJZgEtiWVLZknISktkyKaWT7sTcYlVlV25yu+2lRl
         nFDgf1FQ697hKc3Gs96cp0ZT66kdn7EQ/dURcm4cV24EASFIOs0hdzq8tNHG1CevRc0l
         hGVt2EW9JdQd10jMH8Q1YGCVlbe1mFIRYICPJ2D2EIVNSULGH6qnSa6ubh+SgDkBur6v
         cLJlxp/p7/9O6Vg7ndjQvBalbX8MvaL/AzPh2gVkMOYnmKdV5Ey0LVL3LB3xf/4Ejopw
         nINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792692952; x=1793297752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PaN8bw/YeTmYvJNsbSyjovsCwKlcPndZnsf1s/btpFU=;
        b=TG7C6Q0+ynD9E3AseA1jjdQxvRrTumnf194Bh0Op4Dv3ilWXicGFKflcN9PkcKY+hW
         5+e0TaFJESLArOcLACTPLxmEdePQFfQv/dHmK60qpke1pWEBDJnYtHznh6uUuyDyjSzQ
         HEJkKx5I7Fln3mR9fbOnqXJ06rTyXpgaBnLOXg8D1US8PNm/hLo2JlJUir1Z/DqTXhUg
         7Hmew740LQDUVKJwokFfGJEFlbC86doWpkY9PZupT2wo3fQbrh6Cw7WWnoB8zraz6APy
         PTqlGlcg5h9F8P8G7orTWcEzM8RSQGZXBWpuD+BZWBwOdcCXNfW+2dg+X8Vwb+BQj/rJ
         zMHA==
X-Forwarded-Encrypted: i=1; AKwUvBxjNpraUwlnC66BAPgJoFX8PRgPLI4GaGYJb0ryjc/bpvj3gSpyox1+rx9jCKSM0/N6o+BS6btt2Lrf@vger.kernel.org
X-Gm-Message-State: AFq9FYLSrAmxUUwGEZsOOWngRufggKbhSo2tccUcdep7RpGzETMA9IH4
	3l2JvBMSKlwWcu2EjYa4SnVZ5tmlMjobFCXxFttz9r8f2Ogj/rVc0F5ld1ikeNQL5bl8KiHCUSX
	OyYN3
X-Gm-Gg: AYBFou20Xw2Nwhaq74OUfeSBkzHkPdWHZvCukNSWjaaEH6rrevelg4RTYU34xb+pn6v
	rqufbaobzn6uXdA6YCC7aqUo6aRL2kjGda90ol5Bqc1vhFCN898b+1sbAMUow6HeiAzXC1Jgzrh
	YHyfZ+Iz9jx6ur0BCUtJc7M6F4r/dXIaAFkXMk9gNX6AQXUuSduZFxyJaFih02OGWf/xrB6o/kC
	V4W4MQdRHHUFer0vE7Elxqetan7lsAu1ntciHthsjUClzBVNPBciQ3blEsb1rjppfAqH5KjkNMA
	BthgXle8RnWcIge6jyW+bfA5l1/KLTIV1DRVJnfpeWXpkwyuvJdac2OqQh8L3OpPOD25pfZywER
	BnaktPL4ZeVS+EWQykA1IzXBhLm6Nrcjq3brSBnAqIO+tmvwajGb+yffVI0GG+y65Z8ZgScDHjL
	4pTBoG4M3s26znOgUioeFKJgPQU4lL7/9jCPi6ztPVb6XybQaC4a7CELcqjmTx1/YSdO3D8PxB1
	/MBzY/nLeRf16GBrNYj5UgbmmJXdY1PIGtXpu8fdu/TPfdJc6AfTXYdkt4rtz3zQcBX+FvU+A==
X-Received: by 2002:a17:90b:5403:b0:3a7:a3c8:8f4a with SMTP id 98e67ed59e1d1-3ada6c7e603mr1884805a91.18.1792692951864;
        Thu, 22 Oct 2026 11:15:51 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([115.138.38.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adc8ed1b23sm176638a91.2.2026.10.22.11.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:15:51 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Fri, 23 Oct 2026 03:15:37 +0900
Message-ID: <20261022181537.3002021-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
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

Thanks, I will switch desc_off to a uintptr_t subtraction.

The room check is also wrong for a short IU, as Sashiko noted and as the
commit message wrongly denies. The division truncates toward zero, so a
byte_len one to fifteen bytes short of the header gives room zero rather
than negative, and a table_desc.len below one descriptor gives nbufs
zero, so nbufs > room is false and the truncated request is not refused.

v4 drops the division and compares the span the table needs,
desc_off + sizeof(*idb) + nbufs * sizeof(struct srp_direct_buf), against
recv_ioctx->byte_len, which refuses a short IU with no reliance on sign
or truncation.
