Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008653;
	b=na3h4Cm3ci9yYFPuS9+zRnqixqvpt0Ha+hWI+dcyRghZH0k5igL9biNSYGLC5nDXybQO
	 aljatNKXG7OTICgVG3VxYYuheLbVw5H6m7qTz+KPVbyDMFf6t+Dpk1YPvnhv4X9isa/bo
	 9WL6l6o6Fx0kEAKVrWBnSpqihD2wGvO1Nb1E3O8mRovVcVunE89RGN+pa+9EODLtG1aan
	 wN8ToEEi8VGBb7kL5kBcebzu4lANpvcfXVyFQnzBWEwp2jhbuX1wQvNtavs9i0D5LGwi9
	 yU+e8UI79lYVfY0LccEvJDeZlxt2vu5n5QRe8npdUPFRD+ZLESKSfLb8Zl1BGvm5yUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008653;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 To:Cc:Subject:Message-ID:Date:In-Reply-To:References:From;
	bh=fnwqLbC7jM7fNZjmHLWNEoPNB0R2v/+U/waAYsuTLjY=;
	b=DBm7KUeVvJ0aCARY8sC8OM7hTroJBhR0ARGaKmK6RRNLh8aJxzXM3s2B9CJKekN+gYPY
	 jVVlNQXGbvZztHx0KCTsxXE/4EdUByOVby8juD19iEwT89ZCQug6s/kIHwybvJ5S7aV8k
	 j8SSNj2o6HtebA6zCxBTsXNCQRzbQPK8agBcn5UsXoY0LLVJpzi29LtFMm4+Ui1WmtG6Y
	 gcMLKDqBZlZmpYQqm6MWlu04QCkxS91uJNj7uDo5eXn9VJZSLb+Ee8b5gqUg80GQGr2Zm
	 iRcFIFfgLDqe4lzxydC5Z4zo+zMrTArr3EeRYJFG8duYje68Rm6ds32IbLwB7bMtlPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CszcIJS6;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C1606A329
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E85C1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CszcIJS6
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91ba702cceaso33352506d6.0
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793008652; x=1793613452; darn=vger.kernel.org;
        h=from:references:in-reply-to:date:message-id:subject:cc:to:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fnwqLbC7jM7fNZjmHLWNEoPNB0R2v/+U/waAYsuTLjY=;
        b=CszcIJS6O/KCIK7WpNqpAHpNanBJp3TkxSHpIi9YbipF74abmLbVLhX19ynNXPMj6s
         HxwW/Z1upLc7BYWvrCylBRiimZv6NZgY1Margqt8YpDneBtLvn8Wu7po8KNvu4YZcKff
         rwBhca18w5jSnXvExmvQwdktwOPKfXy2vyESPG2WVEBFHXsn0SRmm4lGJw9TwqZep2OB
         oWEHUmMcQqDnzSRYt4QuhpOVlFKimzZBB4w9EkHhmsQgR1YLtrK8ASqSPqNhESYXEVey
         qulzTVpoex6Qapis4TsWXSldi5f3pzfOfHaNRKh3yxqKyCTOU+o2vJMoWnUdUamgegGA
         P7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793008652; x=1793613452;
        h=from:references:in-reply-to:date:message-id:subject:cc:to:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fnwqLbC7jM7fNZjmHLWNEoPNB0R2v/+U/waAYsuTLjY=;
        b=MzqLkJgcm/hFRxzf1aoBtAT+NRmm4zxnYevr0v5eX+CvGXGN9KAwIw3ZxP9FpGl5ec
         FDe8K1AJzebQ8Xyvf1PDWFuqqb/BWPx9Wd+ABNmDTGjhsyDrhf5bn8r4+ooBksAXIjOm
         sVe/uTdG7rXHn81ZjNWS7gLZKUBYtn3+pm14r3tNcz7kGJx3LE7cz3wPRMSToShDZkMP
         SPDhFwR/niBCURnWNY+xb56zYHzzoirW83RtHrSFvkP+Is8TIprcejSFFAtng1LFVzbC
         pTmSzMCq78yEw5OGTVjnTmfHfmcAcBP58vIY/5JRAV/sZbc1QdiG0ZQ3ZkapI201ypwE
         x9dA==
