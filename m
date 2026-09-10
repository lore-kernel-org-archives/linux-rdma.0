Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5393946EC88
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 11:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038501; cv=none; b=N5EoeKrnlxTjApnqjxFMEkI+iwJUH9vL5Jv8AUeHm2Sb0HbcDSftPgwbQek5E1GtzwxiDZ+3jWHpdJaUi+9K8cLV6ycP+yYVx0LK5BfIrbMpDJ1bh4+ZHEx05LVt+EZ+wYVXDZ1lNmo3olev1YgYLiw/ORJCLXk/9AOZKgrd9ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038501; c=relaxed/simple;
	bh=A81B61BRd2x1sSFxHm+OOFOqfMYEtzRTvPX8AsEKQ68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y78tCHDV3/C1kYwnRvFfcEBUMBQDR/dE957D21DJoHIlueOFefyABJbhyj2R2fAGlaJJpZdmyMRSEF56KB3g6L/omilpfZ82oe1GVg8lF6RvqPovrtUgwGCbcpLcMVZOqaZdYS8nfdYnQ9OjUUKAj9QQ8KHQf9nB5Ah8z6eUD3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GXCzdXsG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tj9stkns; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GXCzdXsG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tj9stkns"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789038498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8CFytEdCGSTDyDlAvIjNaZjMoqpFkxgcAOASoLn7Aw=;
	b=GXCzdXsGt3Tm6bIMvQicEdaGpzuw8C4qTESujXNU4QtJffPDicfkCsORCihli+6HIUDMnt
	YO6O+hDaOT6BFDaAzKeVMXLE1a4vJsMowwpo3nf6QTCmm+YTSA3H4A4VBzzXZ2lHrPXedU
	ITzXSwHIlorEy52nx7gdG8b8AWHoH7k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-IQlSTZWaPI-OsW5RkWaVyg-1; Thu, 10 Sep 2026 07:08:15 -0400
X-MC-Unique: IQlSTZWaPI-OsW5RkWaVyg-1
X-Mimecast-MFC-AGG-ID: IQlSTZWaPI-OsW5RkWaVyg_1789038495
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4994cf6cdb9so50018155e9.3
        for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 04:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789038494; x=1789643294; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G8CFytEdCGSTDyDlAvIjNaZjMoqpFkxgcAOASoLn7Aw=;
        b=Tj9stknsmFyLalVHTz5fsL97nKqzThx/BaJqmTTbj/KBmvVG+40t2aj+eSlPmrcT5a
         zY9Ifr0XDyhby2a3z8eiewXGSEx8k8XsQCSz6Dtx8IOq6TJvNDfuZa3t5sUXI1n9f2+q
         x+w+YkWLD6ei1/hs4FhgryyNazsqt+S2MUs+dEoIRyQrgdlzN2q11zk8KtOhrgq99MSp
         COJiRTzLxvN0AycQs2BS+izAB3OECARKMEgfKMIJYS2Q+V2BxP0kQqwpfv9lrH9LXeUe
         G/kI5/sNhcqKOmTUbL0nSOT0bocQRHWmFdlujDkTL/z735+GZJ5v91QDaMa+MDRNENqt
         aCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789038494; x=1789643294;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G8CFytEdCGSTDyDlAvIjNaZjMoqpFkxgcAOASoLn7Aw=;
        b=IGe0by6hwVZpLCT0bSmS6rxgU/N0vTLRq/6ovG26waX5T8h+JgtJhL2fWU3T/M8Fo6
         USU4upOwPxHmhtY4DozuxkBE5dmXKDVURl+v1IAHe817EXHWyzmRRO5Sr9pp+q9UYy3u
         92I+QIXQnz9m9de1d169YD3arvRGCL/XQ327bFTt9meAcmPEacPRYKoCRwdDnQjaPhhX
         9tjTMhJ3JJZaqrxD6cZavYLt07ezTYydjGkTtWFjnzS4IE4EyxZ6TRLcSSYlvxnfPoLe
         K89YrJdYZ1cSsh12ho4x1vUFbl+JlI+LHA+pgvLhWGXCoZQXHaXxfJ7F92Bm8nPz2Bof
         Zs+w==
