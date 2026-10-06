Received: from mta1.migadu.com (out-111.mta1.migadu.com [95.215.58.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851FA4A0F01
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 18:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311620; cv=none; b=SfipYcYLaGoFkg9bIGesAvrO1PktDHjF6RWVBXyFlxCzwhcb/dzITdaSLsQ28iQbAbwupf+ICi4wy98SEL6TNpbenTTxvOtb7/zXb8YqzrwIYTTyEChmZD9FYlrrtzo+CxGCdpQwoLZaGMWiQb88USJZSgj7k7meDhdqMT4LRPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311620; c=relaxed/simple;
	bh=aRm13KgCPHCqrCDwUXNNbA7tdSwh8tT+wi1DVUaShbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ncBabiTHxVlT0lma/VdBzdDPhvsW7k80WsAYx5UjxChdQM/6uTZiVb9jcRzN3dyQUfCWwNGRQN7rLa1abt6HyOcbPE96QVxdyVUeAwByDAoifw/pfOnRZXr5YV5h8nZ7jHThGgqdCLVWlfDoIq+e5w6KFWQHnZ727kDt1Y0qlyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RL6VSK+1; arc=none smtp.client-ip=95.215.58.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RL6VSK+1"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aRm13KgCPHCqrCDwUXNNbA7tdSwh8tT+wi1DVUaShbQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791311615; v=1; x=1791916415;
 b=RL6VSK+1qqhZ5RIwJBNrXNuaVFdtzdLDVVc0kdpPCGztWbwCOCBdoWeWvOp0eEGfA90IWRNu
 Qy5k5sDUHP1U13T/o7WsSssogW2uuPUUzwciZD0+B1fE+G44JIcJ7Xnqc+opU5CwLmCdHavACep
 n5YV2XIHSlpSxVCO+fmyC3Ag=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1e8a5f9465db4ef6;
	Tue, 06 Oct 2026 18:33:34 +0000
X-Mizu-Trace-ID: 1e8a5f9465db4ef6
X-Migadu-Flow: FLOW_OUT
Message-ID: <1c9e50e5-7c90-456b-838e-413e8b1387d5@linux.dev>
Date: Tue, 6 Oct 2026 11:33:27 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RDMA/rxe: MW rkey authorizes accesses outside the bound
 range
To: Greg KH <gregkh@linuxfoundation.org>,
 sungbyeongchan <tjdqudcks0424@naver.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, security@kernel.org
References: <20261006091105.827719-1-tjdqudcks0424@naver.com>
 <2026100616-supper-uranium-6500@gregkh>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <2026100616-supper-uranium-6500@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/10/6 9:22, Greg KH 写道:
> On Tue, Oct 06, 2026 at 06:11:03PM +0900, sungbyeongchan wrote:
>> Hello,
>>
>> I found a memory-window range authorization bug in the RXE responder.
> Great!  Please submit a patch for these issues as you have a reproducer
> and can test them and that way you get proper credit for resolving the
> issue.

Please explain the problems in the commit logs and share the reproducer 
program with us.

If you think that it is not good to share the reproducer program in 
public, you can share it offline.

Yanjun Zhu

>
> Also, no need to cc: security@kernel.org on public issues like this.
>
> thanks,
>
> greg k-h

-- 
Best Regards,
Yanjun.Zhu

