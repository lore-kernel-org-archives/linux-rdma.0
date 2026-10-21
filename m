Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593230;
	b=dNcQLUx8urS1vIeOBoYJdjtmSbfFAXyzO4nIrBma13NNhg0wbj88zKp9ibq7Gm1xF4ZG
	 VltwCrV4x4C8Z/VGVzgs9nXR/Ffk95SoMQw8J6GvMXcdemYjoX6lqkSy3ISlNA04mp/sn
	 btlYw112YYzfJHCqPSw1I9VCw/IaYFpqy/MAKHnGhO27tgtpv7YkY4VPOo3U7jbKd28ME
	 Tvdv5c6+CMUltAzpskXVrOPLTxzHw4rFIDMaeExFaQx8AbQ4ED1P+2njY3DOP1M+cqKlf
	 4//NeTBuHSKWtANJ09g6LBUJ2U7JO9IgnKO/M/g3E8H0aLdV+4gpHVjGqX+Y+n+iLsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593230;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pYNpcLyFz6HUlSTmqyPZEPX0/mcE5+MbBWGYVNQFy8I=;
	b=ZsaZ9UNCLnULSCqwoTYCQuS4/bzkFU9GdZJkeD3NR3hqJ9xqfZaPlNGXOfSV2OxNpj+p
	 nLapjDWOH2g6NSXNyM9uwvijqln9fBidW9himXNxqYr6CyeU359VzJO4CZV7L9Y2XtT7I
	 w8fFO3DJ1NRVE947CVuH7zkXF6s5H0XxKjj1mgP9K4NwAO4prBJkCd65LtkMEsOcIKLPm
	 e/CkC2M5OM6Sb+uIQkx3yJW98iEVSpHuaT7itBHjgN84wL3i0MP0jNCFtco8a9H4eJz/f
	 yA5Y0dmN1KiQD7s1W7bGRabXhTvqjyXn05n4UudHtYQf3sGv4/UbNOaei2lwIvZi0PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LoG5PtMp;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Uplxl6Wi;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647B4606A31F
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 647B4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LoG5PtMp;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Uplxl6Wi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792593228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYNpcLyFz6HUlSTmqyPZEPX0/mcE5+MbBWGYVNQFy8I=;
	b=LoG5PtMputVemm+hCBiWsniIaJGDOBRgOGQG2Ae+1mriSzTO2/uMEX/TgEthSgMlOIc28T
	0OKf8CbpMxGI+FZw2xAvSAyQHvvcpLS+BMEkiOTZ0DYLglfFe/orm/ih/PKXl3x8a6H7TS
	JEqF4cnefJ96QKAV7fh2WoZxUteIMfU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-IyiwUtwjOOmd8Ltj0fuhZQ-1; Wed, 21 Oct 2026 14:33:47 +0000
X-MC-Unique: IyiwUtwjOOmd8Ltj0fuhZQ-1
X-Mimecast-MFC-AGG-ID: IyiwUtwjOOmd8Ltj0fuhZQ_1792593226
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a0228f4a1bso4930385e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 07:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792593226; x=1793198026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pYNpcLyFz6HUlSTmqyPZEPX0/mcE5+MbBWGYVNQFy8I=;
        b=Uplxl6WiSzZ4xZ9Jrr3fa+o0Ztzz+0+srDLs+CN4ZfYpoEesfRqGme7g70hOC55gJS
         mAnZqFQrxmfdIfmWPyP+OCwS7Yp6NQn5XtHG3H1Yp92Ad9CdXTWlKU3UBVPc6aA1wbbb
         dIkYwiO6KQaQoznBDeinAHy8pSMwrnKjakETHhyzoeeYyKHNhJU0nYVs9EKIZWOhfx18
         bChFw530D16twjouZ56kS/qmVXRnNJadZD8eD/VoI7WyAJQYGtyc2wnVNyTW/iDmgLNE
         wmq6HBc43qX/EaY1pMB1J6PecCTbPlJ+qiG4Sj4OCj7WnAzkaJZjEEWju6KSUoRCNh5o
         VrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792593226; x=1793198026;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pYNpcLyFz6HUlSTmqyPZEPX0/mcE5+MbBWGYVNQFy8I=;
        b=e/UmxrrTpbGCXqKJ7EjtFWykp1ZLfPyC4136CcWufgta9eBxS2FzrG8D9LUt+RdlQY
         zE8ORwpKEd+xJIlTN8CgybdSwG/2ZWFwsNOi4W5ADKr7d8w0oUEX4IwWlYnlWPCvbOq8
         xVnO8MAWRbwICaXqHUWdCQ2mAQgdvHvymX0qJO2Bi4JoXzPcLD0z0UtqAqxlH2hQkV2A
         Kgqt/F47pimt+Ay3CcIHDtXL6je5ok+XkKAYCGPb1odRW1aDCRewBWPKuiHhR5IL2XkY
         8BoMwSGQ4G43wzElTWlFbGubgmfB6lokeTlDEzibP3yIgeZYL1mLr4CKKrNDzXSbT5ZD
         RQcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzqd5GEz0WX1HuU+BpCwrExBMKPDxVC8Er/SBDrt5q7qNIbIEgPZ+bvxBsWUlWY31gQbkTHmaRCMD0S@vger.kernel.org
