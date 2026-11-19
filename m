Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085605;
	b=dah7hYA/diQnK0HmUW6aC5WcfpsrnYSTwnvCMuld7PwFYwW05qW9KXlNKkAm8IjV/thv
	 aO5pz63n8EpMtt+tD0J99YwDeJrcOnkL3pA8UTFTWWP+qgHLSRj0J9as+EH3oxj7o1PDv
	 GJvYkpwGLi+62Hxtu0sIYI2jenvCoPNjS1j702g8WVqA5Hlpf6GQjuUuq/mKxXMF7qDia
	 zZXQhpLcZeogRkApuBBsVqx8ha/3IzGcNrvRNdOz5Oa7F5MwO5X6OwVGPd9IFff9IK/5N
	 4Ty6hSPY2qvmyFYZIJON5JD4FpqNuwgelS5fTmen7T6XWLTXoqfpiKkRl0I+GFpDytg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hqE0DnzQVOaqly9+hSqhRUU82CqCbvfu1P534JABEUc=;
	b=mO8zkUJN6Txbh+6ovCnb2lnbtWxXlrODTIgwOaYaEzeRr3QniEfDbxDEDvPANvKyhHLn
	 sa5Pov9rK/QQoUTQmprgetfT3pQncyfrscqIgRNRkjbRzxv/pubBxVvQtuL0DdWuGsFyz
	 mnEkoQ5kScxiX743/RUK+VeG5CAipRIov57srs2lvjE9XHHKQzLoMwyGBo9YLuX2W25tR
	 4ICQvjuylcBZGT028D0aq/uHQ8C35obWlubYhK7nNwyAC4q7iKBvXnj+KI0OQpL+tazHt
	 5++FIVPQFJbEwcCR5h4DFEI4ClmFiFyPn0yiOjJ53xGy/ZY8grJlkEESGkt/mKm0b0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bZwgAt4T;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF86606A324
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:53:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFF86606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bZwgAt4T
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so1193860a91.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 02:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795085599; x=1795690399; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hqE0DnzQVOaqly9+hSqhRUU82CqCbvfu1P534JABEUc=;
        b=bZwgAt4TKqTsP1xWCq97VLu+tnoq+LiOuNQD/HqwsLAazfa4JIr0ZvR8So4m6B/gc8
         pyCh66xfyXhzvlqFYjormqzWR+xuCQVe5MHETbIk2+IAknavrZFAb2HuDzIV9YY4uD5E
         eXCmuqHHuQpKGj2dAUDbsHhu4JTv3sobzZRQx7SvCJ6c78zIEKZqkmT8TurIob+jPDQO
         l+Y2Byvtvx3HnX8UX9g2bVr18Tf/VnViCYbE/yj4usckpA3RAVus5ErQNhSmiI0lTFzF
         M/tA9ZH8Y2QwAcbDD8ncuGc3O2eCmFLrk6xcrK7An2VBmdR9dQSCi0QC0DsILEWkhtUh
         cFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795085599; x=1795690399;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqE0DnzQVOaqly9+hSqhRUU82CqCbvfu1P534JABEUc=;
        b=IiQ9UfS+uIFlow0oYvxkkaXpHbzqy0udA5luKFsTAL/dNsy5nn2kbD7J6WrI/mvYsV
         xCHJh0hhhZeEXtFBxPz+IWq8frtC58MjZxMmXLqnleHCcw4xSxqXRiGfiBPp163ic8Vs
         Q9GBJbdx6UziOqM7e7UURPPLqR7/2QP9PtSwC90v35UlNpDsxiUPbEBC9829qt2YkSog
         cKoU3mWeTqtCh2nB5wSXY3p9ZYP2bXiFMqE34M6K6RphEqX1FVgntpv3pSyYDd+aE+XM
         C9MaayMrvLbTNrunTBFgRVGdgbQvoEBUBfpj42ExMX+carChGmaRKrmXPov6IuHAX3m4
         9LVQ==
