Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792666484;
	b=qGDjaQlRm1MqLM6XGOHE4uJJsEviXodf76HluRMwzN4iDwXj6Puw0eWChtZ/QMCFF/1N
	 AXnoTuxJRsrp7XCop677ZHPRFXFp/eddY1YtfnnLKm8YVFnXGVC4527EQyRGshVFvqvmw
	 IOiD6yqxX0iT+r9Df+564qCOJG+AwV3KT7ezxsXA4GoWYqixQeq7ROF402OfvzgNH7Kdd
	 ENlyo7LL1oZ16w4m3oXtQ7XwzpAUumdJFb6j87Synsf9mgX2AO82yQ7IsCT4hjf8uyuNf
	 XVvjMKZ8gyxYoaiCs00mlE3V6e/B807up/LBj/bRlesjKsbHCNjdvRq6btBDAzlw5SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792666484;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 Content-Language:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=m02LnQqAx90iQHNTDHgW+TeOE5dUtsPN+2XnmmAiXdA=;
	b=AiiNw6gpNujnN9zR29sM8+BG5Jp48GmeYC/LKPMq7a5aU3C9Ojef808rhibKuhrek5QX
	 Fj+e5qVG8+KEHeaXLNwil/v57gYUM3/rLuwTb21l/CTT+tyG/f5T32kq+i5UI4ZzhAhiY
	 LMKuhXngyhH9P0YOEY0Wzecby8WaAnebQGu3ieO7EsAff95xCyszMbHwS5jQKWZh1xuuo
	 d+aO7RrRYlEOWjfsxzUiHiG85Qwmp2tIbsfEwMNal+lNBr6nTv2hH4QcfWdpE5cuG8zQI
	 uHDeO+uVfcFoGqGDORJNdIFkue4I22+HsH5fBMT7p5QmlLgcSlaQbbs9Q+1RWBzpbRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fDCXQKuV;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Y9wiS6va;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA60E60A260E
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 10:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA60E60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fDCXQKuV;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Y9wiS6va
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792666483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m02LnQqAx90iQHNTDHgW+TeOE5dUtsPN+2XnmmAiXdA=;
	b=fDCXQKuVYLhh8LDwZkwnc777nM4dmZetyWnBaUrAKPt7SB1awHmswgObQjd5SDcn6Iq4EM
	TqfyvfUZhSIPlvaMVrkYewUL8kIFL9Yj8k9hUwAtMPY3NnkcNnIyxpJIsBrBuB0vAp4b53
	+xpOHYgNZu7GyA+2EkGmJR+rjvRrYCw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-raWsq1gxO--bPLqbdqBmiQ-1; Thu, 22 Oct 2026 06:54:41 -0400
X-MC-Unique: raWsq1gxO--bPLqbdqBmiQ-1
X-Mimecast-MFC-AGG-ID: raWsq1gxO--bPLqbdqBmiQ_1792666479
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a208f409ceso2721535e9.3
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 03:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792666479; x=1793271279; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m02LnQqAx90iQHNTDHgW+TeOE5dUtsPN+2XnmmAiXdA=;
        b=Y9wiS6vaFVrz3SOJ3vWMnVepwefZPmmzv5KVC6o63au9Sd3K/FYAeGDPQDdbBUT9m0
         jj05j8d0qE+ClJ/rcmCtHLR3ArC1Vz18I6kKMWW43tAqocpoT6wGfd2ekdf5HVhgnqiV
         OCk5tqL8FNUSdDYZxTeMg1wMq3mjEiKwUkTFTjINkcJuhaovO5DtDtf54LRKSc0EQlPA
         HkSrQlINBD1xc5kS44zKEKAIeCGFKm3WYH5xawoH1C0on+wAqG92a3QrONm6aKx3Dq85
         uEYCBu0Wx1TfKWeNpMIQDyrHVxGqdACTvn5tol5e4pILgTyOy2rCv8rmtLloH95mVMTn
         B2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792666479; x=1793271279;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m02LnQqAx90iQHNTDHgW+TeOE5dUtsPN+2XnmmAiXdA=;
        b=wac7ZOdE3V7YQjLPwxDTcTui91Vv2qfUQyv0wibDWD/OdT5NFNqzHOH5ZS/tdDIoP4
         4qcZezqaE1Jcm+GEFpVujxNZtWSb4bRQoumG9v02eCC+lbNgHcnHwEa5B3UZz+ZOzwtv
         oLC8r7L2zVmiATx3R9xvXq64sR6zM0XeJJHuuBIbyj2MaLwCiAxFoeR674IJy+YKEla4
         se07qHAsw960NuQBCU4ARpNU9VZ09H8cPL48BNscN4z6wvsJ6xw32JBQa9yL5OgVXA52
         hkNeTyxh8k4GovoT/84UYv7hR1M6HbKRincp8Aj+q0ORsmM7HdVdLfNomHfqcN79NUMT
         JF2Q==
