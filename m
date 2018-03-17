From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Sat, 17 Mar 2018 14:30:10 -0400
Message-ID: <ac9c34e1-0a81-a494-c7c7-ac9c3922095a@codeaurora.org>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
 <1521216991-28706-19-git-send-email-okaya@codeaurora.org>
 <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com>
 <83387f6e-adcb-14e9-2c22-96abf9493cc6@codeaurora.org>
 <004501d3bd7b$505e70f0$f11b52d0$@opengridcomputing.com>
 <740c7d45-450e-c9b3-ceed-7bc7fcefbc5a@codeaurora.org>
 <71e37a55-537b-d75a-cfde-f188b7cfce8e@codeaurora.org>
 <1f5e3b14-05a1-08d0-c0cb-00805526448d@codeaurora.org>
 <20180317150520.GA23463@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180317150520.GA23463@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Steve Wise <swise@opengridcomputing.com>, netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Michael Werner' <werner@chelsio.com>, 'Casey Leedom' <leedom@chelsio.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

+linuxppc-dev@lists.ozlabs.org

On 3/17/2018 11:05 AM, Jason Gunthorpe wrote:
> On Sat, Mar 17, 2018 at 12:25:14AM -0400, Sinan Kaya wrote:
>> On 3/17/2018 12:03 AM, Sinan Kaya wrote:
>>> On 3/16/2018 11:40 PM, Sinan Kaya wrote:
>>>> I'll change writel_relaxed() with __raw_writel() in the series like you suggested
>>>> and also look at your other comments.
>>>
>>> I spoke too soon.
>>>
>>> Now that I realized, code needs to follow one of the following patterns for correctness
>>>
>>> 1)
>>> wmb()
>>> writel()/writel_relaxed()
>>>
>>> or 
>>>
>>> 2)
>>> wmb()
>>> __raw_wrltel()
>>> mmiowb()
>>>
>>> but definitely not
>>>
>>> wmb()
>>> __raw_wrltel()
>>>
>>> Since #1 == #2, I'll stick to my current implementation of writel_relaxed()
>>>
>>> Changing writel() to writel_relaxed() or __raw_writel() isn't enough. PowerPC needs mmiowb()
>>> for correctness. ARM's mmiowb() implementation is empty.
>>>
>>> So, there is no one size fits all solution with the current state of affairs.
>>>
>>>
>>
>> I think I finally got what you mean.
>>
>> Code seems to have
>>
>> wmb()
>> writel()/writeq()
>> wmb()
>>
>> this can be safely replaced with
>>
>> wmb()
>> __raw_writel()/__raw_writeq()
>> wmb()
>>
>> This will work on all arches. Below is the new version. Let me know if this is OK.
>>
>> +++ b/drivers/infiniband/hw/cxgb4/t4.h
>> @@ -457,7 +457,7 @@ static inline void pio_copy(u64 __iomem *dst, u64 *src)
>>         int count = 8;
>>
>>         while (count) {
>> -               writeq(*src, dst);
>> +               __raw_writeq(*src, dst);
>>                 src++;
>>                 dst++;
>>                 count--;
>> @@ -477,15 +477,16 @@ static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc, union t4_wr *wqe)
>>                                  (u64 *)wqe);
>>                 } else {
>>                         pr_debug("DB wq->sq.pidx = %d\n", wq->sq.pidx);
>> -                       writel(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
>> -                              wq->sq.bar2_va + SGE_UDB_KDOORBELL);
>> +                       __raw_writel(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
>> +                                    wq->sq.bar2_va + SGE_UDB_KDOORBELL);
>>                 }
>>
>>                 /* Flush user doorbell area writes. */
>>                 wmb();
>>                 return;
>>         }
>> -       writel(QID_V(wq->sq.qid) | PIDX_V(inc), wq->db);
>> +       __raw_writel(QID_V(wq->sq.qid) | PIDX_V(inc), wq->db);
>> +       mmiowmb()
>>  }
>>
>>  static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc,
>> @@ -502,15 +503,16 @@ static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc,
>>                                  (void *)wqe);
>>                 } else {
>>                         pr_debug("DB wq->rq.pidx = %d\n", wq->rq.pidx);
>> -                       writel(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
>> -                              wq->rq.bar2_va + SGE_UDB_KDOORBELL);
>> +                       __raw_writel(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
>> +                                    wq->rq.bar2_va + SGE_UDB_KDOORBELL);
>>                 }
>>
>>                 /* Flush user doorbell area writes. */
>>                 wmb();
>>                 return;
>>         }
>> -       writel(QID_V(wq->rq.qid) | PIDX_V(inc), wq->db);
>> +       __raw_writel(QID_V(wq->rq.qid) | PIDX_V(inc), wq->db);
>> +       mmiowmb();
> 
> No! NAK! Adding *new* barriers to use the *wrong* accessor is crazy!
> 
> Your first patch was right, replacing
>   wmb()
>   writel()
> 
> With wmb(); writel_relaxed() is fine, and helps ARM.
> 
> The problem with PPC has nothing to do with the writel, it is with the
> spinlock, and we can't improve it without adding some new
> infrastructure. Certainly don't hack around the problem by using
> __raw_writel in multi-arch drivers!
> 
> In userspace we settled on something like this as a pattern:
> 
>  mmio_wc_spin_lock()
>  writel_wc_mmio()
>  mmio_wc_spin_unlock()