X-Forwarded-Encrypted: i=1; AKwUvBw6xdipUWwM6jncuSrbmN/VLjGkdGzDU/CSygVbTXqWd8iVPAJDF2M7TPDQRewEvVemXkG3zDZ93RmR@vger.kernel.org
X-Gm-Message-State: AFq9FYKv2hl0zbDnPhzQAS1q6Ea7eS7+5OQs/c/ZK+YWgf/KGn9VKUDV
	8+Dz99go5CGBS0yZpe3iSmT+onWyUIIW9Su2+rhDhZWLIS0xEDPwy1ep
X-Gm-Gg: AYBFou1lznDFdqu9OWXfrVWu5UUv314VuovOPDJ+S+tj8GR2DxwLPl/936E9ww3dSbp
	sOtzToaGSJhRc5ekaGhMRPVOYiN0/hKK49FIcCpLb0DcfuXJKhRRGmSjkTgbQLOMo4UfjfiflMC
	Tz8eaDMdEiAVMEkKkSSL0dDrz9/6rLjws03f7dJP8hdis75IiBIPYd6bCzJb/hVVI+/kgilh3GU
	86kRgo9jRYS955847o73atHgu8TWmnsDvlB/e3swAUxafNcT2xfh5jz1hr7jAW3ny1jwwKUe8/b
	QwsFLHSh+TTXVAce9TUroh0S5gNRHwCVmHkA0OMIw0omUQv1tg+iSDEwQuDHplqSwrmyYdnTNAG
	ST1DnXoHkdjeppUi7LvfIgn3vUrpRkmQpw1FULhROy5QHIm5rN7isiqNJD8Ni+cX2HrSyMiyZ6J
	1OlZk/fMe/n3zA4fopAYuZQPk1T8IwyO+eNDRgP6DEx53zECuaDpTY+IN2LdaTnylEQEuEWzAVi
	XHymRMq+wFQT6niZtEQvPVKOxoc1hroF/5bFeeyfSItiET3gsLFKnbzaBCGnLDnamGpcm4r4TOa
	njLPCitRBMglL9Jz2JQI3+GdwzJQFZUdhj4odw==
X-Received: by 2002:a05:6214:48e:b0:914:459d:d3c5 with SMTP id 6a1803df08f44-91c48e37d47mr113810816d6.38.1793008651916;
        Mon, 26 Oct 2026 02:57:31 -0700 (PDT)
Received: from localhost ([217.150.74.224])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c54cbdsm67853376d6.26.2026.10.26.02.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:57:31 -0700 (PDT)
To: Hillf Danton <hdanton@sina.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com, rds-devel@oss.oracle.com
Subject: Re: [syzbot] [rdma?] possible deadlock in rds_trans_get_preferred
Message-ID: <179300864774.19661.11942156119304654192@gmail.com>
Date: Mon, 26 Oct 2026 09:57:27 +0000
In-Reply-To: <20261019015139.806-1-hdanton@sina.com>
References: <6ad51a9c.a6d1a155.34a93f.00bb.GAE@google.com> <20261019015139.806-1-hdanton@sina.com>
From: Eduard Zateev <hackerowskiy@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Hi Hillf,

I tested your asynchronous CMA ID destruction patch from the #syz test
reply on the current upstream checkout at 21a7f44fd076 (Linux 7.3.0).

The kernel was built with KASAN, lockdep, RDMA_RXE and RDS enabled. I ran
the syzbot C reproducer in QEMU with four vCPUs. On the unpatched kernel it
reproduced the reported circular locking dependency between rds_trans_sem
and the RDMA CMA handler_mutex. With your patch applied, the same
reproducer completed successfully, established both active and passive RDS
connections, and produced no possible circular locking, possible recursive
locking, WARNING, Oops, or BUG output.

The build completed successfully and checkpatch.pl --strict reported no
errors or warnings. The complete test logs and the applied diff are
available on request.

Tested-by: Eduard Zateev <hackerowskiy@gmail.com>
