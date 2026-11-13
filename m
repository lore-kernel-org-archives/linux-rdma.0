Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558856;
	b=RHH4VzGX4fyefTjlX+xQc39WOxvgI68N1ndBVlpgAxa0ZAl3zUSbuzoI7gsW/notAArK
	 ByXBbapP0HUFdH3E7MmffH4QqC8RW/x9FJ8aRVCwybBalwvqi+xZpc5OGui0AE9JLMoBu
	 e/SysPrOtbG0fsk7d21JnbgWcdevDpm3rVWd8DhHlJF6I3h/RAqTPOK+2RAupO/83nhRo
	 6Yxk9dwgU+VsuZ4N/f3hEviquzWFyols4/5WAprAPuPXB7hhzAp4z/oAKGGfm9yqIjvOK
	 kls8aMM6zBG90pJynmHCTKv4HKibLr4nSzukoyNAa2h0aApQQXOEcgoBfO21mK+p04w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558856;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=PqlGlQac1A9N90ytvOpZM4/ZXGtYzdUrvraQxFDjpTI=;
	b=x0H/ji7syxnAKfLbHCnHcvkSUrGB6xcyuqMsm1d4Abd/ukPSsOaCRuCT2Lr5YB7xZR2I
	 n2k1kvYMyZhwCYgnAi/P/Lrwla5JSofqER6heZyyiDq1eealbKrD/frTBKuOOYD5EuCGu
	 lbQnT8aCYX7iWur1kr06IMe5/Grr+cNOTHUJJWAe9nl8P6xxgMKHIsT5i4ku3Ut/FsCl0
	 byH3ruBh5GD+SVdnY5tmtxKQzonbtXTI1jcEcKGjOqhUkgH79kiGPLghXmE3CCwsYAs5i
	 WOOdDaIiqqysqcFv82PFHTEZF59KiBlV2Cjz6KePHUTys1OVSu/f3u+AcNMrDNSjjCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="mr1FJ/U1";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE9B606A338;
	Fri, 13 Nov 2026 08:34:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BE9B606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=mr1FJ/U1
Received: from [10.26.7.43] (unknown [4.213.232.19])
	by linux.microsoft.com (Postfix) with ESMTPSA id 465FB20B7166;
	Fri, 13 Nov 2026 00:34:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 465FB20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794558851;
	bh=PqlGlQac1A9N90ytvOpZM4/ZXGtYzdUrvraQxFDjpTI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mr1FJ/U11L6/0Syh44CR6HPl52bAyo6Kzg9D/BAgOx8zTtJ/Np5/GAG5d3yn2hkHH
	 vHLqLD0hEm1yc/MPMObiiwtrhFt9xg07aceKwWJ7ap8whlTdQNo6LeWf1uhpO1uoIQ
	 /i+Og+wxX61FJ5loIU0qmLjvUekpu3h6PNvFjUkQ=
Message-ID: <fc2ae552-86ee-40af-a997-454c2d3b176d@linux.microsoft.com>
Date: Fri, 13 Nov 2026 14:04:08 +0530
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
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <avWrMQK_DuZ1hAwD@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12-11-2026 17:37, Breno Leitao wrote:
> Hello Sahil,
> 
> On Thu, Nov 12, 2026 at 04:57:18AM -0600, Sahil Chandna wrote:
>> Implement a graduated recovery approach: on the first TX timeout (or
>> when the previous timeout was more than 2 minutes ago), schedule NAPI on
>> the stalled queue's TX CQ via napi_schedule(). This triggers
>> mana_poll_tx_cq() through the normal NAPI path, processing any pending
>> completions without relying on the interrupt and recovering
>> missed-interrupt scenarios without queue reset.
> 
> Which interrupt is being missed here?
> 
Hi Breno,

It is the TX CQ completion interrupt. After NAPI finishes, it re-arms
the TX CQ. When a new CQE arrives, the hardware post EQE, which raises
the MSI-X and schedules NAPI. If that notification for the TX CQ is lost
, NAPI never runs for the TX CQ and pending_sends never drains and the
queue stays stopped,  so napi_schedule() polls the CQ, reaps the CQEs
and re-arms it.
>> If any subsequent TX timeout fires on any queue, within 2 minutes of
>> the previous one, escalate to the existing port-level detach/attach
>> reset, as the CQE poll did not recover the queue.
> 
> How was 2 minutes chosen? mana sets watchdog_timeo to 15 * HZ, no?
The watchdog_timeo is TX stall timeout setting i.e if a queue remains
stalled for this much time, it trigger watchdog timeout. Here, 2 minute
is not timeout/wait. The 2 minutes here is for deciding whether a new
queue stall event is a repeat of the previous incident or a new,
unrelated one that should get the cheap poll first. For e.g. if a queue
gets stalled, 15 * HZ sec later, timeout occurs and this patch trigger
manual NAPI, if another stall occurs (it can be on any queue) within 2
minutes of last one, the existing recovery mechanism of mana
detach/attach will be tried.The patch is adding a first level less
destructive recovery first.
For selecting 2 minutes, I do not have any hardware basis for it afaik,
but I can confirm and check with our host team as well.
Hope this helps !
Regards,
Sahil
