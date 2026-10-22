Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792665621;
	b=Id54BxiIcgXvDQ1ledpWfYB6CygvyD+OOiD43U2vepefT/qtnBgkC0xMFnP+pdeXXt5l
	 TpqeNP4uagAWVvQ6cEyMgmmGR9ubZo9Acxnjcg42IsSrhD/FWKDlPWdzqLa8ZuY8owoRo
	 WWB5bCbnzNAAh6KLEEeSV2RXU0spCQreD3IHkvQOK33KVwJ/qjV//F3YIPG21YQv0Jn4o
	 41e9SEsZYnVy1I8PLJxiOV1xoo9CH41+KNDYUqUYGDLmOFbXRHeriy78ika+pCiTOKITs
	 4c1baqMVaYghSSnI21+YAHKRf65Z/YJb/ziyKsd0iZl3LH4IYeG4OzAk4TkDuxiJZyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792665621;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FEKm5nQsGf/I+ugCmSSfq8QJNoZ1NYPo9Xa7ZqzEb5w=;
	b=reDmnZ8g/9YSkSyBVJhQ6bii9q3qfRj+s8OLNJ8Pin+kZtZudkinO7T6YNFY96E9RiVw
	 FxFKqQ0GXwg4fGrqwwgJSkw5X6/BhNLBaShEgy69EhlukEfDqIMSiEt4TSDVcTqCfu0Uq
	 dVueSnY8FNBFTYkgBZk+xvXslyAGhLXK/bt0d3wjrbpHiS4XkLca4nAEubyLJpv7U0pJ7
	 3Y401gxiArcnjcsLgs3D5LJsYEhEiPoGS0P3qAfVI7PRafQkANGNZC2L/th/MUTz26Xv/
	 znP6NhYxK7w+gjkwxuMnDHyHrdz+Of59tdbEvDi6ERTodk5av5xb7GR2S35yy1hJUwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=H+aAUIH0;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BNGnn+Hb;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB32606A31B
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 10:40:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BB32606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=H+aAUIH0;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BNGnn+Hb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792665620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FEKm5nQsGf/I+ugCmSSfq8QJNoZ1NYPo9Xa7ZqzEb5w=;
	b=H+aAUIH0CB7c7yTA6nVQsOgOvq2yvnbZT4sOQtojIefTpq3/oXmGcPBj34wd3dqy+6L9s1
	1z+SyMUET+CP2h/2KKdIKCMRDt62/9bovCIzlNcq7D8Xx5dpx/ZnxlVn3DfsKS8qsCaWa6
	HwPTW/4cmawzdKlbFOVqPCghmjn5mjQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-l42htg6HMKK8dD3ehEpYIQ-1; Thu, 22 Oct 2026 10:40:18 +0000
X-MC-Unique: l42htg6HMKK8dD3ehEpYIQ-1
X-Mimecast-MFC-AGG-ID: l42htg6HMKK8dD3ehEpYIQ_1792665618
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a2000d5ebeso11022905e9.2
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 03:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792665617; x=1793270417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEKm5nQsGf/I+ugCmSSfq8QJNoZ1NYPo9Xa7ZqzEb5w=;
        b=BNGnn+Hb1UNwzl0XkCj84/glT4JGR/ZvQvv3wPj85ZRPvZlQKG1qaJV0ne9W1aOLHj
         ZjacEcR92berX4JLAOLGBKvn8MAQEnidr4uhx68Ui8wmtxCzuefbLSd8+07go83/qaSO
         JiZ0Y7h5p8+pJnUnds4LwkpQ1c5jiQ13NsYT/t6/xP3OckHsEmQ0D4NrF5k3UR6qdTun
         G8c1D9bv9nSsquOIRzDFC0RVnB13EDwwxeZfMWgdKWTknaWJVwMeTWW3eFqJj2ZatxUT
         1rmAtxZc3dAp+pv2Kj/DmC1ch1DNpA/nE3VZ8sFhFuMS+fwVFivKrkiPbnsJr9WM0Enz
         fsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792665617; x=1793270417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FEKm5nQsGf/I+ugCmSSfq8QJNoZ1NYPo9Xa7ZqzEb5w=;
        b=Hdo6D3qI6dwIzQNpvRMtrTJ8mnAEwPoB3OtjD8eick9TtP5a0BfdkZ2FTNZ1OPIKnU
         4mPzIv+jP0rZVfj+lryCIE9Xo/7BNX2iTtrdHDwdAH/yL1NWxVH7RwLwA2Rk/1fmNNjX
         s0bmoYVjuDXLvlEC0agMgvR2VEozyT8ULBSJrDbmhJpPWpfvEmXZCGJ7AhEpFkv3kODe
         XhY4nMCbJDvnUsrffWJCzi/e1egDa6huYZ4D0SgdhzjOtIItM071IBSLSw/RA014sUHX
         sGTazrBeHfUxgFXqLHriTFqUQjHfeFj3RjYXGeA2IviM+txdGUZDgUM+CEWY6us47/+N
         qn0A==