> 
> Where mmio_wc_spin_unlock incorporates the mmiowmb and is defined to
> fully contain all MMIO access to WC and UC memory.
> 
> Due to our userspace the pattern is specifically used with MMIO writes
> to WC BAR memory, but it could be generalized..
> 
> This allows all known arches to use the best code in all cases. x86
> can even optimize a lot and combine the mmiowmb() into the
> spin_unlock, apparently.

Given both Dave [1] and Jason's feedback, we have to ask PowerPC developers
to fix writel_relaxed().

Otherwise, PowerPC won't be able to take advantage of the optimizations
introduced in this series.

I don't think we need writel_really_relaxed() API.

Somebody also has to take a task and work very hard to get rid of __raw_writeX()
APIs in drivers/net directory. It looked like a very common practice though
it clearly violates multiarch portability concerns Jason and Deve highlighted.

This will be the next version:

iff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 8369c7c..6e5658a 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -457,7 +457,7 @@ static inline void pio_copy(u64 __iomem *dst, u64 *src)
        int count = 8;
 
        while (count) {
-               writeq(*src, dst);
+               writeq_relaxed(*src, dst);
                src++;
                dst++;
                count--;
@@ -477,15 +477,15 @@ static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc, union t4_wr *wqe)
                                 (u64 *)wqe);
                } else {
                        pr_debug("DB wq->sq.pidx = %d\n", wq->sq.pidx);
-                       writel(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
-                              wq->sq.bar2_va + SGE_UDB_KDOORBELL);
+                       writel_relaxed(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
+                                      wq->sq.bar2_va + SGE_UDB_KDOORBELL);
                }
 
                /* Flush user doorbell area writes. */
                wmb();
                return;
        }
-       writel(QID_V(wq->sq.qid) | PIDX_V(inc), wq->db);
+       writel_relaxed(QID_V(wq->sq.qid) | PIDX_V(inc), wq->db);
 }
 
 static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc,
@@ -502,15 +502,15 @@ static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc,
                                 (void *)wqe);
                } else {
                        pr_debug("DB wq->rq.pidx = %d\n", wq->rq.pidx);
-                       writel(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
-                              wq->rq.bar2_va + SGE_UDB_KDOORBELL);
+                       writel_relaxed(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
+                                      wq->rq.bar2_va + SGE_UDB_KDOORBELL);
                }
 
                /* Flush user doorbell area writes. */
                wmb();
                return;
        }
-       writel(QID_V(wq->rq.qid) | PIDX_V(inc), wq->db);
+       writel_relaxed(QID_V(wq->rq.qid) | PIDX_V(inc), wq->db);
 }


[1] https://lkml.org/lkml/2018/3/17/100

> 
> Jason
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