X-Forwarded-Encrypted: i=1; AKwUvBxTja3iil4yBVABlNl9JnuTK2DVRmMpAklNE3F32x0ndTXHMHbU6zckDjblceMQ+YLwKCJBD1VbY96E@vger.kernel.org
X-Gm-Message-State: AFuF++nchWF9CnzyeZr/ZHy13sy3tJ8u0YAnB1FIiAtZq6lo9xbGOf2E
	HT+rgJrwVxmuNZG6OZX2HZ1Cl4HUP3mR1SSpcOqv6e6OXLbUFaI9wWjFrww7SGfdMHPPxuDl63p
	5eZCGj77hduC4eMBs3+DIsO8gp5a5bCmHDGnODR8US/yltuF/LDN+4pGzKreE514=
X-Gm-Gg: AYBFou0AkG09HCjsZtIaMiEVgH6MQqVCgSCweopfikfcvmnEk2oUcrsqXNnT8lVY4KD
	m13sdepmF1hZPsq+a8oxQjkKkSk/kR9VGesTlCqV7g159FDwQfvHVo3rH4QPVUgmWencUt26AJV
	mGQugM3JXZzAri3eHgw4xeLiMnvKt65Noue9JJn4Ww1uNzJHRfQ//Q/+esMo6nlPNqFJJvAvcwV
	l7vePw6AQs+CaX/wiylJKIZh5s07shOz68lmsqmC9FvXBWDrI+psu73SPYVNFOwGhm+GJFNY/CF
	I/Qn0bZJwXwDA+BNSDIjqkZOyRrvAUeMjNB5QR7qczJlnW5eQ4PmW93Sq9KC+AW1SGOHhSifAxR
	DDFdQrZy7sSjQOLLLlTVe54DymOJ5nj+HxPP47aR6pPALk37MfkzoUlxTZUpE140bXINg+FjaVg
	==
X-Received: by 2002:a05:600c:4e8f:b0:49d:4ef:bf70 with SMTP id 5b1f17b1804b1-49d04efc043mr317131995e9.10.1789038494561;
        Thu, 10 Sep 2026 04:08:14 -0700 (PDT)
X-Received: by 2002:a05:600c:4e8f:b0:49d:4ef:bf70 with SMTP id 5b1f17b1804b1-49d04efc043mr317131425e9.10.1789038494197;
        Thu, 10 Sep 2026 04:08:14 -0700 (PDT)
Received: from [192.168.188.218] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485881353e8sm50339161f8f.1.2026.09.10.04.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 04:08:13 -0700 (PDT)
Message-ID: <54c3768c-ba5b-40f8-9fd9-d2e628c0c592@redhat.com>
Date: Thu, 10 Sep 2026 13:08:11 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 1/4] net/mlx5: SD, serialize SD LAG init/cleanup
 against LAG mode changes
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Akiva Goldberger <agoldberger@nvidia.com>,
 Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>, Simon Horman <horms@kernel.org>
References: <20260906071332.3759199-1-tariqt@nvidia.com>
 <20260906071332.3759199-2-tariqt@nvidia.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260906071332.3759199-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/26 9:13 AM, Tariq Toukan wrote:
>  void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> index 4cdc50cd6f03..99cf455a61e1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> @@ -345,7 +345,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
>  		return;
>  	}
>  
> +recheck:
>  	mutex_lock(&ldev->lock);
> +	if (ldev->mode_changes_in_progress) {
> +		mutex_unlock(&ldev->lock);
> +		msleep(100);
> +		goto recheck;

My reading of the clashiko report is that the above introduces a
deadlock.

While I agree that the fairness issue raised by sashiko.dev
could be deferred to net-next, I think we must avoid introducing
the mentioned deadlock.

/P

