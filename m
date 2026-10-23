Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792755568;
	b=PEI4nPdqGsMr21MdMCGwHEt+FweVP/UhXddVKik/4JT/xvNP9NvIL3I3jcf9lFt11FZU
	 XyiyGD5KtN9lCVTn3ccGxiVtC+FcjDOyl8q07fCEEDnha++dPUl7vaqSLBzsmrvDF01ej
	 acd0KgFcpmUiavh9JLm3EH7YiSt75Y0dzZhPd0RSVkaKslZtqwQSNigeBSD7p0lnZ10pH
	 i9S1qlIVNJSXBbQW6/6nXLK2C7IrkQh9vQleQOSVSB7n7D2Bh/vkCzeH1lSqQXLbCVSUp
	 Zizu4F2LUWkEpsVFLJKC3XU7Mw9QRDu8EwQQ6GxTcRaPjsz4yyvCHvQ0WLvpuq97MQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755568;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=vymAhzImNpIaaRDSE6vVjtEbhGC/HWEOd5Jc5ou0oRM=;
	b=GAeSMM6UOXqkylxBFypYLDHmKrMyDNiVBk+BYvnaaLhMGqFF1CvoE6U/MKg5RXLgvkXT
	 IYqAxRka7rL+XWgHpAkLJo7upnxu5UaoiQi+28sE3TaeImFSbaZl+pHz5/iMf+nj2aNwQ
	 /vY25CoQQBfRcCiCNM9JFNs1N33i5P++xoIQ7tHIeCxYxCF3ly+tv3ftclL1rBKFrTJd8
	 A3iinSLb8FQ/sz3aeATVlPUJbyfxjZWB463t1jGfnH+XfBezn9DgT/gY/UctGzSwzEulp
	 h38yIVEJVlryY7lc3AoUM5PPTKaguU85m7VhIigxLQDokRzpL2UYHyQJq18jzjecVxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=HZf8n3AI;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3336B606A31B;
	Fri, 23 Oct 2026 11:39:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3336B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=HZf8n3AI
Received: from [10.26.7.43] (unknown [4.213.232.17])
	by linux.microsoft.com (Postfix) with ESMTPSA id C7B1D20B7166;
	Fri, 23 Oct 2026 04:39:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7B1D20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792755553;
	bh=vymAhzImNpIaaRDSE6vVjtEbhGC/HWEOd5Jc5ou0oRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HZf8n3AI3ZnnksEkPTQnGbZXYh1kJnOmV1BzgOcquy7RV/ZqhdKeFcDL/+gd6ovZg
	 NJszsCGR7sSsoxxXetM9o0ZfNDMZdEYcilkvrrD1hKAKKMis4Xa3XMs8tPXlOcneVj
	 G4Id0Npr62RFpA4vphfAuXaJWRjVgnTL/6Cj+oMQ=
Message-ID: <466dfe8c-1071-4b80-8425-fcd52b9289ad@linux.microsoft.com>
Date: Fri, 23 Oct 2026 17:09:14 +0530
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
Subject: Re: [PATCH net v3] net: mana: Add support to process throttled EQEs
To: Haiyang Zhang <haiyangz@microsoft.com>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
 "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "edumazet@kernel.org" <edumazet@kernel.org>,
 "kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com"
 <pabeni@redhat.com>, Konstantin Taranov <kotaranov@microsoft.com>,
 "horms@kernel.org" <horms@kernel.org>,
 "ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
 "gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
 "mawasthi@linux.microsoft.com" <mawasthi@linux.microsoft.com>,
 "leitao@debian.org" <leitao@debian.org>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20261022145428.323576-1-sahilchandna@linux.microsoft.com>
 <LV5PR21MB47047DE99D8622E45CB41ECBCA652@LV5PR21MB4704.namprd21.prod.outlook.com>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <LV5PR21MB47047DE99D8622E45CB41ECBCA652@LV5PR21MB4704.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23-10-2026 01:12, Haiyang Zhang wrote:
