Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5331A3BA239
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887976; cv=none; b=j9o/13i04niiMgtWdqqFkQe49aU0Qg9/0g7Fk2v534QekKQ/kivhgKx7NSEU+nCSemf3Uc5rbjxqMuWePvO5HClU6oU0LIeYYw+2qNv2qWes4V+ysy/QCpM44uuCoSonLoUCKJB6a9zmJcNpePiR6lLcMpBeNHrDG9m7q5tcRFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887976; c=relaxed/simple;
	bh=Yh5EoZ8L8sCNFwRaMZG6NLakXRXnXBmJAd8ORRiLTdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvihlXCkGuFqdX3aQm6cMBqBgmKczgAb9h/MH+743TKnkJMyJVKT2pXmnIEiG/8Ksq2m7H27XZelEgx6lIkHilihyByIQwNK0nxEbIoQa1S7mvnN7je2ev6IlJdLssnLLZIpKCZnRbaLrKAKxp62ws0kRimP9TWivAMOxgsZa2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g04r2blb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eDYDzxv4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g04r2blb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDYDzxv4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791887974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Stt8E8LEXRbDbMmCU9sSGK8Uotc3Frs9Dr0f6bzYxJg=;
	b=g04r2blbgn6tTcoPBUQNZHcd3DjBvQyUtBhzT1hXmB+2tqXRulKQEsp0wer8VN+7wEmTk5
	N394Ghi8/DXLvRAMV2OwFAUOZoyjn6IKKugisqAyj5op5CMfcPl+ZzYM2CfakIX99BQuC9
	nK0c1UyeCROkrERrg+0e52XkaJmUNAI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-wEwYINJQPw2s4K3mZahHww-1; Tue, 13 Oct 2026 10:39:32 +0000
X-MC-Unique: wEwYINJQPw2s4K3mZahHww-1
X-Mimecast-MFC-AGG-ID: wEwYINJQPw2s4K3mZahHww_1791887972
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a0228f4a1bso16233405e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 03:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791887971; x=1792492771; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Stt8E8LEXRbDbMmCU9sSGK8Uotc3Frs9Dr0f6bzYxJg=;
        b=eDYDzxv4kagmAiuTE/aU+CgMN/ytg/sswQnMr8X5RY/ZrwRavOizhM4/DyUoYbTWeQ
         DKs3920U6Ki2TD7RRRyLXQWbYcJldj0g3mKaPO9O4w2vXoTX5DWoAYmeyfj9OgPuEmYk
         hMfg1E0lAP7N2Lf8lUyhyaUhXkjcNw5iam+KRhti6g4LZWGUrXZJ473+E3EWj51bBvmB
         vxhWmo/fP4oDpw6oZdp4sBdHIqFPFI2TaJOYKJAe5dFQPRBleestD+YHTyvFSpQ0Q8q4
         sYWrM7mZCGF/uPVL8THDIOluMGcsfdA/1U+LDRliC554y3KhywajIIvFXf9oPudp1BLJ
         LhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791887971; x=1792492771;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Stt8E8LEXRbDbMmCU9sSGK8Uotc3Frs9Dr0f6bzYxJg=;
        b=Wb0IkwjZx5sIAxLmYyeAavJL5F3ONf0c2W9qeUj6W45hLcew+5vszuqsqjEhvZayc8
         VRbNbctuOFV5La4IpoeYpmce1ljNsISEH4G2AMFVK+CauUzZc3er6X47s49Nf63rzGTx
         3NuU+I7e708hMJfg1jTHxTj4TuYAbKSftMMSbFYJlHcUuKfvFbw73YbO+KhfSKKG9nRy
         /P/GfaTukotlX0TKbIPcwJXb09l6gGxVQCmMbk2smurf0bEH40e9Y8u6bo5iPa3/HF5z
         injGBkcxWa8UnurPSlxrij12yCke81MDMRt3sWHfV+MvzUFYQK3Jz/XXZ6M5uMuJDw+I
         g7VA==
X-Forwarded-Encrypted: i=1; AKwUvBxb68C5L1JjAHe/Uoz1Znk9LKkIeh6x3e94lMiRDvNo0Fnth+IODrsMUnI5GimeOZ/uLrAJxso2QCmW@vger.kernel.org
X-Gm-Message-State: AFq9FYL9fgGSkZpL0pCec7BquuplRE9GuD3jOlagELGOkduAIMM0wzt9
	GQM363d60IlUl5AOm97ZpUPLe658Yt74L+DCI+ZFG2wthHLklKSYrFZawo+/6+CXYWQPUcH76Wu
	cx5FYXh/loo18Ux861Bngfyzc+dM96WCcjPWjj51hpoTHRKaNIUDsVdh4DTQV0Bo=
X-Gm-Gg: AYBFou1pjLgBuJQso8SLAt6+cmWjStzs3saxSdZu3AOiCQxGY1iZfh+D8XvEg+nqdXy
	PuQU2+lEf3bQ/tyV91xkHKKxGoHN/ybhPqerAitTLjzEYRcBiS4WDqMi20AN7X2NQe6GtAgUXWw
	K1zDqvu05MutiIMsua1qqsCnagcrdgtRjL0Wc7eyUUHh1wJYbVDuYS+z+m+DEZh1x1DW+SE8Z2G
	2m54LEaaQSQLhltyGFIxVxAQEvf2wHpYzF6yeKmVQ0v5hf/GR8upEePkHazmbGFhzXeAmjWj5Fo
	9penUNlKxpAMX789O7e4oenHJsbFrun7zXd5VTtsdCL3P+pFM9lCghhD8xG2OXbzX3h1hoeZ9+t
	+0Ua0iBGGYKpGL7c/6f8SfdgzQLTwN2PzaCcscFKfM0ackNZSarguvUh83ne3o6LZcdhvXxjrSg
	==
X-Received: by 2002:a05:600c:8105:b0:4a1:775b:5eb2 with SMTP id 5b1f17b1804b1-4a18e48362emr231673455e9.13.1791887971581;
        Tue, 13 Oct 2026 03:39:31 -0700 (PDT)
X-Received: by 2002:a05:600c:8105:b0:4a1:775b:5eb2 with SMTP id 5b1f17b1804b1-4a18e48362emr231673005e9.13.1791887971189;
        Tue, 13 Oct 2026 03:39:31 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0967affsm3971206f8f.1.2026.10.13.03.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 03:39:30 -0700 (PDT)
Message-ID: <d19cbf9f-a5af-4fe5-9c20-eac1365afb92@redhat.com>
Date: Tue, 13 Oct 2026 12:39:29 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/2] net/mlx5: HWS, fix reformat release and meter
 offset
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261007143830.1733583-1-acassen@corp.free.fr>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261007143830.1733583-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/26 16:38, Alexandre Cassen wrote:
> This series fixes two issues in fs_hws found while offloading one tc
> rule with its own encap and meter:
> 
> - Releases L2 to L3 tunnel reformats to the pool they come from.
> - Makes a rule select its flow meter within the whole ASO bulk.
The actual impact is not clear to me, but given both looks broken
from the beginning and Linus pressure for smaller RCs, I'm tempted
to move this to net-next.

If you disagree please scream it loud soon!

Thanks,

Paolo