X-Forwarded-Encrypted: i=1; AKwUvByaro9KxdwtH2uwtAe4APO3C02F3TV3n9LvyQmmUmRkUeFvGlDIOxmAyzJbVdqYgaNEXJNRfbEl3SYy@vger.kernel.org
X-Gm-Message-State: AFq9FYIGdOOGyHGTmKENF6yiMHMCGBDNLqXKUD4mJM5OewUV3B29+CZv
	HyN3PjRYEE/wJY+TVj2jEghqf2iEk0egqBKGASSIcxTCHHiLaQItxdzMzu8VT5mZqXcdapLMFaH
	eULF9/8g+0cXRDalFVGaobQKbGa/yfrtsTRpmBMRKFKeYapHzu1yC2p6pqyWUC/g=
X-Gm-Gg: AYBFou0AN9jD7xgI12EKctsFVYp6axOjlpPXZDuCqB5QUTg+tWW9oLUb+4uZmMh3E7m
	O3kMvuntSnwtM8QNDW75/Mf10c29PhznrPZShBg2G0tlWCOPSp22V+dKyi1SWj6Y7MKjJOiRigU
	CZeLD1ltPJW6TwwItd2Yd5iafksiARyKBJGlj3PSwFqhvGBKl1hiVTMAnHJUUe/gfKRt5VIVwOQ
	TtrDd5Q0bIu4Nl1/sor3XuoCC6V/b0GdoYg0vHCLlyIygvgHFkcBRahFGh1OiqrRGrclOp2Pe2b
	uOLR/mgHxroY9MpJ+6PCJf7UkmtHu4LMj0t3slBs1Z5iuNUeevP7S9LRyOrm5hJSQBDNO5zIUQ=
	=
X-Received: by 2002:a05:600c:c4a1:b0:4a1:f0bc:90b with SMTP id 5b1f17b1804b1-4a1fdd3d407mr99476315e9.29.1792666479374;
        Thu, 22 Oct 2026 03:54:39 -0700 (PDT)
X-Received: by 2002:a05:600c:c4a1:b0:4a1:f0bc:90b with SMTP id 5b1f17b1804b1-4a1fdd3d407mr99475815e9.29.1792666478965;
        Thu, 22 Oct 2026 03:54:38 -0700 (PDT)
Received: from [192.168.2.75] ([46.175.183.46])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm12856807f8f.3.2026.10.22.03.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 03:54:38 -0700 (PDT)
Message-ID: <8b9bc610-777b-4436-98a6-2428153cc5f2@redhat.com>
Date: Thu, 22 Oct 2026 12:54:36 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iwl-net 3/3] ice: do not block on the aux device lock in
 ndo_setup_tc
Content-Language: en-US
To: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
 "Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Ertman, David M" <david.m.ertman@intel.com>,
 Shiraz Saleem <shiraz.saleem@intel.com>, Leon Romanovsky <leon@kernel.org>,
 "Maziarz, Kamil" <kamil.maziarz@intel.com>,
 Rafal Rogalski <rafalx.rogalski@intel.com>,
 "Schmidt, Michal" <mschmidt@redhat.com>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Mateusz Palczewski <mateusz.palczewski@intel.com>,
 "linux-rt-devel@lists.linux.dev" <linux-rt-devel@lists.linux.dev>
