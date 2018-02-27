From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH] RDMA/core: reduce IB_POLL_BATCH constant
Date: Wed, 28 Feb 2018 00:15:56 +0200
Message-ID: <193aaf91-c9d1-38b1-a89f-45f129ca5798@mellanox.com>
References: <20180220205924.2035765-1-arnd@arndb.de>
 <1519161268.3737.12.camel@wdc.com>
 <F2FB1034-BFB6-45ED-878E-6FADD756157D@oracle.com>
 <c3eab137-1c37-0e6c-a53a-df2cf80653d2@grimberg.me>
 <0f90134c-3d40-1d24-711f-e4ab32802bd8@mellanox.com>
 <c1bcd5cc-381d-2d94-1278-f9fb5c9c0b14@grimberg.me>
 <20180227220958.GA21714@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227220958.GA21714@ziepe.ca>
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>
Cc: Chuck Lever <chuck.lever@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "arnd@arndb.de" <arnd@arndb.de>, "dledford@redhat.com" <dledford@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leonro@mellanox.com" <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 2/28/2018 12:09 AM, Jason Gunthorpe wrote:
> On Thu, Feb 22, 2018 at 05:39:09PM +0200, Sagi Grimberg wrote:
>>
>>>> The only reason why I added this array on-stack was to allow consumers
>>>> that did not use ib_alloc_cq api to call it, but that seems like a
>>>> wrong decision when thinking it over again (as probably these users
>>>> did not set the wr_cqe correctly).
>>>>
>>>> How about we make ib_process_cq_direct use the cq wc array and add
>>>> a WARN_ON statement (and fail it gracefully) if the caller used this
>>>> API without calling ib_alloc_cq?
>>>
>>> but we tried to avoid cuncurrent access to cq->wc.
>>
>> Not sure its a valid use-case. But if there is a compelling
>> reason to keep it as is, then we can do smaller on-stack
>> array.
> 
> Did we come to a conclusion what to do here?

guys,
what do you think about the following solution (untested):


diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index bc79ca8..59d2835 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -17,6 +17,7 @@

  /* # of WCs to poll for with a single call to ib_poll_cq */
  #define IB_POLL_BATCH                  16
+#define IB_POLL_BATCH_DIRECT           8

  /* # of WCs to iterate over before yielding */
  #define IB_POLL_BUDGET_IRQ             256
@@ -25,17 +26,25 @@
  #define IB_POLL_FLAGS \
         (IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS)

-static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_wc 
*poll_wc)
+static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_wc 
*poll_wc,
+                          int batch)
  {
-       int i, n, completed = 0;
-       struct ib_wc *wcs = poll_wc ? : cq->wc;
-
+       int i, n, ib_poll_batch, completed = 0;
+       struct ib_wc *wcs;
+
+       if (poll_wc) {
+               wcs = poll_wc;
+               ib_poll_batch = batch;
+       } else {
+               wcs = cq->wc;
+               ib_poll_batch = IB_POLL_BATCH;
+       }
         /*
          * budget might be (-1) if the caller does not
          * want to bound this call, thus we need unsigned
          * minimum here.
          */
-       while ((n = ib_poll_cq(cq, min_t(u32, IB_POLL_BATCH,
+       while ((n = ib_poll_cq(cq, min_t(u32, ib_poll_batch,
                         budget - completed), wcs)) > 0) {
                 for (i = 0; i < n; i++) {
                         struct ib_wc *wc = &wcs[i];
@@ -48,7 +57,7 @@ static int __ib_process_cq(struct ib_cq *cq, int 
budget, struct ib_wc *poll_wc)

                 completed += n;

-               if (n != IB_POLL_BATCH ||
+               if (n != ib_poll_batch ||
                     (budget != -1 && completed >= budget))
                         break;
         }
@@ -72,9 +81,9 @@ static int __ib_process_cq(struct ib_cq *cq, int 
budget, struct ib_wc *poll_wc)
   */
  int ib_process_cq_direct(struct ib_cq *cq, int budget)
  {
-       struct ib_wc wcs[IB_POLL_BATCH];
+       struct ib_wc wcs[IB_POLL_BATCH_DIRECT];

-       return __ib_process_cq(cq, budget, wcs);
+       return __ib_process_cq(cq, budget, wcs, IB_POLL_BATCH_DIRECT);
  }
  EXPORT_SYMBOL(ib_process_cq_direct);

@@ -88,7 +97,7 @@ static int ib_poll_handler(struct irq_poll *iop, int 
budget)
         struct ib_cq *cq = container_of(iop, struct ib_cq, iop);
         int completed;

-       completed = __ib_process_cq(cq, budget, NULL);
+       completed = __ib_process_cq(cq, budget, NULL, 0);
         if (completed < budget) {
                 irq_poll_complete(&cq->iop);
                 if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
@@ -108,7 +117,7 @@ static void ib_cq_poll_work(struct work_struct *work)
         struct ib_cq *cq = container_of(work, struct ib_cq, work);
         int completed;

-       completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE, NULL);
+       completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE, NULL, 0);
         if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
             ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
                 queue_work(ib_comp_wq, &cq->work);



> 
> Jason
> 