X-Gm-Message-State: AFq9FYLMn1MjHMS42Ca105FnID5BOM2WePVyxS5MHRugBO84ibnvYAF/
	nlhVdDYeCbD6lKBe2kwEBBx+HE2KTUjPbn6XXBQiUGhoi3qW1huRfANebizDyllC1WUXQGbMGxm
	FCeLcizq7LDv/L042JunWnX+hLh6QrL5rJP0+/yvAk2cPFDlcINz+/IlGVJNEx1U=
X-Gm-Gg: AYBFou0BIT0dnV4WW12V/50Pi+zGItbfnQ3UDmslvQuxFqI1tkbOzuWttokGXa31ODw
	/jBw+wejnOcqMHhybVIlGEgOjv4eZ6pQLyNONtTg1lXxufxCT2yUzYPBcOyvQJLjXYV7CHG4TRJ
	YIVsFu/D1m4OmGyIw8Tw0kRJw7uB9CfmGsOcrhmojS07iMHO2wRJe/bRk9ZAr3XUJCDdnnNEY8n
	Moe7lq6o8w/wRtn6Hpos3C5HI85Qn8Nr8jYUFW4ZutTHypTbN4K7XIMjMqL9XdtNz9dcGH+z/9G
	Ax6e1/ygCUgT1UhTTutXWndQUwka3DQaaQZuIuzEnf1O0DHnVYZVsdqvwZqFkHE/pmCljXHm5F/
	wnaOzCWw/B2tIg4/6EpWqZ5lyCknlfojn3hvhJmHX1x2djJwBA2iVUZZbMzeVabRJ8iBl2ZmpFg
	==
X-Received: by 2002:a05:600d:82c1:b0:4a1:cdab:f5c4 with SMTP id 5b1f17b1804b1-4a1fdd24674mr47196525e9.5.1792593225724;
        Wed, 21 Oct 2026 07:33:45 -0700 (PDT)
X-Received: by 2002:a05:600d:82c1:b0:4a1:cdab:f5c4 with SMTP id 5b1f17b1804b1-4a1fdd24674mr47196105e9.5.1792593225200;
        Wed, 21 Oct 2026 07:33:45 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581fa7fsm5484387f8f.17.2026.10.21.07.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 07:33:44 -0700 (PDT)
Message-ID: <bcc5e8c7-21fc-4b63-a954-d737a37e9571@redhat.com>
Date: Wed, 21 Oct 2026 16:33:43 +0200
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
Subject: Re: [PATCH net-next v10 00/13] net/rds: make connection lifetime
 reference-counted
To: Allison Henderson <achender@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
 horms@kernel.org
