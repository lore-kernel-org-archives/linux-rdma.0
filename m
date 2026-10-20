Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507963;
	b=wQe3dKuPCB2gSChP6y0vkrLcK5EU0D1Il5yGF/jiXNm2S+f7i2iC4XCJYM1kfHpHYiaj
	 P/rBWHDG4K4EHbcT8XoounoOSwvdD3jMuPE0caD1krDJ3Y4kOW2pHNuCL8WtA5ptj2KN+
	 kI0pNV2rrw3yovAFOkzr4frkQKwcO7hb6oXk20lNSD+57OXfHJnhdzKYluEsGnchkNXjZ
	 Zre4HqvrOS1JWUPdIyd5ytyFj6DL7wZmaC3DPTfrWBGiX3WBrh/NXqp2YyIsncaEb+qVJ
	 v9BG6kVbZ8gffdaEC4HyABBMuStUEAfB7gg8BeQxmjDpxG1uQW6jme736CHds7VOt9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gt6Y85M4kAfgeFbvU9seGRhqfBj39ecJG/UgGwQgng8=;
	b=vD116poMQ1lhyAq0jNrp4we5gEwEIKY46Wec1dgavjc4tRKcxlLi1QeHIOftPfpB5B8x
	 FRsUygM2RFKm52NgVhoGy5WQEE/9uTHHYY4+ERbz8rWDkDFnoHMQyGJxHZ6wMsfr+icPt
	 y0qi0K4v0Y7rheUNrZMJNcK1Tcz/psdR20cRJUXquLo4LSuXQAeV3ss0/MYqwo1oE4ToE
	 B1CU0Ff5S8+FUFUU7n4wfEG2bIAyXBWM4xX50fmiMT4H6ymM8tfBEQX7lKraX5Qz7jGh7
	 5jaRzJqgo3Dr42moWIPw/X3OAL0ozYRpz8a0DwvKB37JP4w20dMPYY7vii8thbezecQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PSP3O93a;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5FE606A323
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 14:52:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E5FE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PSP3O93a
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1dec056ddso19044825e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 07:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792507961; x=1793112761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gt6Y85M4kAfgeFbvU9seGRhqfBj39ecJG/UgGwQgng8=;
        b=PSP3O93acGb2qbkqkldCxvnM+Af1EZDg6E3X9A8QStfBeJAjsa5Lu8MRiTNi8+zS+x
         o6HPz6N5ZmCl1fWr6etwdPtNzZFOEk/LA1T0rqAzwD7TudJwxpxlqj0+9iPyhGEvKUNA
         DH9NnTL1Zc6fXXSPj2adSYvlCRfFZjPWtCRB7WuyQSkXkQo5uocr1HuUh6wECwE7CVXL
         ExdSYerpS6CmBdq/5FfPv5H0dmOL38NmHNvKcT4V4DVMBO3Yd3Q+ZL6z8BWztj7i4hiH
         NMh3Y/PQoxG7obPJi2dVbh0oFaFPG5xAyNErJJQD+Tiq6bMq0JkfXzIY7B7Ulp6Zh9PQ
         20og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792507961; x=1793112761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gt6Y85M4kAfgeFbvU9seGRhqfBj39ecJG/UgGwQgng8=;
        b=YjUeZN5soc7F1mXUmbJ+3pYkO1WVepA/GDA50XUyBDbFQvR7uJ/7BJ6OG0YaNSANCZ
         rIDkCxr38ppl8R8E32e0OvbQxgurgUG3AaLzkmN7Z+5lzuAr4LkDcpCF4ghmfhrILs6k
         BgcigWLe+KM/GLcHCLAlLilHb+hKxdw/yKv8un9I15iefPt/D6k1pBAVVxqfZzBZvsCJ
         A2zgZx5XLuU3RYl3Ji7EitjxK6Qx9SzpRCUQb2JMF1sqSn17/fz5eYMKSx2xyUHyfWSd
         KFyoCHXjdyEIRJx8h3Amk242y4NhsSgvSHWaC6dQT2dzuhUxKlfpxdmMpShhZ6H5HbbK
         EfDA==
X-Forwarded-Encrypted: i=1; AKwUvBxkhYF5NR2MhfZXGU0rJS04Yi5wn2bVORBCTdbqt8eCb2NSHFMmqV9BrjDn3JhhQVanzruT4u9yQqNE@vger.kernel.org
X-Gm-Message-State: AFq9FYJifi7QCXAei4jqNp82qXxhej+Li7oYJGsBxDu/Ad5PjdjvmH8i
	CtXf148st+IByczpr4L30HpXm/azr+pb2bW2TI9b36o2i4SnfwBPjv9zN7Y1HLIM1aA=
X-Gm-Gg: AYBFou3qMr7nVUQK/hROvMkBFoKgrAU3egQhGrhtK4kNrupwfxHY+KrufYCSJKS8Gvb
	0xAiBJZ+qaB2hR07S2RQglrBnOWWFF/JtIjqYnTb1/kTWrCsE1Ax/JN6QyFtSqPLaV3X3K9/ECw
	Ve+X72w7BxHeqV0y7Mjam2GW42vt7oRiyE9GtzA+273ja+M7gby0aXhxAqj8Q8QYUHp8+CzrQy/
	UVqOrM+ILKpwY8Q3v68h6T2nCrgp0dBlQJY+hP7HxNFcoHSkvwn2x6CJJb8j4VMFLbYAs8WzdPD
	6zBNCH26YWxkSomfTuaOYByocOrk7TmIBeMibu/ytLKy8aQrO2GVaSHX55HyUT22JdXM3c5NH+1
	anq3rfb2Xifq8Lkr4Ncgk0NfYh7KiebYh99nRqzCu0k0aXcbJnUhvKKeMw6VEwDvCDNBxsVNpdb
	yP01dxUyDFmXa+EPdqZCTZmb+hl99naCgLOs3IADIc7ROSG39rtVb86Atyl1MYdyI2F6ua5gw9Z
	p/sCpIObdpgc6OfEDYCcdIcmILLmm6F+zXxDqQqhBVBEhBzN5Jr81fpWKWlM7QZyX+xT642cAc2
	2Gud25dRRHdvS9zRRe2j9asVgLfvWlMqgMlSOGoGHiCvmvLFjjD2xhW92g==
X-Received: by 2002:a05:600c:83c9:b0:4a1:7ec7:a479 with SMTP id 5b1f17b1804b1-4a1d764145cmr213720455e9.33.1792507961101;
        Tue, 20 Oct 2026 07:52:41 -0700 (PDT)
Received: from p15v.lan ([217.169.3.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cdf2f0d1sm211770555e9.2.2026.10.20.07.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:52:40 -0700 (PDT)
From: Peter Morrow <pdmorrow@gmail.com>
To: tariqt@nvidia.com
Cc: petr.pavlu@suse.com,
	yishaih@nvidia.com,
	leon@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: net/mlx4: no ib device for Ethernet ports without IBoE since v6.6
Date: Tue, 20 Oct 2026 15:52:39 +0100
Message-ID: <20261020145239.3798017-1-pdmorrow@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014133951.3219055-1-pdmorrow@gmail.com>
References: <20261014133951.3219055-1-pdmorrow@gmail.com>
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

Apologies for all the resends, email client issues are
now resolved.

#regzbot ^introduced: 7d22b1cb9d84
