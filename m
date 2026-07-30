Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7001C31F990
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 10:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405728; cv=none; b=CKjqBaj23cKAgQEgfw3gYZszyqIlh59WKfaGaWvCorot3HPeYUCnzWyOhITZBq45iP3w5Z1oYtsulvUlzZB2YkcTHr6ufDISa7/PA3x7COsHiwSJ65fXZ2eb63uvWx9rIAWzT+oNUtZNQY46dqB6G44eX9O1EPFw+6G/J6W2bfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405728; c=relaxed/simple;
	bh=hrSLrX7YC7PkUUv3YBWcTkVq+DlhAeV468G35ct75MA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rnKa3dcuZTInafdFfUFfbTdHBfkCbP8o+EwIfgPRtN/EIphVJmOZA7toEB14wJiRLQMbLHddnu579yGMcApKvblJVqkgC8Ci4TPIvKmE/TFlSJmPkgTf3wi9brKVVETul6cr5ve8fMcoHongz41kOBKDHcepOr5NDF/Zv0k5PEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QjUqpae1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a4JwCMGv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjUqpae1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4JwCMGv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785405724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiyZuiTForSAZqWqo/gtIBy3q8EpOKn9So3zlplj93M=;
	b=QjUqpae1DR3Hgi8v1mYMoq4hu7V7lVOFesxn39PbwfJ8qU9F5eXWZ8QZoHVE9mf7YnqNas
	H7Nl9ETfcrvRN6Pp9RnSmUIgrE6hpyX9UYR9VNXNMAebbDjIltcLbSMg7w6gGEhJSB/XOG
	qa0MD8mwyiZ5kfC0Q1fpmYXBeE+Yp9k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-ZonX23QZNf2y16Bykp60fw-1; Thu, 30 Jul 2026 06:02:03 -0400
X-MC-Unique: ZonX23QZNf2y16Bykp60fw-1
X-Mimecast-MFC-AGG-ID: ZonX23QZNf2y16Bykp60fw_1785405722
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-496b4cc049fso5596615e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 03:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785405722; x=1786010522; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QiyZuiTForSAZqWqo/gtIBy3q8EpOKn9So3zlplj93M=;
        b=a4JwCMGvNSjD/hn9r2XYm/5+xNrt+36ZxIPWoZ0Sa3+7l1WHe6bZC3jbXdDT362GM2
         y3hS1A8sNHxCTKUttT3G+tbrQDWwwVLppX7fuc4PfkAwFd3iD2QbiKTcwS8LOEb0GDik
         C/sGny90diEuDAEJ3r0mLawrmIqaAwewXRzg8ecSCc5Rxl0TMfQeR9ep4/iJg4Tq1cdr
         rYID+wPM/Cf7Vn028ylGsMWAJNh+Yv0LC6M+Q6mTiKMRa81w++3/0EpeBepPCJO/uDNw
         mkxXcFVDXbFu3OWyqlL2dt96ikEdS2iHkI15kV56hxa3dukuT8hFycsfJpfFtmlPm7uY
         DZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785405722; x=1786010522;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QiyZuiTForSAZqWqo/gtIBy3q8EpOKn9So3zlplj93M=;
        b=DKmcapJEL5lwYIgAcNztLSVy7VbnJioSXhZE8J5SEnnHupAUC1vfkRcYlISidZM4x7
         V/NekjQojwWSsCYSOUhypVjzFxbFBlI0qLvw6gEOzkzI9XUgbEno7UTJyEOBabaYIlxM
         y5veI6UzhRzEhA4zBn8heIMEKRlZjpqK6WxZUJmEDUeVr0jxYSa9TDlwSXwgrK+VBUbk
         wKMj1P5hnZocYPzX6nLFT3+L5I4Sj1J3Tz1HBpJ4+yde/DcT3sHvKkmBGhTGtMXXtCGB
         suQEw9xRLu64/8EnU1acOiDFxKgDNAyc6pPbDDODgKcTTW0nyna50+MPiwXeavFyCb3w
         Gfrg==
