Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794308427;
	b=mZxtJdntsdIk9Lud6HVGSKexwcUBUsCnn8RIMQ/1ECVkuYhO1CrSaTkj3aDWd7gHx0Uf
	 X+S8k2PEFz9ePjhYc9c3L90w4L9cb2yHZF4Qi5qEMVTNQWlJQeZ9oTr6SkKJCnGl+wONH
	 d8Hbd35AsO8XdszjePJOOQyLQcbas8ES/zPKUNEKSJZ5m4dmX/R5vMCe4Eb+hAnx3t4jz
	 g4RR3gVpPy2jaAzo0aMDLP9BQl0zQ7lPRhDlpmqngDSqspSUvl92mQ3IIm0vkjQu8lnwM
	 GSmxoZAdImMTmfynJBrGACBjMH/MjE/JW9vgiRxDB8C4/JrcJ58U2WgxpXKg/bc4oxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794308427;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=PvjZgTETpTgpa2EwGhWe6LWOvKhagS++4LBHee0TILc=;
	b=tARvYMR/yG9pyLCI1cUcn/BTTvUKq1z3NFULkdSbv6sn4ycaeL/LqtSToQUEXvAcuH/0
	 izZdi+T9TAo9Tboz0WQ7rij2wc3B6m/3NUIGccgpsoXks5yDQYZk64Z0Yc5SjfKw8WbVZ
	 nBFPndjt7sETzy0ZA9RDb5sxvboRY2I4+ljNzt9Z9mu4gIfKwNg9T5L2F/0TUIJ3PuWLj
	 hR4FvDE3q7BlK3sx49haODuUel+VmDSW7uP+7fxHD4EzWkK6rrhPKwONQP4yArrHYM795
	 0Y+wukdsTu1nVLrSrsQSQ2ih9yxb8krknSUIOQLH933BSYPcd1BbGQJ506JGUuw56+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Zx/tcHns";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aGxW5UwB;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA51360A2602
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA51360A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zx/tcHns;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aGxW5UwB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794308426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PvjZgTETpTgpa2EwGhWe6LWOvKhagS++4LBHee0TILc=;
	b=Zx/tcHnsXU9bYCgwbuuA9BbmlMfKI/eHN1oFfmH5LlJ8HukocX3M0vvkvlvbIQ5kYqtUGv
	TIf+TARp658IlpyeufgyYBxCVJoCe2NeHgBybCXv6tX3y/l+ipcaRs79Uh7281DfS9Zrbf
	NmHeUKJ8imdxNFCc2UHzcqjVcqBeK4s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-zy-4tdi_OsKEuVIphyXIlw-1; Tue, 10 Nov 2026 06:00:24 -0500
X-MC-Unique: zy-4tdi_OsKEuVIphyXIlw-1
X-Mimecast-MFC-AGG-ID: zy-4tdi_OsKEuVIphyXIlw_1794308423
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49953abe51fso14113555e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 03:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794308423; x=1794913223; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PvjZgTETpTgpa2EwGhWe6LWOvKhagS++4LBHee0TILc=;
        b=aGxW5UwBL6Ch2N3+dvQ6/Gppqp/AubIefTtK1oM3wugrAIpPyZzt2Bc7oCP3J56nNS
         koFRcyDesiB0ooi2zC3h8Cy+VEP00ezo9CrpMDD/jL9ZM/mZX9b0m9mUJoK/uYrRDOJO
         lMZZ1XymsknXqIt4b2kfOBX4WB47oQRsZmxyljE6R6Am5ygN1EC7vFhNLmXHVeQRC75D
         4L2nHFIYw1AvJqg/MpE9bX2xP2cyojHTSk0tNth/8igEtkLQcoCStUHYWJrqJ13CS+nv
         1rm81pej5a8HH/DpRIFnvfM2YSdujniYSkP190FegldAVTnjJl++jp9k9Jxm+lMrXPK2
         FaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794308423; x=1794913223;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PvjZgTETpTgpa2EwGhWe6LWOvKhagS++4LBHee0TILc=;
        b=qQfv/k2UreJAt8mty1TiD8aIbRW0kJxOXXg1YCc8raWllD6WMPvSeYsmdkV8ffYlDi
         38ylmfS+/xzolYtr5dxiKlx6/GfQctOtc1gmWIgagqmCNFbEaGHqbq/bHzFFVoByPFGZ
         e+bvjC7rm1VAJfWeFpH8mKqzJkoPmGwvhEwtNvCxbt6xoy6qY0Dw5cpz7nL8PQ3IEPg/
         OVWEo0YHbKzttnT8A/zD3wsAvOf0YgK0hXi68pDOSTVbT/cxyX5iRV+Jw7I9/8GYGce0
         axEDLa0qiEGlTdNgqWznrbB5QLlawFBA+5nArm/wGcYJNy+FgqGHeoPk/UPEERWG4Jzd
         ncUQ==