References: <20261017032319.2563014-1-achender@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261017032319.2563014-1-achender@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 05:23, Allison Henderson wrote:
> Hi all,
> 
> This is v10 of the connection-lifetime set (v1 at [1], v2 at [2],
> v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10],
> v9 at [11]), following
> "net/rds: own the fastpath locks across connection teardown", which is
> in net-next.  It is targeted at net-next: although the series fixes
> real use-after-frees (one syzbot report and one report from Chengfeng
> Ye below), it does so by reworking connection lifetime rather than
> patching the individual crash sites, and that rework is too invasive
> for net.
> 
> rds_conn_destroy() frees the connection, its paths and its workqueues
> on the spot, relying on the documented assumption that "no one else is
> referencing the connection".  That assumption stopped being true a
> long time ago: connections are destroyed on netns teardown and on a
> protocol-version mismatch as well as on rmmod, while pointers to them
> still live in socket rs_conn caches, congestion-map conn lists, CM
> callbacks and workers, and - for as long as an application leaves data
> unread - in every rds_incoming sitting on a receive queue.  No single
> Fixes: commit covers the rot, so the series carries Reported-by tags
> where there are concrete reports instead.
> 
> Patches 6, 9, 8 and 13 are ports of the connection kref work Sharath
> Srinivasan did for Oracle UEK, adapted to the upstream code; patch 3
> mirrors UEK's device-removal gate in rds_ib_add_conn().
> 
> The series has been validated with the RDS selftests over loopback-TCP
> and RXE-RDMA, plus churn tests that delete network namespaces and
> unload the modules under live rds-stress traffic.
> 
>    Patch 1 fixes rds_ib_conn_free() re-enabling interrupts under
>    a caller's irqsave lock.  syzbot has since reported this one, and
>    Nguyen Ngoc Thang has posted the same fix for net [12]; it stays here
>    so the series applies today, and can be dropped once his lands.
> 
>    Patch 2 makes the passive-connection exits of __rds_conn_create()
>    undo conn_alloc() the same way the lost-race exit does, through one
>    helper (a refactor: the passive twin only exists for IB, so nothing
>    leaked there).  Both are first in the series because the
>    reference-counted teardown calls conn_free() from more places.
> 
>    Patch 3 has rds_ib_dev_shutdown() mark a device as shutting down
>    under the lock rds_ib_add_conn() attaches under, and makes
>    rds_ib_add_conn() refuse a marked device: a connect that was past
>    rds_ib_get_client_data() when the device's connections were dropped
>    could attach to it afterwards and, on module unload, never be torn
>    down.
>    Based on UEK commit:
>       8d0639e6ba2c ("net/rds: Clean up ib_nodev_conns list handling")
>       https://github.com/oracle/linux-uek/commit/8d0639e6ba2c
> 
>    Patch 4 guards the five work-arming sites that never tested
>    rds_destroy_pending(): two IB completion paths, the IB recv refill,
>    the TCP accept kick and the multipath reconnect in sendmsg.
> 
>    Patch 5 gives the connection its own destroy-in-progress marker.
>    One destroy caller does escape the old predicate - unloading the core
>    module runs the loopback pernet exit for every live namespace, where
>    check_net() is still true and the loop transport's unloading flag is
>    not yet set - though nothing can queue work at that point today.  The
>    later patches need the precise answer: the passive-twin creation must
>    refuse a parent whose destroy has begun, and sendmsg must drop a
>    cached connection whose destroy has.
>    Based on UEK commits:
>       e2f5005adf63 net/rds: Add krefs to struct rds_connection
>       https://github.com/oracle/linux-uek/commit/e2f5005adf63
> 
>       6c53ef92f46e net/rds: Merge uses of conn->c_destroy_in_prog & RDS_DESTROY_PENDING
>       https://github.com/oracle/linux-uek/commit/6c53ef92f46e
> 
>    Patch 6 splits rds_conn_destroy() into a synchronous quiesce and a
>    kref-governed free.
>    Based on UEK commits:
>       2c8569e4c880 ("net/rds: Add krefs to struct rds_connection").
>       https://github.com/oracle/linux-uek/commit/2c8569e4c880
> 
>    Patch 7 unlinks each transport node before its destroy, so a
>    free deferred past the teardown loop cannot write into the loop's
>    stack-local list head.  IB marks a gathered node as claimed by the
>    sweep, since its connect and shutdown paths move the node too; for
>    IB this also closes an existing corruption of the nodev list on
>    module unload, through the stale spliced head.
> 
>    Patch 8 makes each transport's exit path wait for its connections to
>    actually be freed before the module goes away.  It comes after the
>    unlink patch now, so that the IB resweep only ever finds claimed
>    nodes.  The wait is
>    unbounded and warns every ten seconds: a connection reference can be
>    held for an application-controlled time (unread data), so a timeout
>    would only move the use-after-free from freed memory to unloaded
>    module text.  rmmod blocking while data is queued and unread is the
>    historical RDS contract.  For IB the wait re-sweeps the nodev list,
>    since device connections migrate to it asynchronously.
>    Based on UEK commits:
>       ece4b4e39afa ("net/rds: wait_event_timeout until zero connections during rmmod")
>       https://github.com/oracle/linux-uek/commit/ece4b4e39afa
> 
>       905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count")
>       https://github.com/oracle/linux-uek/commit/905ec90e6166
> 
>    Patch 9 makes struct rds_incoming hold a reference on i_conn, the
>    fix for the KASAN use-after-free Chengfeng Ye reported [4].
>    Based on UEK commits:
>        99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
>        https://github.com/oracle/linux-uek/commit/99b9a3715419
> 
>    Patch 10 has the quiesce purge cp_send_queue under cp_lock, as every
>    adder to that queue holds it, and clear RDS_MSG_ON_CONN as it does
>    so, the way rds_send_drop_to() expects.  No sender can be in flight
>    at any of today's destroy triggers (netns teardown, module unload),
>    so this is hygiene rather than a race fix; the old BUG_ON() on a
>    socket-owned message becomes a WARN_ON_ONCE().
> 
>    Patch 11 hands out real references everywhere a connection pointer
>    previously escaped bare, RCU-annotates parent->c_passive, refuses to
>    revive a passive connection whose destroy has begun, and serializes
>    the SIOCRDSSETTOS check with the rs_conn cache.
>    Based on UEK commits:
>       2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
>       https://github.com/oracle/linux-uek/commit/2c8569e4c880
> 
>       0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
>       https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7
> 
>    Patch 12 pins the connection across the RDMA-CM event handler and,
>    on both the passive and the active side, declines to set up a QP for
>    a connection whose destroy has already begun.
> 
>    Patch 13 drops the now-unused global rds_conn_count.
>    Based on UEK commits:
>       905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
>       https://github.com/oracle/linux-uek/commit/905ec90e6166
Does not apply cleanly to net-next. The mentioned base commit is not
in net-next nor in net.

You have to rebase on the target tree and resend. Please note that
net-next is currently closed for the merge window.

/P