X-Forwarded-Encrypted: i=1; AL+hErHvB+i3lqQovf1XlnhIIT/qycAc6Hdnj2kPc8SCtqH3Uh53K08iNumNUl9D4LxQYmNVyl1EQub4txTf@vger.kernel.org
X-Gm-Message-State: APuU4Z+CLghuHrNIIWxIZTYeW6cSSKVS1zOHU+2FP9UDiTmzeXOE3djL
	Tgo9hwwbRKXaZg0R+o88nfZX46TcbTjEoYoyWr5GQYQEapqQWQ1FlE3Oyu5aUWnqTtE=
X-Gm-Gg: AZFdTZfELU65/SDKMf6RkQb/XretgB82oXzSpxY5ruPQC9tWylRy9wg5xIGNYZwl3eI
	G9BEFB6thXH4aA6tOuClPJyIdW/Ic5Iq5Kop+Y4FvjIYwmRlQzG7KdaZqvlrSIbGTDLnClOF/KJ
	16cckLOGlsWaDWUuTghahX5ozNMXo5Q6Lm/VodG154v3KCjdqJPLrxwWP59deuX41SUJjif3ybP
	6BAiiuPwtjjA51CLWDaoPYETLMxrqgR09zpok/yhr/RFchCs9vrvtagnC/AOawL7ZgEok42Y7g4
	t3vh4yDL31AczJuUlSHFTRLuav+KtIioAQuLWwjCA6qydO2M18sRWKS/fw7mPN4flWlEuC0vGRk
	Xko3tH996AFI9kBTbuZpojla8R1Cg0aqZBQbt84FXJ7RTcOsLXzsu6wzOOpBmWsPpvaOZv1OJZG
	7vPlYYmcVf9G5z7dnBgnRR024yYrTv87wuqT7qaOJkHPpptx+Y1pHOEbQQ3NnAnRalSU9p7Zwx9
	hkQJNiRYyvwv9D5RTFw1v9U8Wdc0ukJl3LgwA6qrTk3TTJZK6HSQflPRPmf74m1DeDp8+hT5LhX
	zSXOOiD914+gLVXuncie8Dw3Rdv4BEs7IO3C5SIza/6es4xBX+ctGpnFPeG/twg2SAFax/dqicm
	boUHcLk9QmoZwEVwFzGvXwXgqzHP5Dbsq6+am6w==
X-Received: by 2002:a17:90b:3d8f:b0:3ac:8897:7baa with SMTP id 98e67ed59e1d1-3b3d07c687emr4819843a91.40.1795085598784;
        Thu, 19 Nov 2026 02:53:18 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d639fdsm2246604a91.10.2026.11.19.02.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 02:53:18 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v7 3/3] net/smc: carry oversized SMC-Rv2 LLC messages in the queue entry
Date: Thu, 19 Nov 2026 19:53:07 +0900
Message-ID: <20261119105308.2567241-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820023346.BF2B71F00A3A@smtp.kernel.org>
References: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr> <20260819023306.644849-4-yhlee@isslab.korea.ac.kr> <20260820023346.BF2B71F00A3A@smtp.kernel.org>
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

The byte order point is right, and it is not something this series
changed.  num_rkeys in struct smc_llc_msg_add_link_v2_ext is a plain u16:
smc_llc_fill_ext_v2() stores lgr->conns_num into it and
smc_llc_save_add_link_rkeys() reads it back, both in host order, while
the rt[] entries next to it are __be32 and __be64.  Between a big-endian
and a little-endian host a count N below 256 arrives as N * 256, and
min_t(u8, ...) turns that into 0, so no rkeys are saved for the new link.

I have not sent a fix because the right one depends on what the SMC-Rv2
format defines.  If the field is big-endian on the wire, htons() and
ntohs() leave s390 as it is but change the bytes an x86 host sends, so a
patched x86 host and an unpatched one would stop agreeing.  Could one of
you confirm the wire format, and whether that compatibility cost is
acceptable?  I can send the patch for net-next once that is settled.

Best regards,
Yehyeong Lee
