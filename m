Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505341;
	b=OLOV6pMsZiHaVm+QmGLhYNL8EBuXqkwlWFFtuTDSOR30zixBwi9sXXb9CfIs8lbO1bq4
	 im72Ftn6zzWq3zexNRvW/MG+mxc/Oz9KbTMFogpAgnNqut0efK7UqvkJ0cIF3Au5nV/Yv
	 nmWHIUg64bQxCkxfTnie2ieBtCF7Yv6R/TMgT0ZIMvibgJcbbso/VnEzOJCJ9BB477Cw8
	 E0UXpNR3giURyOkSnoBJBCn9QDyaRFO+d3EtPlaRzdQ+o6zhi1CXGS5uYoxSfHrGQ4SYb
	 YTDNMd6JF2c2ey6NNiWJhWEZZVsSPNmK3dQgp3OkfdJOEd7RYuBrfHVl8zyhHhyueXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=Yqn1FO4I0DjxyEV4hfY+IrP9ze/3wMUKhm1cvsmGmxg=;
	b=rd/SwnHRdyOJ8iycS1InV7i0Ph5BV6jbz0xHM7VjSqF7vOK244wEjdztC4JzAXRXgQhR
	 lde79qNUeLM30/SiOTF+NICxc09v+EjRE1IyPDvt/a51HZ8d912vcMFdIvZWon8WfY4QY
	 icZMzm5meaaGAmx9qBd+KMVgn8SMeNqQnuFSX7bSchuaANBY0Kh+yb9ldVGVz6GJ2ZIKN
	 ssanh7zM4mFM+7IsV/DaUwGgx6WqbgvQ+Avpk+Rh4RJdlzTv7i4qxREBxfouQTumqjQ3e
	 QCGCTW3ShA1I2KoI5s2nIX4+0ExenYgo9GcrGcXaBxGZge7esbzqtfLjx84boLqjLnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eVmdPbDV;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B832B606A322
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 07:29:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B832B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eVmdPbDV
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1757122a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 23:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795505340; x=1796110140; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yqn1FO4I0DjxyEV4hfY+IrP9ze/3wMUKhm1cvsmGmxg=;
        b=eVmdPbDVmfH1o8pWxxbI3Vmh0fdBbigCHIOHo5tel2MDsgA4aVqTNhiKU8AQr6+thk
         W0WTPLnD/2fPw8zo5Zqsbnj5PkgWpIdOdZEgKC2CBgV6uYuMDOWL+f80RgByu2unl9/q
         XR0L+SI2U8yL1e1Gn36qtKvwe1eRYbX9bygrL+iVoDv34xXhbkgc1R/wrF5DPdjo2gWI
         At1mDGofxLwNuJ9EQoBwQkb/61yoi01hbT++HufcG6J2xD/UUFRv/x2PF/ZkHq40LHh+
         LF+6ofMTJk5MHwa4t7sYLO3Y0I0QXSI2xQaE0HjssG3YUOY/TwvIgHtd3wztjOZrCBZq
         F6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795505340; x=1796110140;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yqn1FO4I0DjxyEV4hfY+IrP9ze/3wMUKhm1cvsmGmxg=;
        b=c/VXZOOO0my1a3TTjVv0O+dRL5oP/XzWajjbismdlbSBwr5YZgjjohqTRvx6lJj5Ew
         c8k/zM1klpOr1MLes9xrS+BRuG6G7KcwR7E2q3lEazR/2IV9Eqcs/BwPp2Xj48azLzrg
         2h4gYwK+2RHlrNej2GTqvZEOYYMSIDOIeHB4fbi3cTTdEKMImADg6QmFurkwpPKfERiC
         FVF0s6GrWkXlmiEtPOXpaOTAhPLF8uHOkkAVomP8jHeg4Tqy05ycQ44i9s+gJRzbhPFA
         L4+W4UZtHKfAHQu6bUVgq1xZ4W7Jf1XI/i8LVmsQwRF6cDSjo8diKxphTKCx/zI1pD9K
         qwxA==
X-Forwarded-Encrypted: i=1; AL+hErG8CtYz0BZclPiP1ooKDSUjOpl9dVK1qRD/yWr8Tfs2gz47NLm/iQVthE0H1FxF3cRgREwKY/rE/PPf@vger.kernel.org
X-Gm-Message-State: APuU4Z+/LSzqOywAXbykVxXmImd8VZA8XFMYyR0xu9ZVsVc1/XXSY7Ps
	zFLEle1kwlclQOAEtpTrVtovU1dbC2yyROwqyUCdYsWF+vUuZOR0QSreuHfm1DxmamQ+zQwU
X-Gm-Gg: AZFdTZehc9QTIwLEMmS0PMhIS3PEsZxamcEICaApjAUA61Jl3cdzWJA5vm/Wa1y5GXC
	Lmnm0zcAZP8bT2jgkhhfY2BPBMerm97Vw0Ktt2VHd8+jQAahwpfc4g98HQ7gl+cI6+2VLIL7iTN
	RYmahC0FlSnEnGNA+ke9ur1IPvFXzZ/AhjrqdtGYlQYTGjeMP3+Bj5wldecV8S10UvuewjjF4y+
	qOq2t4ZAjXWBogfhIGCamU/IK69gwvWPSWOaEa1eWEHmgyy1wehH0L8q+KdbZzuWVa7d+L5hEUu
	g6uNl4KtOWUapBG5ca9IR5btbIrwV/qBtgKH4tSy7OQyrMJpsNpqfBOehKsJjxeCLD1y9fXMecV
	t9k2VjB8elpgFZStkk3aBNu+R63aykty6SAfbe1jZrlU+RjDDlbre+RYUeX9WwAsLffs9vM1+sV
	WoUBXmrZActu5yzmzBGwF/zEVEtKMnD6lMgfvpal/T8JE5mWrIUcxwNKvGbFndF3oAgi0zF2kCO
	wkYns/HshnmFdA3TVE5WEOoimqiez26TkoRDVi8rlbMTK1EQX3J1akkVQ86x4zhykgv1aeOZmKo
	B7sTWvQDzsQUV7dh4f4DVC+F6ZLgp/6vq7xgx1o9q9F7gt7KdPXFlLUdZG5d6AJ74hJYb6FxjCP
	k83PvrhNTDZFhRLFoidJ9cQZ+ovEPm0kvbrzt
X-Received: by 2002:a05:6a21:4383:b0:400:6860:e8a with SMTP id adf61e73a8af0-4014d35f22cmr12901584637.46.1795505339693;
        Mon, 23 Nov 2026 23:28:59 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c228sm6643068b3a.10.2026.11.23.23.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:28:59 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: dust.li@linux.alibaba.com, alibuda@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursors against buffer
 bounds and window
Date: Tue, 24 Nov 2026 15:28:53 +0800
Message-ID: <179550533320.20886.15449362529729238604@gmail.com>
In-Reply-To: <awUPgw3EGv7ATYRS@linux.alibaba.com>
References:
 <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
 <awUPgw3EGv7ATYRS@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Dust,

Thank you for the pointer and the testing tip!

I checked Bryam Vargas's v9 series (specifically patches 1/6, 2/6 and
3/6) and confirmed that it covers the same cursor and accumulator bound
issues completely. Please disregard this patch as superseded by his
series.

Best regards,
Qican Ma