> 
> 
>> -----Original Message-----
>> From: Sahil Chandna <sahilchandna@linux.microsoft.com>
>> Sent: Thursday, October 22, 2026 10:54 AM
>> To: Haiyang Zhang <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
>> <DECUI@microsoft.com>; andrew+netdev@lunn.ch; davem@davemloft.net;
>> edumazet@kernel.org; kuba@kernel.org; pabeni@redhat.com; Konstantin
>> Taranov <kotaranov@microsoft.com>; horms@kernel.org;
>> ernis@linux.microsoft.com; gargaditya@linux.microsoft.com;
>> mawasthi@linux.microsoft.com; leitao@debian.org; linux-
>> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> Subject: [PATCH net v3] net: mana: Add support to process throttled EQEs
>>
>> When an event queue nears full, the hardware coalesces the per-CQ
>> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
>> that carries no cq_id. The driver does not handle this event type, so
>> it falls through to the default case and is dropped. Any CQ whose
>> completion notification was replaced by the throttle EQE can remain
>> unserviced, causing its queue to stall.
>> The issue was observed internally and following Tx stall logs were
>> seen:
>>
>> 2026-10-03T05:29:01 hv_netvsc eth0: VF slot 0 removed
>> 2026-10-03T05:29:23 mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 45:
>>                     transmit queue 1 timed out 15133 ms
>> 2026-10-03T05:31:05 mana 7870:00:00.0: HWC: Request timed out: 60000 ms
>> 2026-10-03T05:31:05 mana 7870:00:00.0: Gf stats wk handler: gf stats
>> query timed out.
>> 2026-10-03T05:31:21 ens1: NETDEV WATCHDOG: CPU: 20: transmit queue 0
>> timed out 15859 ms
>> 2026-10-03T05:31:37 ens1: NETDEV WATCHDOG: CPU: 15: transmit queue 0
>> timed out 31731 ms
>> 2026-10-03T05:31:53 ens1: NETDEV WATCHDOG: CPU: 21: transmit queue 0
>> timed out 47603 ms
>> 2026-10-03T05:32:08 ens1: NETDEV WATCHDOG: CPU: 42: transmit queue 0
>> timed out 62451 ms
>>
>> Add support to process the CQs which belong to a throttled EQE of type 4
>> advertise the capability bit, also add a counter to store the throttled
>> EQEs count.
>>
>> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
>> Adapter (MANA)")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
>> ---
>> Changes in v3:
>> - Resolve race for cq in mana_gd_destroy_cq and irq handler using cq.
>> - Rebase to net branch
>> Link to v2:
>> https://lore.ker/
>> nel.org%2Fall%2F20261014134304.4177657-1-
>> sahilchandna%40linux.microsoft.com%2F&data=05%7C02%7Chaiyangz%40microsoft.
>> com%7C534992a49c0340631e2f08df304e3c73%7C72f988bf86f141af91ab2d7cd011db47%
>> 7C1%7C0%7C639282784768349454%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRyd
>> WUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C
>> 0%7C%7C%7C&sdata=w2NpUCx%2FCNtqeFQSR0fIMOYnbHLP7XsFl90sL%2F%2F7Y0g%3D&rese
>> rved=0
>>
>> Changes in v2:
>> - Use WRITE_ONCE() when clearing max_num_cqs and add RCU
>>   grace period wait during HWC teardown.
>> - Use synchronize_net() during CQ destroy only when the CQ was
>>   attached to its parent EQ.
>> - Use WRITE_ONCE() and READ_ONCE() for the throttle-event counter.
>> - Add Fixes tag and net instead of net-next.
>> - Fix commit message to describe capability bit and counter.
>> Link to v1:
>> https://lore.ker/
>> nel.org%2Fall%2F20261008083315.306076-1-
>> sahilchandna%40linux.microsoft.com%2F&data=05%7C02%7Chaiyangz%40microsoft.
>> com%7C534992a49c0340631e2f08df304e3c73%7C72f988bf86f141af91ab2d7cd011db47%
>> 7C1%7C0%7C639282784768392174%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRyd
>> WUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C
>> 0%7C%7C%7C&sdata=oj6Ei41iOntNjgoAWNaLSZdvptpbZSkkZMOCa6c2PDw%3D&reserved=0
>>
>>  .../net/ethernet/microsoft/mana/gdma_main.c   | 62 +++++++++++++++++--
>>  .../net/ethernet/microsoft/mana/hw_channel.c  |  6 +-
>>  .../ethernet/microsoft/mana/mana_ethtool.c    |  9 +++
>>  include/net/mana/gdma.h                       | 12 +++-
>>  include/net/mana/mana.h                       |  1 +
>>  5 files changed, 81 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> index 8e9bfc1d6a2a..d74ed00bb783 100644
>> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> @@ -904,6 +904,27 @@ ssize_t mana_gd_read_ring(struct gdma_queue *q, char
>> __user *buf,
>>       return copied;
>>  }
>>
>> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
>> +{
>> +     struct gdma_context *gc = eq->gdma_dev->gdma_context;
>> +     struct gdma_queue *cq;
>> +     u8 i;
>> +
>> +     for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>> +             cq = rcu_dereference(eq->eq.child_cq[i]);
>> +
>> +             if (!cq)
>> +                     continue;
>> +
>> +             if (cq->id >= READ_ONCE(gc->max_num_cqs) ||
>> +                 !gc->cq_table || gc->cq_table[cq->id] != cq)
>> +                     continue;
>> +
>> +             if (cq->cq.callback)
>> +                     cq->cq.callback(cq->cq.context, cq);
>> +     }
>> +}
>> +
>>  static void mana_gd_process_eqe(struct gdma_queue *eq)
>>  {
>>       u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
>> @@ -934,6 +955,11 @@ static void mana_gd_process_eqe(struct gdma_queue
>> *eq)
>>
>>               break;
>>
>> +     case GDMA_EQE_THROTTLE:
>> +             WRITE_ONCE(eq->eq.throttle_count, eq->eq.throttle_count + 1);
> Please use u64_stats_update_begin / end() for stats, which is the standard
> way -- see other stats code in this driver.
> 
Ack, will update it in v4.>> +             mana_gd_schedule_eq_cqs(eq);
>> +             break;
>> +
>>       case GDMA_EQE_TEST_EVENT:
>>               gc->test_event_eq_id = eq->id;
>>               complete(&gc->eq_test_event);
> [...]
> 
> 
>> @@ -250,6 +252,7 @@ static void mana_get_ethtool_stats(struct net_device
>> *ndev,
>>       u64 short_pkt_fmt;
>>       u64 csum_partial;
>>       u64 mana_map_err;
>> +     u64 throttle_events;
>>       int q, i = 0, j;
>>
>>       if (!apc->port_is_up)
>> @@ -261,6 +264,12 @@ static void mana_get_ethtool_stats(struct net_device
>> *ndev,
>>        */
>>       mana_query_phy_stats(apc);
>>
>> +     throttle_events = 0;
>> +     for (q = 0; q < num_queues; q++)
>> +             throttle_events += READ_ONCE(apc->eqs[q].eq-
>>> eq.throttle_count);
> 
> Since you already have per queue throttle_count, please output them for
> each EQ.
> 
> Thanks,
> - Haiyang
Ack, i will drop accumulated throttle count and report per EQ in v4.

The patch needs rebase again for net branch, i will rebase in v4.
