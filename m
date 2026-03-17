Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04043346A0
	for <linux-rdma@vger.kernel.org>; Tue, 17 Mar 2026 17:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768264; cv=none; b=tyQGFfJF4p02HBsKVXa1Wa8LDwVPTte860CB7dpgycyzDvW49Jw976N1JrlcmOW/K6ulLQrBi/FNpNZ8hAGL8eh4JDRc22EJOSkGlhYFfZWReQmmtvtT8xd6qc4STWYJ7BlcdM92Uz6qFHkTesIhPDKpa55xJvvt0jrNlu6lGww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768264; c=relaxed/simple;
	bh=mBujKwtFGmmn7LhpHX9AHYeuQRCtCH+LEHuoud8E5HQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2rWACaxy/5a5+LBRwpt4efmGGZPh22BB2/OacxORJ2pL1AebaflHLpAfbpMGWQcC31PveMRdvRzTyDsVUM48FHQQsOfufvNkVAC0/ZaHKiEUy6SLq2f1KtfLw+ygFm25PEwppuMTl8H1NgYAusyKSUjL/uh76twFQ2XFWfheKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FdPZq/RI; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FdPZq/RI"
Message-ID: <5de82ef1-3df6-44f8-a3c1-c6568c1110cf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773768259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YWLlWrGq22RHoaOwIqFVHpbB6nqXmnZCNeA8MKU5JWs=;
	b=FdPZq/RIcNxWiRURHjsItOjynJ2cCTbrN3fqQh6I/as/IqVKZnsPiwXm6Q4szDuUbnALZm
	aJJYLe4K7s59Ufbau3T0MpotQmWCCp4ApZ9qORcnhQOG4AQUV9Ews7S0gDrTjy0szUVWMN
	G3G2E9dUAXhjFb0WDE3c+oMWtzZ85bE=
Date: Tue, 17 Mar 2026 10:24:11 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Replace use of system_unbound_wq with
 system_dfl_wq
To: Leon Romanovsky <leon@kernel.org>,
 Marco Crivellari <marco.crivellari@suse.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Michal Hocko <mhocko@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <20260313154023.298325-1-marco.crivellari@suse.com>
 <20260316201301.GL61385@unreal>
 <c5374d12-84ed-4298-92d3-90062988f68d@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <c5374d12-84ed-4298-92d3-90062988f68d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 3/17/26 7:38 AM, Zhu Yanjun wrote:
> 在 2026/3/16 13:13, Leon Romanovsky 写道:
>> On Fri, Mar 13, 2026 at 04:40:23PM +0100, Marco Crivellari wrote:
>>> This patch continues the effort to refactor workqueue APIs, which 
>>> has begun
>>> with the changes introducing new workqueues and a new 
>>> alloc_workqueue flag:
>>>
>>>     commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and 
>>> system_dfl_wq")
>>>     commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
>>>
>>> The point of the refactoring is to eventually alter the default 
>>> behavior of
>>> workqueues to become unbound by default so that their workload 
>>> placement is
>>> optimized by the scheduler.
>>>
>>> Before that to happen, workqueue users must be converted to the 
>>> better named
>>> new workqueues with no intended behaviour changes:
>>>
>>>     system_wq -> system_percpu_wq
>>>     system_unbound_wq -> system_dfl_wq
>>>
>>> This way the old obsolete workqueues (system_wq, system_unbound_wq) 
>>> can be
>>> removed in the future.
>>
>> I recall earlier efforts to replace system workqueues with per‑driver 
>> queues,
>> because unloading a driver forces a flush of the entire system 
>> workqueue,
>> which is undesirable for overall system behavior.
>>
>> Wouldn't it be better to introduce a local workqueue here and use 
>> that instead?
>
> Thanks.
>
> 1.The initialization should be:
>
> my_wq = alloc_workqueue("my_driver_queue", WQ_UNBOUND | 
> WQ_MEM_RECLAIM, 0);
> if (!my_wq)
>     return -ENOMEM;
>
> 2. The Submission should be:
>
> queue_work(my_wq, &my_work);
>
> 3. Destroy should be:
>
> destroy_workqueue()
>
> Thanks,
> Zhu Yanjun