X-Forwarded-Encrypted: i=1; AKwUvByO2+TSwbj5xHdp1SdPOvdDjyNc+4AePXS/+OQZyvJ8InBM/RDIZ4CJ5f5/i5ROiMDAfuX8KIWSiuKS@vger.kernel.org
X-Gm-Message-State: AFq9FYKJqJ8YZ1EKbYWuasl89ZAM4Hen3f6J1EBo4h0M05kvEsoNSWt1
	GFZpL9OQ24pCIDmh0D4zvfjlYtbvXUFWhcfZHOAY3u0ksSM5HZ5iunZeTkobh8AxYQNzKvrtYjY
	ZS5VqsLY9qIv3tiCwKibf2UHA4756WR5aAI6zyCcyS2LVXctWtODLxmL0nahg+LA=
X-Gm-Gg: AYBFou1jBmHhPynjGrgmAMt1ziEJMAbyE6+fD0g8JSERNjOrJx6NQ5KbW0TTuFYxmv8
	7J8ycBIrQl30pj005B5HTBXS0fpi3Q0594SbUcZTqksQIFitUYHDJj4dJkLMRwEJmKVAW+/eKCs
	nm79D3oSmmiMuLWW7ETHGMULEiwQoheHngSPstmwD7VAo6vnDWOMucXrPtvQ7TgrifITLs9MsNA
	4szA+7k1GFbPD78vym3xVU+YkOaZvfJxY1ci7mugzJH03PAfDRNDAIyhW1fx3ebcevgDwKVJrPq
	Mm0ioTBnMqsacaEvfRmuUMXgVH4iKIzDd8bLyLyWQUt2RS0f0CdF9lLwuKarcpFQAZsCCunJAA=
	=
X-Received: by 2002:a05:600c:5308:b0:4a2:47:b79c with SMTP id 5b1f17b1804b1-4a20047b7bemr73764675e9.32.1792665617533;
        Thu, 22 Oct 2026 03:40:17 -0700 (PDT)
X-Received: by 2002:a05:600c:5308:b0:4a2:47:b79c with SMTP id 5b1f17b1804b1-4a20047b7bemr73764225e9.32.1792665616929;
        Thu, 22 Oct 2026 03:40:16 -0700 (PDT)
