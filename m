Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4063BBA1A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Mar 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774015008; cv=none; b=KBE7UlfRGFEbsck2fgk6IbOs/+d8sVwHJL0doTdxsoa3yNK/SUcW58glm2qkUXc5qky0IqBryUJLZT32Rn3BMPVy9z2mr58ki4lGDcFrKQqnemmRggb8Mhockt2lsKnil4K5ztLhIoBpNKuSyJlFIc6VvB01XX5sO83q4Sv4gUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774015008; c=relaxed/simple;
	bh=/wlqIjZIgwdkMI6K8TvPimSH17KMGKOIboXJZ/EjwGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R4ptmutkzGa1hKw1myC7Sc55RuahKblcoMMopUKuHgneHn9ztEwiEV+Oibnx+NG2Fe41e0a8AmO31M+vsoVBJCT4SH8yBQBdbtreWXCJ7mwjFSLugfQKslKmDXGqCR+RSYLEUfCwb4sX5Acuqp/FfqZHSUEjKV9hqF3hPqtZ8Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vCsk/N6u; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vCsk/N6u"
Message-ID: <dc60adb4-9b35-4016-9898-dd81ee359333@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774014991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2Pql+Ou9gVCW27sbcKkrqRNsfCX7zCBKdUFbxvC7JU=;
	b=vCsk/N6uKf42oNAiSkE9qJ0OX36btVd8xUqhnrtvJpOJlvf8F/0HFRJmiSh+6DVrTQoUB9
	4Mmslc218N58INAkIynr1OFJP/YqXQ3fpziXk7qpQgAkhNEQ+BJSPsUEvxNg+65xQoycF2
	AOmcdUFC+lMWc/CKe+8LBXAr6ZeExg4=
Date: Fri, 20 Mar 2026 06:56:26 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 0/4] RDMA/rxe: Add the support that rxe can work in net
 namespace
To: Leon Romanovsky <leon@kernel.org>, jgg@ziepe.ca, zyjzyj2000@gmail.com,
 dsahern@kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "yanjun.zhu@linux.dev"
 <yanjun.zhu@linux.dev>
References: <20260313023058.13020-1-yanjun.zhu@linux.dev>
 <177392137151.816693.16033033040849071915.b4-ty@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <177392137151.816693.16033033040849071915.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/3/19 4:56, Leon Romanovsky 写道:
> 
> On Thu, 12 Mar 2026 19:30:54 -0700, Zhu Yanjun wrote:
>> Currently rxe does not work correctly in network namespaces.
>>
>> When the rdma_rxe module is loaded, a UDP socket listening on port
>> 4791 is created in init_net. When users run:
>>
>>      ip link add ... type rxe
>>
>> [...]
> 
> Applied, thanks!

Thanks a lot.

Zhu Yanjun

> 
> [1/4] RDMA/nldev: Add dellink function pointer
>        https://git.kernel.org/rdma/rdma/c/fc3992d6e1e9f8
> [2/4] RDMA/rxe: Add net namespace support for IPv4/IPv6 sockets
>        https://git.kernel.org/rdma/rdma/c/63ce1810c841df
> [3/4] RDMA/rxe: Support RDMA link creation and destruction per net namespace
>        https://git.kernel.org/rdma/rdma/c/6d8756013d0e24
> [4/4] RDMA/rxe: Add testcase for net namespace rxe
>        https://git.kernel.org/rdma/rdma/c/a4f4c76c90c53a
> 
> Best regards,

