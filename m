Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794701934;
	b=ywVVLwlkBNEX11sz/BN+ewi2AfwItAuvt5pxYKyHF+U8EizVnip466t3bebbzE9XBw4j
	 Uwi5+cLGtKefwoY0odV3JtMqrTDK1HfsEZc/3doQ1T7DkC1UG60xPqW52TL8zxlMZHYfn
	 n7DnK976n79j9/zjxNC5AbY6bj8aWrl7FQsPfdnHjco4QUXYYjVCAl9NLu/XV67S3VQMV
	 UWHdLiLxQTKJHTel06u1RV+RktyncPuiWLxxznDIuOayWtoe0PeFSseQKEaDSqmzG7tsD
	 3J8cgUQIpF9SyZYKBqx3Umhw6Hcn7AuK66OY92j/tQZJSq1hpvQOke/P13g+rmUjJcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794701934;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JejavGOhT29+kYZxPl7g8FlCzMWntZ9rMxIL0KrRCgg=;
	b=VBdS+fUgAOdiO+M8kyhE6Gt08qQaTzcgM3n3YH4Y/8Gxj5NlcicN5tzbPHq+VF/JJbR5
	 BZjMz4ZQs2iVt7m+KBxsDJ39MYzE8JEM2rdmW1Te6F3sQ04VqZVzezu2nVHGDQ3OjcHAP
	 7BpSQDlvjaBVYrn8exLtKqypFJch7bsr1HutC5FSGcdaWRensxrrTPObrZu3Qy89gQyVh
	 4GZ2lchKtRhTvJcwvwn8NqfL0FwNgjAcfv6EPXjb8rQsEJcy5DzuRx+atnqF0ox7F8jFJ
	 /iF3KGsq96sgzPoTS5XBdZUsVZws8/Xz7zusAQM1N2gyPYJiNaK2HQ/SWKca4Od7Llg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CLZiqkUi;
	arc=none smtp.remote-ip=209.85.222.180
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1F4606A32D
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 00:18:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA1F4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CLZiqkUi
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-943e8d35f74so287664085a.0
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 16:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794701933; x=1795306733; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JejavGOhT29+kYZxPl7g8FlCzMWntZ9rMxIL0KrRCgg=;
        b=CLZiqkUiy/GqoMK+wOyDEYP2H1dJ227AZJ9Z8XC3+j1I4tBq57Tz++CXSvWNkYlb1I
         VH2/IrtUDdGMYYvSoMK49waU3rQ192zmkKPi5Wg9y4HR5rwHpUHO1D5pTrHi/mjEW9ct
         GjKEr6kPgjPz7Ih1wSoqksm3BM/X1CgQs/Nd7pC9tQm3Eg//Y544Zu37OsmxUkHS3zwG
         v6YsLfw9Z91eCnVaMbOCLeTv8KXuhpzuciXLUppvC8Iecs9A3aeapVStAQ1VxeYMJ7qc
         l1ArYTSfSCx9dF6vfeVBrF9tsGfoKDta0ay7l7p2DzlbvCgV7rpqxyL6obw1+5WQeRbb
         OTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794701933; x=1795306733;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JejavGOhT29+kYZxPl7g8FlCzMWntZ9rMxIL0KrRCgg=;
        b=wfrIfyu1cbJitMPiasJNzTdicgxHaO2OcfF+PevLUAGKuxHabIc3HaD5vKZONtVijh
         ten7rSG8Z+Ey2FLJWn3GviNyrkN7vL5X+bWb0TvqYuTEYBwnnNl/AYehjO4EAqTERu+/
         EmiekcPyh8tzzUKlQzbqc02xk5bIgCWP8eG7CgmHdC6aK9AOWYUfzkBhL+tONw1oDyKK
         jBeHbSe/Q8POLlX4+1To8x8MnICgANUm+Cq9c4mxpsPEIaC3ZMp/ymH5mhbp+gjEomlR
         MlJxv6JUQX2HSepm+G8OCwfPMHogi2XP2d+435/uMQVTG6I+c1kHoli8PdDM5yAXtqFD
         UBwg==
