Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E5F441031
	for <linux-rdma@vger.kernel.org>; Wed,  3 Jun 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780506747; cv=none; b=BEVezQWW17oAGfOTRPSnZ67wRV7FYCZ/cRixBRJP35gyzFk+z6Xto/tgmyDCtuTekpppkjuAxe/jT0bMgK8WNxrxDufGZB5t4IBHLdHpZRWsnyl2WcXMIkEoigfbBHdHvgmFuYcQAZ4qS9UEKJ1EF1u1AJ1u9Psiw5xSz0iC/zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780506747; c=relaxed/simple;
	bh=TN5VN5nZYGpZ0cgk6I+DWPRMt4OBymg3kF+L1ZSTg10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VkMI3MCE/QAe/5sMwLmkGmz9OLqwBBZuSw4mYNuTnhIFUTj5cYS/cftcg4UF2rABotdyq2JCLdCOo/5ghr73s4GoCWp5CIxjBPgZbnkde1YSCYabIuCkgch7hZg1xyMoE8zJIPvhCG7GdIiK1IO/EhD93icShuEjTa8gCsDeImM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b=J43NUAr6; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b="J43NUAr6"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45eec22fab7so3689447f8f.3
        for <linux-rdma@vger.kernel.org>; Wed, 03 Jun 2026 10:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall.org; s=google; t=1780506745; x=1781111545; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WShIXeDXg6osn/1BPpnCqqp3TWGu+yv09MQ0gxlHZ/8=;
        b=J43NUAr6UxcD6FhnwU3H5ssro/H+8XGFqQJSoNhiMs3ztDp8Q8P4c0V4dndmvxoB9u
         HGLYWSSg/r/hz7VWdpSLHoZXMi9kTS9DtnC8iKQWzEpjAIUj+BYzxmxi4S7E5BSmqwfn
         rkkklpjH0ZOVxOShxgYaB4k9F71N8npU26s3nDsEymw6CQ+de50yUol829sxw9znEOKC
         tgW2CPTzcTc+wzz9f3pYS+fJ8gXhWlSeVPAGv2b87BtaKX8qFi/1JAVnIrRzksUXckom
         cGdxPwDy3l3pkO/Cv0IoLx3U0SLmT5DwSOr08RKc8RGcbYpX47iCv4rsl1mJ26oum2Oy
         koPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780506745; x=1781111545;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WShIXeDXg6osn/1BPpnCqqp3TWGu+yv09MQ0gxlHZ/8=;
        b=hIa9hcUk2uASF/oklzvGgg+Mbhp+aorItdxVfA7ov/rwp40/9GyWnpd5s2Cm45sg11
         TFxgz5gsVRH6Ny8D+XDcOmanZSOeQjSj9sr4ofEpHM99XT0IvcoL0JsuwCVygMnqt1z1
         r20PyHJ9W/po6yWvhLb3P8eZsSqddpBAff3yCYjV9wCETCLV6rNr2caVuP+51d9OsmLw
         Ik/vUSr+b8mg5eHei+p2DRZCVBj9wrA2o4BdiDluIpba3I6Ed2L9DhIxqHfC5sCA1soe
         xrPjMPd3fzjykLKET0vWyn94uljMmqxMhcuXoRp4P0A54zmMvF4DjPQg8cMUsoE70pX7
         IFGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/j4hWS++j8xdJVpU8YmSAP5Akwx2CzcxVtFX3rujPnDLkiS9w4Z6zWRThfEo/iRXbVXiImc6ATr4wh@vger.kernel.org
X-Gm-Message-State: AOJu0Ywekh8UlHqqhH+RP5oxXKF8Oq40EYmv6if6vR5s3gguDaSMluwT
	2OXfDNhZT1yyuANetBRPy4VG2LmO/UggpbYUT1+mjl+gQqX9f3FBjZoH8Futdwgb/Z8=
X-Gm-Gg: Acq92OHLwIbK6LyBme0m076HZM3paiMfIxoxD1GpuFsZmt2cWo+GUxuQhMT0ArZuR8/
	FQ5RkOesAexoSqQmFIDU3dDnsbU2MR4J2RvLt5phkK7psYtrRRVSExI8ylaGXumNKyjpvg0DRbg
	69f9GflMjfLOYF6n/tERmSvIglxhJi2ntjm92nzGYG63hplfV/cmLxSST9l6kQP+fWHEzGDR6Qa
	PnD7OV48vYw0iCbiqrrDhQE8F+YivN7JYlmH2BunUpr7VVZZCRAADs+1aV5NS7UTaM1aEG7sLkI
	3HVIiBjOJg5sq2qhjreKFsOoh5ql9Pr/h/be6BmokP/giy4bjDtftzBQJqhGvWbhAD7br/GYdEq
	8kaFJP1OTZlhuwjybYL4TgMx3kDBJ9BOmB0SpEYZXyp3D8AREVUPJ/BH66Gusrr3i7fMhJ3dplk
	uwXZpTakXUIOIucB0vwmhYuWqeyT77G83nuSKzOnwH560oJo1x+dq9V7cCQKSDYt3F
X-Received: by 2002:a5d:5f8c:0:b0:45e:f29d:d42d with SMTP id ffacd0b85a97d-4602181eea2mr6197828f8f.25.1780506744671;
        Wed, 03 Jun 2026 10:12:24 -0700 (PDT)
Received: from [192.168.0.161] (78-154-15-182.ip.btc-net.bg. [78.154.15.182])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm8997419f8f.9.2026.06.03.10.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 10:12:24 -0700 (PDT)
Message-ID: <b087dc20-7398-4ad3-9787-efef883d81b1@blackwall.org>
Date: Wed, 3 Jun 2026 20:12:22 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V3 0/2] devlink: add generic device max_sfs
 parameter
Content-Language: en-US, bg
To: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>
Cc: Jiri Pirko <jiri@resnulli.us>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Mark Bloch <mbloch@nvidia.com>, Vlad Dumitrescu <vdumitrescu@nvidia.com>,
 Daniel Zahka <daniel.zahka@gmail.com>,
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Arthur Kiyanovski <akiyano@amazon.com>, Petr Machata <petrm@nvidia.com>,
 Ratheesh Kannoth <rkannoth@marvell.com>, David Ahern <dsahern@kernel.org>,
 netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Amery Hung <ameryhung@gmail.com>
References: <20260603102646.404797-1-tariqt@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20260603102646.404797-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/06/2026 13:26, Tariq Toukan wrote:
> Hi,
> 
> This series by Nikolay introduces a new generic devlink device
> parameter, max_sfs, to control the number of light-weight NIC
> subfunctions (SFs) that can be created on a device.
> 
> The first patch adds the generic devlink parameter and infrastructure
> support.
> The second patch implements support for the parameter in the mlx5
> driver.
> 
> With this addition, users can enable or disable SF creation directly via
> devlink, without relying on external vendor-specific tools.
> 
> Regards,
> Tariq
> 
>
Need to rebase due to commit d603517771d8 ("devlink: pass param values by 
pointer"). Sorry for the noise.


