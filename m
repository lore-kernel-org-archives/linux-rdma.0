Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794993905;
	b=wbDxYoqd0xQHku6piz1G6rOIHIKZD758S3m9excd2Ey3Oup8zJT6/Hh66KXxMh30NppU
	 uGMoj9uUSeiTtXDjf+2LkmdZ13P9rPFYw3JZdamo8Q7oUz2qL6OaDngnoyfOl2yZbopnr
	 ewu1uOoc6DjtAcZg7pho5EhH8/dageoAftYOUfxfu9RmHIVlDJOXrwMAQ9PEn5VjlzZa4
	 XVGzi8t6qkVI3zhbCRS2xOmeSjhj6erajpQlaAkpZFruGmiDGiYluTAeN0adIzl6pOmNz
	 UMgvkUxQmNrJwoWSbJUP04aPQ7FnkdC1y00eleJwyKGw5zqiT4AE+pV3DXo0v/bXk2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993905;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=k4+R43wkQ5coZwEY7y2Wgwoj0XAwBzUTWTsiGrCMIT0=;
	b=0wLx6LZoUHc1e8D+CjrruphUN22lyFtOPuiIX4EFjA/jbB9Q5u7a/Nfz0z0v7UXNKj2Q
	 PPwLuXFCueLiSe7vcswVOZE2ujiUX942OqP9ihr5sHseqdgjweO98Rqx0h1Ed31phaAfi
	 TrmsC3Aid9+j5uVcYxgojmuWiiu/UGCiy7OQkeuID1zgefPb/fXWX6L4J5I0LzCBI6HI/
	 27Q9a1fdaYprrCORsgfu2Pcv74FKEfOsialVjAU2RZYv2fmZpqgn9nPsK0YWuW0mPb/uy
	 LtEOmLYvANiNaWw6UomgvYllEJwf9PKAlAuX3dI4AI+P3+72rabn74KygikIkEBsviA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="M/Dw6inN";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E88A606A31C;
	Wed, 18 Nov 2026 09:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E88A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=M/Dw6inN
Received: from [10.26.7.43] (unknown [4.213.232.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id 996FB20B7169;
	Wed, 18 Nov 2026 01:24:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 996FB20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794993903;
	bh=k4+R43wkQ5coZwEY7y2Wgwoj0XAwBzUTWTsiGrCMIT0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M/Dw6inNHz55R75Vl0dUx8c1XG7vMvdfPiYaAdYX0UkRIq93SU6DVHfSG96WyVPW1
	 fe0YQFyR9Zh9HiuM2pFWjrQo18F80YdyTozEf5VCK4apalCthdahp9zhekAcAqJ7WN
	 3yNwzPrlDjcytOKWsiRVL+QjP9kzjYwU5yYfq3hM=
Message-ID: <d739628d-ae56-4543-b15d-a7976ab8f92b@linux.microsoft.com>
Date: Wed, 18 Nov 2026 14:54:58 +0530
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
Subject: Re: [PATCH net-next] net: mana: Add CQE polling as first-level TX
 timeout recovery
To: Breno Leitao <leitao@debian.org>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 gargaditya@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
 <avWrMQK_DuZ1hAwD@gmail.com>
 <fc2ae552-86ee-40af-a997-454c2d3b176d@linux.microsoft.com>
 <avbdPt1WSC9qEuYw@gmail.com>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <avbdPt1WSC9qEuYw@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13-11-2026 15:46, Breno Leitao wrote:
> On Fri, Nov 13, 2026 at 02:04:08PM +0530, Sahil Chandna wrote:
>> On 12-11-2026 17:37, Breno Leitao wrote:
>>> Hello Sahil,
>>>
>>> On Thu, Nov 12, 2026 at 04:57:18AM -0600, Sahil Chandna wrote:
>>>> Implement a graduated recovery approach: on the first TX timeout (or
>>>> when the previous timeout was more than 2 minutes ago), schedule NAPI on
>>>> the stalled queue's TX CQ via napi_schedule(). This triggers
>>>> mana_poll_tx_cq() through the normal NAPI path, processing any pending
>>>> completions without relying on the interrupt and recovering
>>>> missed-interrupt scenarios without queue reset.
>>>
>>> Which interrupt is being missed here?
>>>
>> Hi Breno,
>>
>> It is the TX CQ completion interrupt. After NAPI finishes, it re-arms
>> the TX CQ. When a new CQE arrives, the hardware post EQE, which raises
>> the MSI-X and schedules NAPI. If that notification for the TX CQ is lost
>> , NAPI never runs for the TX CQ and pending_sends never drains and the
>> queue stays stopped,  so napi_schedule() polls the CQ, reaps the CQEs
>> and re-arms it.
> 
> Thanks.  Which one gets lost, the EQE or the MSI-X?
Hi Breno,

Sorry for the delay, i was checking on these with my team.
Regarding what is lost here. The patch is trying to solve the scenario
where TX CQ never arrive due to some reason, it is not handling the
MSI-X lost scenario and one of the netdev bot comment highlights the
same. Though i will work on framing commit message more clearly in next
version. Thanks !
> 
>>>> If any subsequent TX timeout fires on any queue, within 2 minutes of
>>>> the previous one, escalate to the existing port-level detach/attach
>>>> reset, as the CQE poll did not recover the queue.
>>>
>>> How was 2 minutes chosen? mana sets watchdog_timeo to 15 * HZ, no?
>> The watchdog_timeo is TX stall timeout setting i.e if a queue remains
>> stalled for this much time, it trigger watchdog timeout. Here, 2 minute
>> is not timeout/wait. The 2 minutes here is for deciding whether a new
>> queue stall event is a repeat of the previous incident or a new,
>> unrelated one that should get the cheap poll first. For e.g. if a queue
>> gets stalled, 15 * HZ sec later, timeout occurs and this patch trigger
>> manual NAPI, if another stall occurs (it can be on any queue) within 2
>> minutes of last one, the existing recovery mechanism of mana
>> detach/attach will be tried.The patch is adding a first level less
>> destructive recovery first.
>> For selecting 2 minutes, I do not have any hardware basis for it afaik,
>> but I can confirm and check with our host team as well.
> 
> So the goal is to tell an isolated stall from a wider problem.
> 
Yes, and take just a minimal step to solve it rather than entire port
detach/attach.
> A port-wide timestamp only approximates that. It cannot tell the same
> queue from another one, and since dev_watchdog() reports one queue per
> run, two queues that stall together show up ~15s apart: the first gets
> a kick, the second gets the port reset anyway, no?
> 
yes, that is correct. The approach in this patch solves first instance
of stall on any queue with CQE polling and if that does not solve it
(based on another queue stall observed) go for existing mechanism
(detach/attach), but I agree to your point here that another queue which
stall after one queue had level 1 CQE polling would have a full
detach/attach rather than level 1 polling. I will work on this in v2.
> Could mana_tx_timeout() check this directly? Look at the other TX queues
> the way dev_watchdog() does (stopped, with trans_start older than
> watchdog_timeo). If more than one is stalled, reset right away.
> 
> Otherwise kick this queue, and reset if the same queue times out again
> within a couple of watchdog periods, as gve_tx_timeout_try_q_kick()
> does. That also gets rid of the 2 minutes.
Thanks, I will go through this approach and update in v2. I am currently
discussing this internally.

Regards,
Sahil
