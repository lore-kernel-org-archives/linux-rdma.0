Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174935;
	b=CcUo6wkaZ8vVyN2yTy+Ei7HdbTJulmPty092qxDyvmYLciIN55RN9bbcbOTDK1rOvhTV
	 1kQQtU46Xlpur9pUKisFpu8iZZH0UxG7xzH//NSOi3Bsie1LuOnaq9Zx0siSDDhskZFqR
	 UkNnveCa18Ud0grh9JO6e+Bt+rYuSfAbnxkeIj4VQ7Hd5y0CvHk6Vxc2xwv7OjHw+ve/g
	 qIJde3UN7ICZAI6jgE3GkUy9ZaNkFGXfrNyVLwN9MHvp3UyTZ9GpfCcrVntgH61jLJ/4T
	 mMBddp5u58qZsMwjeitp3W0clFPKw5MIuAaAIVGdJSYcsZesQIHQomvtDj+kJP38yTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=p4UdC3jB35AUdbv2e6iqz1BWlhdEhYwpd/LGSbiSPto=;
	b=PDjGrZBhD4YSutLsFlUyS2f7LNWK4CPYV4DpHwdp8sn1S/BJoG7ApzBPi9z+tY+XJMQp
	 EqJqu3N+alhCGU4LOZOuvUXQIiP3PBaW+7roGCLjVayHss//vhYuF+Zvqj9gAwEYW/WXd
	 jWDjB6v+sBBCjglCrNMTerODiqYELrN/P+9sHZCbGFp+0kt8BhKd2un5No1bLoNIkUryE
	 n0/LlEPQBWfhggxPejOrnLeLYl3im8+X5C+gPoBBrbLTXdYAoTdWrfqVKnXC8NIezYWSJ
	 yYiu6ZEL83Hf1ibmVuJfmmXIhrLC58bhJD1XtASPC29opVIDoL5NqD+afJaxZVevdZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q0EPZbJj;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F90606A32C
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0F90606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q0EPZbJj
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1737743a91.0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 03:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174934; x=1795779734; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p4UdC3jB35AUdbv2e6iqz1BWlhdEhYwpd/LGSbiSPto=;
        b=q0EPZbJjt+GMdN0GULFcmOIJOxL7/rNjEiw36j/wq4gouA/cRJtwM8Ueaq43GdKqYO
         +tRlzWt/jkkvOFKI6jPn3IqzIdCB/Y1GOqV5TR/YznbrA++0viMvM8Sq6TB2t1dO0BaY
         Y1F1/H9Yplf45Y/MO3H1DeByqScsJ5J2MwJ46u5M2mS8X3XuJGE+PnaouCN4lpL+w6I6
         YVXIXSNUBYMg4qjzryelmsQclKurwinnB6OtloSXT1LyUQ8IIJ1Wgbj6v/1QblV9yqXH
         NRPbHHhOc/vTJCwQPwycOmN+64HM5TOMnNk4XvYXRPjrYEbcOtBwY1U3mmDGQsGZ6pqp
         RXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174934; x=1795779734;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p4UdC3jB35AUdbv2e6iqz1BWlhdEhYwpd/LGSbiSPto=;
        b=mApsuY2Q/4nZQmhvswXRSjbdEFoX7eGDvrteegHKvLmn76efd822F8CY2adatywRFp
         CXLGeMgr2kx7J+RrddQVLlQiZZpNfWzF0sPcIJC1T+DsBclWpFUp3kfwGNkXecl+m9g5
         gbq106ALnYk+A7tMGwcpKIxPjfVI0SErN4hNk2QseFtwAXoF//UgX/uegBCJBxSeRIhF
         eak4nMSf3m+Moi7Gj+A64tYlx3NeUxR8wta3Lw45aepA1wu2aPq/DQ+AeBJpygM3d4bb
         RrWpHVVIJwsbvuSrOui8WQU4asRlxtpaFHZ6vUm8KmGW5fI4tktsgD7zLgjNv9RhriYK
         wNPg==
X-Gm-Message-State: APuU4Z/ndJUVTB4hY/2GXrnp5gktba5qEshHQHXprMT12WwzcMtsfygv
	i5pK4gnuUvoWYxPAFxXSHSQYLlN91V84c2QJkYD6SSu3BRqzhhdNHiZtur1kOPOrFSqxc2lmIHN
	KBkI5
X-Gm-Gg: AZFdTZeVIv8zJgXOQCdDQauCAXIj39zoyvINQn9OSRRXndfAS7lfyLDIP9bB7LnVBmT
	Mj0Br4javM9PtbIKPLYsA5o++6vrXJVi8GjOeKvhxOG4drkvrO7EXgfP0yAhGzv4ZSvZHHjCJ9D
	skAfq1Lf/dkvbdCkptCVKBOXzO+84oFZUiAOpY5BriMnS10Vvin2ZavVUVCH3ReHrGga241w5RA
	QSt3jSHmycWqBpgTSyLbAyTFhEHiNjdboNoK/68CRiP13zHMIAQoA92Kezaip6D1Q6ItF5oQcOk
	RFVO5BzCko/QgovRBaWBgAkuSosywByiP1i2hPaWdGd7bhRLHqMhYY1+DuBI4NcZNUFbhthEGVu
	tyLpjAN04Gki4sAsP+4OOJhbIWJXZC93bLtUZT7qwrOmYYEper4ghJ/YKHqs/Xr9LdAYnsE/Z8i
	8Aa/YTRsZC5kECSF3fPCRgpwhbc0ANam3pI7opUNpuO8fu+Y/jUQnTgJrt2YALXAHRJ9TxjCgo7
	80CK9i8Yrkf/nFG2cXehjaHCJARZhgkH/3kN2tMUOiRCoyXdQWrq8T5xflDNG83lmlqLQbRuidV
	HebxPUbWfjMz34av9EJ1gasOUhq8Pv+oymT1vRGznoAZXBG6ZtBF5wuSKBBhs8HbUPbpcElsaQu
	WoyqTX3NcB0sm6sdflAbCH/fd2/MOy4xVFFwa
X-Received: by 2002:a17:90a:dfc3:b0:3ae:6e7d:7fa4 with SMTP id 98e67ed59e1d1-3b40a634979mr3235082a91.50.1795174934087;
        Fri, 20 Nov 2026 03:42:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfe9bb9sm1149168a12.12.2026.11.20.03.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Fri, 20 Nov 2026 20:42:09 +0900
Message-ID: <20261120114209.3072101-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
References: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20260818035229.505098-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