X-Forwarded-Encrypted: i=1; AL+hErF/5gru8E8+TyFvamyQhr8Vbe25gvJGMLlod4Df45+J1dKb2qBT+x7khscaA1xxdHQEyGL6adF9z3s9@vger.kernel.org
X-Gm-Message-State: APuU4Z8AXFkxQK/FrQVZTHJo5/dy52VngYdUUbfi8++PDQdTxg8e2dUn
	KKfgjizfkGstRY0mdHDFMaDGgAqHTgvV4k8p3UIU9VKTQmsI7ZJFG7SzyeJDEBNIuis=
X-Gm-Gg: AYBFou2rGi4GV36JGuLtso/BO6qm9BM/ZvIxiDyKKEBt5Ti6DWDjB9Q6kIiqP1SR2ci
	Y4uzmhSJLlp2KvHYipLINoCebPV1i75l4zI35Ei3319Fw0yig5TgKs5rFFA9Zr9LlEEfhRmv7dt
	+Tv5q/C/tMyu0dRxIQaM9erfQ72rFmcjkvJG9cajujMzIV/H5S04xCS+ETCMD7v5YHqDL8eBKrT
	I0YsbKhd+0TBYHicez/4c5cM5fOdpUJGJhtkKjMVNsRQ60fU/MjLgRomfNrRnwsav4ost+7hr0R
	OyV1ZUrCmNtmlA27wsamm/hUoo86iQgUd0aFGOyzYEr1+PUZ7194dVCR5ot7/JzmCkeCFtbwNb9
	mSpp/SEA9X0AftI9+K6YH3R+obrZdk4svNRx8vTRbKDZjVIlTl1TDfCoDBCN5WvfD11wL+IMYdP
	/P19bdFmYdCRE/1TLwJpaZBiAC6Sqbq+OCsLLfr2i4g4wmEeZALnWe7d41dtC89ubwk1dtEyeeq
	UWHi4IZ48zd1QETQZCZOvCP6ljiSIcahU86jBgTVThWb35rTR+HQFDONKbJeKsXzgYDVOD7MsQn
	X/xOjw==
X-Received: by 2002:a05:620a:2b96:b0:93e:5fbf:a41c with SMTP id af79cd13be357-9494bbb7e8dmr1069300885a.16.1794701932860;
        Sat, 14 Nov 2026 16:18:52 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8f92bbsm512903785a.40.2026.11.14.16.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:18:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSNxL-00000005ESx-1JsN;
	Sat, 14 Nov 2026 20:18:51 -0400
Date: Sat, 14 Nov 2026 20:18:51 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Aibing Chen <chenaibing@cmss.chinamobile.com>
Cc: leon@kernel.org, achender@kernel.org, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, hdanton@sina.com,
	hackerowskiy@gmail.com,
	syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/cma: add rdma_destroy_id_wq() and use it from RDS
Message-ID: <20261115001851.GH2532299@ziepe.ca>
References: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>

On Sat, Nov 14, 2026 at 11:05:41PM +0800, Aibing Chen wrote:
> syzbot reported a possible circular locking dependency between
> rds_trans_sem and the RDMA CM handler mutex:
> 
>   CPU0 (bind path)                    CPU1 (CM callback path)
>   ----                                ----
>   down_read(&rds_trans_sem)           mutex_lock(&handler_mutex)
>   rds_ib_laddr_check()                cma_ib_req_handler()
>     rdma_destroy_id()                   rds_ib_cm_handle_connect()
>       mutex_lock(&handler_mutex)          rds_conn_create()
>                                             rds_trans_get_preferred()
>                                               down_read(&rds_trans_sem)
> 
> rds_ib_laddr_check_cm() destroys the CM id from inside
> rds_trans_get_preferred()'s read-side critical section, while CM
> callbacks create RDS connections (taking the same read lock) from
> under handler_mutex.
> 
> Break the cycle by destroying the CM id asynchronously: add
> rdma_destroy_id_wq(), which queues the destruction on cma_wq, and
> switch rds_ib_laddr_check_cm() to it.  The destroy work is embedded
> in struct rdma_id_private, which keeps the id alive until the work
> runs; rds does not touch cm_id after the destroy call.

This doesn't seem like it should be the core codes problem? Why can't
rds do the workqueue?

Jason