X-Forwarded-Encrypted: i=1; AL+hErE0T77FEdnhNdUMtY8W1RGEsxYb/ArwjXoRwbRCKKN/9i5gv0jYwjiWyxDrsuLy/KnC46Jf+z6AW/eN@vger.kernel.org
X-Gm-Message-State: APuU4Z8hT/Q5DYbu6plMKRGqugshJ35qzFGkMoWd7UuFgzZPPmbq6Zr9
	hAoYbhgCrETtPlBFVgnU/vs0TBKgtF1by62txbctS3PlzQ6/k0H63p+8XncYAeccab6sP/nOa62
	VHNWS15/lg4G+cto78Xt+XwUbD/ET15JP2dqHgK1dx6Thl/f05+VairJlc0YGyUE=
X-Gm-Gg: AYBFou305f2D4ZT/m31+/t1pSd5YyhGaXUqt5OlCKY1ypymnPgXll/Im1TeOL9R4QNG
	gmPEVfDT65ZEi4AvLrguv8JtngAkiVsXKz4knIEV7sYj9MPXrLS9hYCJD9aQ/HNyAYy2iP71vYN
	5yWUXZMXwgUhyGi8WB60m58oNENeSCGE1bhooGhwni73GnRYGwqsCkl5I5rXva0r6hMbmrwFcsi
	s+dgmr9CATqD9nZxS/FOaMs73gDtHXF4pszK7HoVtNOkc5v098gO28J1oGJEbEPeWQ/GaXaTQt6
	cDc5a7h/lw1+2WkRwPvp6DTr+/yQoj+CAOcZhREJIsE1u+vplpr3UEN7lhO6B5CEmfrfJJp6rv1
	ecz4RilVhGJ6WqrJduFYbN1XOfXULMEz637zlvQPr93V0T+cJ6SrCWGd2fgtUvTsigaRMSzncM6
	pMfEyJURUfdYxuLfNp7+YNaFfsMKsk11ExiFOqUw6U1mnF
X-Received: by 2002:a05:600c:6095:b0:4b2:3c81:d1 with SMTP id 5b1f17b1804b1-4ba02336388mr36938145e9.5.1794308422273;
        Tue, 10 Nov 2026 03:00:22 -0800 (PST)
X-Received: by 2002:a05:600c:6095:b0:4b2:3c81:d1 with SMTP id 5b1f17b1804b1-4ba02336388mr36936355e9.5.1794308420789;
        Tue, 10 Nov 2026 03:00:20 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba0204e22csm52154425e9.12.2026.11.10.03.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 03:00:18 -0800 (PST)
Message-ID: <e15d78be-1e80-469d-96e1-dd83cd90a929@redhat.com>
Date: Tue, 10 Nov 2026 12:00:16 +0100
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
Subject: Re: [PATCH net-next 05/15] net/mlx5: LAG, decouple iteration
 end-of-walk from MLX5_MAX_PORTS
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Akiva Goldberger <agoldberger@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drory <shayd@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-6-tariqt@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261103171009.563034-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

there are a couple of unanswered comments here...

On 11/3/26 18:09, Tariq Toukan wrote:
> @@ -2095,7 +2096,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>   				break;
>   			}
>   		}
> -		if (i < MLX5_MAX_PORTS) {
> +		if (i < ldev->ports) {

[medium]
Should this compare against ldev->max_funcs, like the other converted call
sites?
The iterator's end-of-walk value is now ldev->max_funcs. That holds both in
mlx5_get_next_lag_func() and in the mlx5_lag_for_each() condition.
Indices are never compacted and max_funcs never shrinks. So a PORT-marked
member can sit at an index in [ldev->ports, max_funcs) while the ldev still
has ldev->ports members. One way to get there: more PFs than num_lag_ports
join the ldev, and a lower-index one is removed later.
In that case the inner loop finds the matching pf and breaks with
i >= ldev->ports. idx has already been incremented, but this block is
skipped, so the bond_status |= (1 << idx) and has_inactive updates are
lost. The later check would then fail:
	is_in_lag = num_slaves == ldev->ports &&
		bond_status == GENMASK(ldev->ports - 1, 0);
Wouldn't that leave this bond silently not offloaded?
The old i < MLX5_MAX_PORTS check covered the whole index range that the old
xa_alloc() limit allowed. This code is unchanged at the end of the series.

This looks valid to me.

>   			if (netif_is_bond_master(upper)) {
>   				slave = bond_slave_get_rcu(ndev_tmp);
>   				if (slave)
> @@ -2360,13 +2361,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>   	if (!pf)
>   		return -ENOMEM;
>   
> -	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
> +	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
>   		       GFP_KERNEL);

[high]
Can this let member indices reach 8 or more while several arrays are still
sized MLX5_MAX_PORTS?

this is solved at the end of the series, so not really a problem.

Note that there are more unanswered comments on patch 15/15.

I think a v2 is need. For the future I suggest using smaller series:
15 non trivial patches will have increasingly hard time with AI
reviews.

/P