X-Forwarded-Encrypted: i=1; AHgh+RojSQaOlcTw/6no82c30fOX1cvqZ3fcdPFq0dM3PJZbTjmZREocqJzdT0y9VgLJpGoo8s5hJS7wTG6x@vger.kernel.org
X-Gm-Message-State: AOJu0YzsfEw+nHb7J0eV8hvUWhOpc4nboGBCIeM9xAl020IHHdeeNMy+
	IWzy3QkUmzk1gQChZM7f4fXwZdkurUBTwPuH3xMY65HhMjPc34ZECu7Qe/3/TxI46/ggZQeZSlQ
	L5WnqqtG92Swq5py9HcCH/DwY9BRJSRPljz+rWdFJ73n9vUbkAZTXzwyAr50nNY7iwzrpSec=
X-Gm-Gg: AR+sD104cxdBKbSTnc/xWvMNizWBdqu680YYuxi4k+ly2EzJfdBBCQohVY9BJqoTHm6
	0LiFROgqBroNnG2iTl26Ve5lfIU/vUP5Ju9j5/JbIFH4mjaMEXdh+64wGAdShpU/PFhQQnqrRAe
	6LEMWQWtZOQ/1/+bhexhoavdK7xcoDod4eRFR6btkQs1oe9p6cHOrLxGOB3F19U0xziSr6hDxml
	66vQLBES2dml32G5BUZnKPgEdvWHjgM0PjkIdLj0AetCkbFqL9dDjHv4WtjBp/NSTV81TJl7y0V
	9PAhS1EHLJVzB3M5PrVaMGAe32IHtUtFw9hoVH4ZDPqyBM5k4cH+8my3odgsFkVhm9kNCRwLZn6
	HQwrq1DIIxJktn4VQVSC/dgBTj6uShc9oV8qitKQv7xEfRMNfhzkGVgpORdORZKlZGepSog4hEA
	RHFQ==
X-Received: by 2002:a05:600c:5487:b0:496:bc89:f0f1 with SMTP id 5b1f17b1804b1-49801f1eafamr18738305e9.14.1785405721461;
        Thu, 30 Jul 2026 03:02:01 -0700 (PDT)
X-Received: by 2002:a05:600c:5487:b0:496:bc89:f0f1 with SMTP id 5b1f17b1804b1-49801f1eafamr18737955e9.14.1785405720951;
        Thu, 30 Jul 2026 03:02:00 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-498011e5edesm46969165e9.2.2026.07.30.03.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 03:02:00 -0700 (PDT)
Message-ID: <26c1ea30-e6cb-4f3f-ab88-6d00f0ed2117@redhat.com>
Date: Thu, 30 Jul 2026 12:01:58 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] rds: synchronize info callbacks with module
 unload
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
 Allison Henderson <achender@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Santosh Shilimkar <santosh.shilimkar@oracle.com>,
 Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Dan Carpenter <error27@gmail.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
 <20260727174826.135662-1-nicoyip.dev@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260727174826.135662-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

It looks like I was too optimistic in my previous reply.

On 7/27/26 7:48 PM, Chengfeng Ye wrote:
> @@ -78,8 +80,13 @@ void rds_info_register_func(int optname, rds_info_func func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
>  
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset]);
> -	rds_info_funcs[offset] = func;
> +	/* Validate the latest published slot value. */
> +	if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]))) {

This read is under the same lock that perform the store. It's totally
unclear why smp_load_acquire() would be needed here. Very reasonably
it's not.

> +		spin_unlock(&rds_info_lock);
> +		return;
> +	}
> +	/* Pair with lockless callback lookup. */
> +	smp_store_release(&rds_info_funcs[offset], func);
>  	spin_unlock(&rds_info_lock);
>  }
>  EXPORT_SYMBOL_GPL(rds_info_register_func);
> @@ -91,9 +98,15 @@ void rds_info_deregister_func(int optname, rds_info_func func)
>  	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
>  
>  	spin_lock(&rds_info_lock);
> -	BUG_ON(rds_info_funcs[offset] != func);
> -	rds_info_funcs[offset] = NULL;
> +	/* Validate the latest published slot value. */
> +	if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]) != func)) {

Same here.

/P