Received: from [192.168.2.75] ([46.175.183.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a207fd494dsm17235475e9.4.2026.10.22.03.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 03:40:16 -0700 (PDT)
Message-ID: <9d167482-2cac-42eb-9fa1-c242406c493d@redhat.com>
Date: Thu, 22 Oct 2026 12:40:13 +0200
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
Subject: Re: [PATCH iwl-net 1/3] ice: avoid RTNL deadlock when notifying the
 RDMA auxiliary driver
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
 <20261019065301.3983537-2-poros@redhat.com>
 <CH3PR11MB566895C406B00646530A5249C9E5662@CH3PR11MB566895.namprd11.prod.outlook.com>
Content-Language: en-US
From: Petr Oros <poros@redhat.com>
In-Reply-To: <CH3PR11MB566895C406B00646530A5249C9E5662@CH3PR11MB566895.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/26 1:20 PM, Loktionov, Aleksandr wrote:
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
>> Subject: [PATCH iwl-net 1/3] ice: avoid RTNL deadlock when notifying the
>> RDMA auxiliary driver
>>
>> ice_send_event_to_aux() blocks on the auxiliary device lock, and the
>> dcbnl callers reach it with the RTNL lock held. The RDMA auxiliary probe
>> takes the two in the opposite order, because __driver_attach() holds the
>> auxiliary device lock across ib_register_device(), which needs the RTNL
>> lock:
>>
>>    systemd-udevd   state:D
>>      really_probe                  <- holds device_lock(&adev->dev)
>>      icrdma_probe
>>      irdma_ib_register_device
>>      ib_register_device
>>      setup_device
>>      irdma_roce_port_immutable
>>      ib_query_port
>>      irdma_query_port
>>      ib_get_eth_speed              <- blocks on rtnl_lock()
>>
>>    lldpad          state:D
>>      rtnetlink_rcv_msg             <- holds rtnl_lock()
>>      dcb_doit
>>      dcbnl_ieee_set
>>      ice_dcbnl_setets
>>      ice_pf_dcb_cfg
>>      ice_send_event_to_aux         <- blocks on device_lock(&adev->dev)
>>
>> Everything else that needs the RTNL lock piles up behind lldpad and the
>> boot never completes. The probe side cannot be changed, so use
>> device_trylock() and report whether the event reached the driver.
>>
>> IIDC_RDMA_EVENT_BEFORE_TC_CHANGE has to arrive before the traffic
>> classes change, so ice_pf_dcb_cfg() refuses the request with -EBUSY
>> rather than run it behind the RDMA driver's back. The critical error and
>> MTU change events are sent from the service task, which consumes their
>> pending bits before sending, so those are re-armed instead.
>> AFTER_TC_CHANGE keeps its fire and forget behaviour, it can be neither
>> refused, the hardware has already changed, nor deferred, every lock that
>> would serialise a deferred delivery against the dcbnl callers forms
>> another cycle.
>>
>> Fixes: 348048e724a0 ("ice: Implement iidc operations")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Petr Oros <poros@redhat.com>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  9 ++++++++-
>>   drivers/net/ethernet/intel/ice/ice_idc.c     | 20 ++++++++++++++++----
>>   drivers/net/ethernet/intel/ice/ice_idc_int.h |  2 +-
>>   drivers/net/ethernet/intel/ice/ice_main.c    | 16 ++++++++++++----
>>   4 files changed, 37 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
>> b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
>> index 0bc6dd37568792..2022b46c990cb2 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
>> @@ -355,8 +355,10 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct
>> ice_dcbx_cfg *new_cfg, bool locked)
>>   	struct iidc_rdma_event *event;
>>   	int ret = ICE_DCB_NO_HW_CHG;
>>   	struct ice_vsi *pf_vsi;
>> +	bool dcb_ena;
>>
>>   	curr_cfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
>> +	dcb_ena = test_bit(ICE_FLAG_DCB_ENA, pf->flags);
>>
>>   	/* FW does not care if change happened */
>>   	if (!pf->hw.port_info->qos_cfg.is_sw_lldp)
>> @@ -406,7 +408,12 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct
>> ice_dcbx_cfg *new_cfg, bool locked)
>>   	}
>>
>>   	set_bit(IIDC_RDMA_EVENT_BEFORE_TC_CHANGE, event->type);
>> -	ice_send_event_to_aux(pf, event);
>> +	if (!ice_send_event_to_aux(pf, event)) {
>> +		assign_bit(ICE_FLAG_DCB_ENA, pf->flags, dcb_ena);
>> +		kfree(event);
>> +		ret = -EBUSY;
> -EBUSY doesn't match to any ICE_DCB_* constant, are you sure you tested this case?
> It looks like it will be processed like ICE_DCB_NO_HW_CHG i.e. no change needed, isn't it?

The negative return takes the same path as the existing -EBUSY for the
custom Tx scheduler. ice_dcbnl_setets() and setpfc() pass it to dcbnl
unchanged, only ICE_DCB_NO_HW_CHG is mapped to zero. setapp() and
cee_set_all() mask every error, that is pre-existing and also hides
-ENOMEM and the AQ errors. I have noted this in the v2 message.

> 
> 
>> +		goto free_cfg;
>> +	}
>>   	kfree(event);
>>
>>   	/* avoid race conditions by holding the lock while disabling and
>> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
>> b/drivers/net/ethernet/intel/ice/ice_idc.c
>> index 102d63c3018b1f..7fd35ce966ea65 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
>> @@ -34,30 +34,42 @@ ice_get_auxiliary_drv(struct iidc_rdma_core_dev_info
>> *cdev)
>>    * ice_send_event_to_aux - send event to RDMA AUX driver
>>    * @pf: pointer to PF struct
>>    * @event: event struct
> 
> ...
> 
>>   			kfree(event);
>>   		}
>>   	}
>> --
>> 2.56.0
> 

