Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638563;
	b=c1fRO8XG00coHrYgnS94MgWsWAGHCfL+wrKsMhvzvbJzoc2QKqB3qqZIL4Oja+ZF7Kgi
	 3ELoASrRsVkxGtU1Y0BdLrUFTcPsH4A80KtwgbYVk3iYxaAuIprRCH3v8BSlprv/UISU4
	 /0mNw+aKI+h2sMU0mOvhfNCnkGdEItWIKc4onNTnl5zrJN6YGQQ1raRQnrHXM8oZd/7a/
	 AsEOnR/AI1ukVXBBQE6uhZEn4N6Ud/uDCIFSyThke6RXHj2A86X+MljzUjyM4WK7o3nah
	 L4rlah/hb997t4du/BKFT0bncSMu1zkvWgFVRXJUtHKateh/jygVgeaTUgkABw0tLWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638563;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 X-Relaying-Domain:Received:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=l8Vm7b6mvicOGbNITWz8S9UqTwj9675iuxlFyNmsQcY=;
	b=mvxQnOER3cKi6hM+vxq/QqR8j8bFpzTjtYF80YzxPKv1FMsvG1t1SZqyiPPXk0sV4LLV
	 4gI2ozyFJ7DflHBxeUBhBgOe0jTxg/6MVT5Hd/XIWeM3v8QdtN0K0rnuMJnwom7U8YFna
	 SiUHHjyTiP3XXlFyN+o4QlklZCCn3ESWobHMzABmnqANoVmhMZI70R9dE2nTt3xPinQeI
	 CKS5U9BAT/Df3ifSmXLKzI2UmUtgL2AgbiAzaSTeQQLtrkJbmZOhcwPR7j2CYGuhQoxFl
	 eQUF51hGXO7Xfis14oprImvlNH5kxmLOUVgAzK6jyu11xsT9O/6AuTY4IdCJvsMBuKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=LApZd8rh;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB30606A323
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 20:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BB30606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=LApZd8rh
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b41e627cadso3886412a91.1
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 12:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1795638561; x=1796243361; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=l8Vm7b6mvicOGbNITWz8S9UqTwj9675iuxlFyNmsQcY=;
        b=LApZd8rh/oPgJtsMdJZnCK6600SYC8qzkNvEgzFB5VzozYeVst2oxxhwbl9/2qsv1G
         CuyXxOD461T9nazzw2PqtjHtqHeEzQ87ihdLEgNkhuRti1uGOXV4aNl1J917YQRCG3dP
         PJAMDfLxc4daKZk3MrXcJA58vZiz1GrLXwk5dsff908QWqgQUf7hUCRamjlEAXBdvIR9
         WTqjf30rL+eAxjPG0dtshlshCBNdFj07he5/yG0VKfHq/kLmMhZ1KrMIxQMBdlsBH8q/
         38pnMC6xZ4NikFRFFE+PoW4p7XsVd3CASnyJYmGVeI+S02o8L0JKRww8+yC08NtDmOOS
         bnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795638561; x=1796243361;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l8Vm7b6mvicOGbNITWz8S9UqTwj9675iuxlFyNmsQcY=;
        b=jDQiIBJiiNTBo20jsHzwEskrgStb5VzWiboeMm2VB+ihYBDyIg2KXf85CdreHhZLHq
         bICqk4Ap7P5vBwXHJ+c4+76BCwzwQpLOp6lt6gykvh2fueDR76qpH6n3QOXd5uLmO71J
         y2zaOBnQ5FtqXWZzHK9lDVUeEG48tgW2dQkBNxGLhGd4HRlH+x/rzaee2fETV9/ZhsRC
         jTW4Xce8E/JNN9IyDyRw/BasCtj3NKmlcYjZBUEQXU1fx68snfhbiUfB80T7bFZp96k7
         uWa731xknSIBuLBEOlEI8AG5VH3hLGEwSYBEVviLv8AciGTFruXbwhB4m92WEw43HsTU
         E1fw==
