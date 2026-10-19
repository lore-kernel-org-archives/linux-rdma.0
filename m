Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792430405;
	b=VXZDgoAhJe4kAiXSvMEvwdyohpImFXVij1XSX62+VxhNBfHUZlxTh7ityCO1OWi6RibO
	 TJ0nC4zMlLFTnWOpnwdj/EZVD4V8lbDRMzV9Yf4zc24caSrYMWSVd3KS3ek0T9nYzyAmq
	 U9+T47luevDckfqL+pQxf/sKic+h6fRIdoEGRBVMvoEJBfIdO83vJDd4wZhydTyNDUSHP
	 9p9UWz8XaVvMp2CU+FZZrsZYr5US6tcl7nhvPs0m8qQ9YmcowXtLDu3REFu0wyd7VFtLK
	 JlG6VqH24ne/T8sRxCtjFtfnPZ6hdrEV/zAPW+EhaxggVKKCoNrId2fZGAnjbz8ykdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792430405;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=NZLIGIiPN0hTXUeW4qoosN9u/LtYMyrcbQzE3iavz+s=;
	b=lnD3kVr1np4J3ssogXwhGK3ViFBH8JwRg/Zh6fc9GytW6bUbuCUXB/u4ZWFV2J5QV3g7
	 3Yn/6Qy1d3BPotYTdUIfNBhzVEsnzsAk7+c/Joa6MnDbIUYwY5JZLrOywDW3h58rP7iwL
	 2T8RGHZ81SXqidc+axu2ysTOsokXQk+V6h3oPZ3RuB3QZ0qAy8DuIQCFxXvP+WRQYLZyJ
	 A2xwOAQu2maFYKlyKeyMNJYHTi2u0+t2oXChb2hzNDZkRcioeV7pToeLdN3Pxxxg1qzzz
	 qkQVngZQckvb3qnmPPklCdytVXwy4ZJ1ZaJr5Ry8Q0+3c6COd47hhuE4Y9thRGdokxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="foeSi/Mj";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178E7606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 17:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 178E7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=foeSi/Mj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792430404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZLIGIiPN0hTXUeW4qoosN9u/LtYMyrcbQzE3iavz+s=;
	b=foeSi/MjvpmnyyF54mdZ9svtNAraVYhqJerI+imQvixWURmoiHUnAhIl+EXKwPoI3Cz+fa
	nFzI1nSUhTs7a+82vQwZQ0Vy6JXWjl/p8h09tjTe5kRa2L0q6KfNNT5a5tP3mk3hO0iRRv
	1GIJ/tHyt0ILGDcKA6MvI5bDeszTqYQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-0lDsr6cSNI2FmoY6_iU2LA-1; Mon,
 19 Oct 2026 17:20:00 +0000
X-MC-Unique: 0lDsr6cSNI2FmoY6_iU2LA-1
X-Mimecast-MFC-AGG-ID: 0lDsr6cSNI2FmoY6_iU2LA_1792430398
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49DA71955F7E;
	Mon, 19 Oct 2026 17:19:57 +0000 (UTC)
Received: from [100.91.101.41] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9995F180057F;
	Mon, 19 Oct 2026 17:19:52 +0000 (UTC)
Message-ID: <98c195a3-9cf4-4d4f-80c2-5186055454fe@redhat.com>
Date: Mon, 19 Oct 2026 19:19:51 +0200
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
Subject: Re: [PATCH net] net/mlx5: DPLL, fix fractional frequency offset
 scaling
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
 Carolina Jubran <cjubran@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jiri Pirko <jiri@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
References: <20261015074035.1092340-1-tariqt@nvidia.com>
Content-Language: en-US
From: Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <20261015074035.1092340-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/15/26 09:40, Tariq Toukan wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> The frequency_diff is reported by firmware in parts-per-trillion, which
> is exactly what the DPLL core now expects from the ffo_get callback.
> 
> Commit bc443c253fcd ("dpll: expose fractional frequency offset in ppt")
> switched the callback contract to ppt but assumed frequency_diff was in
> ppm and scaled it by 1000000 to "convert" it. Since the value was
> already ppt, this makes both exported attributes wrong.
> 
> Report frequency_diff as is and let the core divide it down for the
> legacy ppm attribute.
> 
> Fixes: f035dca34ede ("net/mlx5: DPLL, Implement fractional frequency offset get pin op")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
It’s a pity we didn’t implement FFO in ppt units right from the start... We
wouldn’t have to carry a duplicate attribute in ppm units now for the sake of
backward compatibility.

Anyway...

Reviewed-by: Ivan Vecera <ivecera@redhat.com>