Hi, Leon

The diff for a new work queue in rxe is as below. Please review it.


diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c 
b/drivers/infiniband/sw/rxe/rxe_odp.c
index bc11b1ec59ac..03199fef47fb 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -545,7 +545,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
          work->frags[i].mr = mr;
      }

-    queue_work(system_unbound_wq, &work->work);
+    rxe_queue_aux_work(&work->work);

      return 0;

diff --git a/drivers/infiniband/sw/rxe/rxe_task.c 
b/drivers/infiniband/sw/rxe/rxe_task.c
index f522820b950c..a2da699b969e 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -6,19 +6,36 @@

  #include "rxe.h"

+/* work for rxe_task */
  static struct workqueue_struct *rxe_wq;

+/* work for other rxe jobs */
+static struct workqueue_struct *rxe_aux_wq;
+
  int rxe_alloc_wq(void)
  {
-    rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND, WQ_MAX_ACTIVE);
+    rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND | WQ_MEM_RECLAIM,
+                WQ_MAX_ACTIVE);
      if (!rxe_wq)
          return -ENOMEM;

+    rxe_aux_wq = alloc_workqueue("rxe_aux_wq",
+                WQ_UNBOUND | WQ_MEM_RECLAIM, WQ_MAX_ACTIVE);
+    if (!rxe_aux_wq) {
+        destroy_workqueue(rxe_wq);
+        return -ENOMEM;
+
+    }
+
      return 0;
  }

  void rxe_destroy_wq(void)
  {
+    flush_workqueue(rxe_aux_wq);
+    destroy_workqueue(rxe_aux_wq);
+
+    flush_workqueue(rxe_wq);
      destroy_workqueue(rxe_wq);
  }

@@ -254,6 +271,14 @@ void rxe_sched_task(struct rxe_task *task)
      spin_unlock_irqrestore(&task->lock, flags);
  }

+/* rxe_wq for rxe tasks. rxe_aux_wq for other rxe jobs.
+ */
+void rxe_queue_aux_work(struct work_struct *work)
+{
+    WARN_ON_ONCE(!rxe_aux_wq);
+    queue_work(rxe_aux_wq, work);
+}
+
  /* rxe_disable/enable_task are only called from
   * rxe_modify_qp in process context. Task is moved
   * to the drained state by do_task.
diff --git a/drivers/infiniband/sw/rxe/rxe_task.h 
b/drivers/infiniband/sw/rxe/rxe_task.h
index a8c9a77b6027..e1c0a34808b4 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.h
+++ b/drivers/infiniband/sw/rxe/rxe_task.h
@@ -36,6 +36,7 @@ int rxe_alloc_wq(void);

  void rxe_destroy_wq(void);

+void rxe_queue_aux_work(struct work_struct *work);
  /*
   * init rxe_task structure
   *    qp  => parameter to pass to func

Zhu Yanjun

>
>>
>> Thanks
>>
>>>
>>> Link: 
>>> https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
>>> Suggested-by: Tejun Heo <tj@kernel.org>
>>> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
>>> ---
>>>   drivers/infiniband/sw/rxe/rxe_odp.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c 
>>> b/drivers/infiniband/sw/rxe/rxe_odp.c
>>> index bc11b1ec59ac..d440c8cbaea5 100644
>>> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
>>> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
>>> @@ -545,7 +545,7 @@ static int rxe_ib_advise_mr_prefetch(struct 
>>> ib_pd *ibpd,
>>>           work->frags[i].mr = mr;
>>>       }
>>>   -    queue_work(system_unbound_wq, &work->work);
>>> +    queue_work(system_dfl_wq, &work->work);
>>>         return 0;
>>>   --
>>> 2.53.0
>>>
>