References: <20261019065301.3983537-1-poros@redhat.com>
 <20261019065301.3983537-4-poros@redhat.com>
 <CH3PR11MB566895E0410B0694F734EA7DAFE5662@CH3PR11MB566895.namprd11.prod.outlook.com>
From: Petr Oros <poros@redhat.com>
In-Reply-To: <CH3PR11MB566895E0410B0694F734EA7DAFE5662@CH3PR11MB566895.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/26 1:22 PM, Loktionov, Aleksandr wrote:
> 
> 
>> -----Original Message-----
>> From: Petr Oros <poros@redhat.com>
>> Sent: Monday, October 19, 2026 8:53 AM
>> To: netdev@vger.kernel.org
>> Cc: Oros, Petr <poros@redhat.com>; Nguyen, Anthony L
>> <anthony.l.nguyen@intel.com>; Kitszel, Przemyslaw
>> <przemyslaw.kitszel@intel.com>; Andrew Lunn <andrew+netdev@lunn.ch>;
>> David S . Miller <davem@davemloft.net>; Eric Dumazet
>> <edumazet@kernel.org>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>; Ertman, David M <david.m.ertman@intel.com>; Shiraz
>> Saleem <shiraz.saleem@intel.com>; Leon Romanovsky <leon@kernel.org>;
>> Maziarz, Kamil <kamil.maziarz@intel.com>; Rafal Rogalski
>> <rafalx.rogalski@intel.com>; Loktionov, Aleksandr
>> <aleksandr.loktionov@intel.com>; Schmidt, Michal <mschmidt@redhat.com>;
>> linux-rdma@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-
>> kernel@vger.kernel.org; stable@vger.kernel.org; Sebastian Andrzej
>> Siewior <bigeasy@linutronix.de>; Clark Williams <clrkwllms@kernel.org>;
>> Steven Rostedt <rostedt@goodmis.org>; Mateusz Palczewski
>> <mateusz.palczewski@intel.com>; linux-rt-devel@lists.linux.dev
>> Subject: [PATCH iwl-net 3/3] ice: do not block on the aux device lock in
>> ndo_setup_tc
>>
>> The TC_SETUP_QDISC_MQPRIO path of ice_setup_tc() takes the auxiliary
>> device lock to test whether the RDMA driver is bound, and ndo_setup_tc()
>> runs with the RTNL lock held. This closes the same cycle against the
>> RDMA auxiliary probe as the two preceding patches.
>>
>> Use device_trylock() and report the device as busy when it fails, with a
>> distinct message for the same reason as in the previous patch.
>>
>> Fixes: 4b31fd4d77ff ("ice: Fix RDMA VSI removal during queue rebuild")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Petr Oros <poros@redhat.com>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_main.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
>> b/drivers/net/ethernet/intel/ice/ice_main.c
>> index edb62606d2aae3..7b251136149615 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>> @@ -9448,7 +9448,11 @@ ice_setup_tc(struct net_device *netdev, enum
>> tc_setup_type type,
>>   		cdev = pf->cdev_info;
>>   		if (cdev && cdev->adev) {
>>   			mutex_lock(&pf->adev_mutex);
>> -			device_lock(&cdev->adev->dev);
>> +			if (!device_trylock(&cdev->adev->dev)) {
>> +				mutex_unlock(&pf->adev_mutex);
>> +				netdev_dbg(netdev, "RDMA auxiliary device is
>> busy, try again\n");
>> +				return -EBUSY;
> You return error here, but it looks like being silently dropped in mqprio_disable_offload() isn't it ?

Yes, mqprio_disable_offload() ignores it, the same as it ignores the
existing -EBUSY for a bound RDMA driver. Blocking there brings the
deadlock back and skipping the lock races with the probe, so v2 keeps
the refusal and warns about it instead of netdev_dbg().

> 
>> +			}
>>   			locked = true;
>>   			if (cdev->adev->dev.driver) {
>>   				netdev_err(netdev, "Cannot change qdisc when
>> RDMA is active\n");
>> --
>> 2.56.0
> 