X-Forwarded-Encrypted: i=1; AL+hErEuPnRJ+2YhIlOjm5PiGnnQjvSYWSGQTvi+90qKZuyradO2fBKVesQRITUm2/3KhDXcuHxslyPmZ8F0@vger.kernel.org
X-Gm-Message-State: APuU4Z+Qa4qwEToAX1vZnK9nX1xT6t+99VeNLGVKJKAVmSrC2qTM414/
	D/u2lacnHXLs/KEX+BAFow7YkJXJB+l8HbI5++ZrI3bvXu93MS8kp+gGbPZqY2O75NBOQ0YUsm+
	GTbausRqCzvJ6oILbm4ChrHiFc2yl41VVR1wKxxH0TGE9kGNXKLX4CADDIZQu04AGFMIQhbAtJg
	/8aTXopDqnDW1Df6C7XS5ELKUsWE4cYxlg3g/elKVZekQYd37o2x4hp66MzWap+UU5fvqHrrfzi
	Yk+oSJU1208X0x5HkSfkP4vvwj2
X-Gm-Gg: AZFdTZfKA1h7C1hP3vPz+LTmETDdkcqywUdGsctIlcJmtd+puQWUSGhKJyHEnUtkk0/
	QkITSPIYuNioXbH0vf0Ysy2DnYcRSedEXd9HsdL0XbHyUfe0gyGb9H8rhV4MjGYGA79AN4ZIDLy
	2igJi69q45t/QtR3Ir2M3Y61EmIWew4oA95nGT0Yn2BEg799NydmNszr8C9F1LJT3lDqXAH07Cu
	sinDrzNYUW9WfQr/FfxM+VXR7iBG0LVZMFmpo5ClaZq3qBc/lmxWlgdToLRh21PlTMUpy9RaVw2
	CtnAA0iMZKWfj+hz1nWvQfEa0tIzW3Vrmyg5O1vR+2Q56Re5sfG9oikCe9U2e7zH6gbXvvzfMuU
	C9nkbO72JIlAi+12lDRkLMQkzotzB3YlJhSEjvg==
X-Received: by 2002:a17:90a:ec86:b0:3b4:889:883a with SMTP id 98e67ed59e1d1-3b41c9bacbbmr19118124a91.66.1795638561597;
        Wed, 25 Nov 2026 12:29:21 -0800 (PST)
Received: from c14-smtp-2023.dev.purestorage.com ([208.88.158.128])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b41ffad038sm6179778a91.3.2026.11.25.12.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 12:29:21 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from irdv-tmenninger.dev.purestorage.com (irdv-tmenninger.dev.purestorage.com [10.32.149.15])
	by c14-smtp-2023.dev.purestorage.com (Postfix) with ESMTPS id A45EC3400BB;
	Wed, 25 Nov 2026 12:29:20 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/3] rpcrdma: Serialize notification registration
 with device removal
From: tmenninger@purestorage.com
To: Li Xiasong <lixiasong1@huawei.com>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, 
 stable@vger.kernel.org, yuehaibing@huawei.com, zhangchangzhong@huawei.com, 
 weiyongjun1@huawei.com
In-Reply-To: <20261124021842.130141-2-lixiasong1@huawei.com>
References: <20261124021842.130141-1-lixiasong1@huawei.com>
 <20261124021842.130141-2-lixiasong1@huawei.com>
Date: Wed, 25 Nov 2026 20:29:19 +0000
Message-Id: <179563855914.3954750.1491302687768867001.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795638560; l=523;
 i=tmenninger@everpuredata.com; s=20261125; h=from:subject:message-id;
 bh=K/W7Ttia59kCaqhW00kObD6UYvl0Cy15KvgQbFPRCIA=;
 b=K3KNfLNZW+MlbKg74QBHj05k2lRDd141UEooqOB2WaXr5NbI41rEq9YGVr/e2MQ8pyMpgsa08
 4c/z4AJoO9ABaP2mrNVrAEwbDZbx926CtRckrQhyMUoC7Oo+j0qU8il
X-Developer-Key: i=tmenninger@everpuredata.com; a=ed25519;
 pk=nZPlfTnkwWNTqraxDCv+eNh7JBZRFxAoLY1xeLR6zXI=

> @@ -187,8 +209,11 @@ static void rpcrdma_remove_one(struct ib_device *device,
>  	}
>  
>  	trace_rpcrdma_client_remove_one_done(device);
> +	mutex_lock(&rpcrdma_device_mutex);
> +	ib_set_client_data(device, &rpcrdma_ib_client, NULL);
>  	xa_destroy(&rd->rd_xa);
>  	kfree(rd);
> +	mutex_unlock(&rpcrdma_device_mutex);

Seconding Chuck's nit that you can mutex_unlock before xa_destroy and
kfree.

Reviewed-by: Tim Menninger <tmenninger@everpuredata.com>

-- 
Tim Menninger <tmenninger@everpuredata.com>
