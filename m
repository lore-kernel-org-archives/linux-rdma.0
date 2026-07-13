Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738662D2381
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783945584; cv=none; b=bYuHbwkWKUe0BvaG/eTahK3+2mg876DCvV7GSb9gxLarm0d8w4JG5mcixKsMB4sUuLFu/BAYMdfWs+2y4ATLfyPIzjz7qMuGAbNTksM7yv3iPJN8chaR5HgYp0/NBZhh8D5SSJJ5ctHJkIxid3xlOB81LnbYa6ENvHiPkd30MhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783945584; c=relaxed/simple;
	bh=0k4Gkc2lSaNlg3yelePb+YUuOKPa2uEegCxdpabFhF0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ByQTG7dbWbgCEpG91Hq3PCF+xFAcQS2vsHxRAjFJQl92E8GRpn88ntRy+ZiEt02fwhoiV7SEF/n/iMvLrPH71h4Wmt6l6OHvqzl5X3KGGZGUo6A0+7J9GtAksj254mFLpVwImjXUAinRTluZ81Nvz3VQc/Wmi33GoSfbGttcacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W2tAy5hL; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W2tAy5hL"
Message-ID: <f16a6ca2-c528-471d-83f7-8327a3d9bfbc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783945579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=21Y5q/ufuGUVxfworezwmSuvfxf6tIT8XyWioTVY+/E=;
	b=W2tAy5hLOR7PJmBMxdpQ11rwhZcbENOjxGhuDmixuEmr5SApAqrcST66rdJTM7ukRqUKCa
	h88LDWojufEhQ8HpN2yo5Q6pF1pmx44scF+xt2QrHkuvmBLgytudC82nURw515EwXPmhLK
	BliUeHnCwNT3Zi+99/wAr9VO8/8Vb5U=
Date: Mon, 13 Jul 2026 20:26:09 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, dsahern@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH iproute2-next v5 1/2] rdma: update uapi headers
To: Leon Romanovsky <leonro@nvidia.com>
References: <20260710011759.378893-1-cui.tao@linux.dev>
 <20260710011759.378893-2-cui.tao@linux.dev> <20260712090325.GF33197@unreal>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260712090325.GF33197@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/12 17:03, Leon Romanovsky 写道:
> On Fri, Jul 10, 2026 at 09:17:58AM +0800, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Update rdma_netlink.h file upto kernel commit 5911f6d6e7ce
>> ("RDMA/nldev: Add resource summary max values for usage display")
> 
> This SHA-1 is incorrect.
> 5911f6d6e7cc ("RDMA/nldev: Add resource summary max values for usage display")
> 
Mhm... sorry for that
> Thanks

