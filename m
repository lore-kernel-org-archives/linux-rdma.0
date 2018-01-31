From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [bug report] RDMA/bnxt_re: Add SRQ support for Broadcom adapters
Date: Wed, 31 Jan 2018 11:16:55 +0530
Message-ID: <CANjDDBiiL1TtH5OZ9gYuiZquKu2=AV+u9nJDQ--qibOP5CXgYg@mail.gmail.com>
References: <20180130124546.GA9394@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130124546.GA9394@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 6:15 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Devesh Sharma,
>
> The patch 37cb11acf1f7: "RDMA/bnxt_re: Add SRQ support for Broadcom
> adapters" from Jan 11, 2018, leads to the following static checker
> warning:
>
>         drivers/infiniband/hw/bnxt_re/ib_verbs.c:1317 bnxt_re_destroy_srq()
>         warn: 'srq->umem' isn't an ERR_PTR
>
> drivers/infiniband/hw/bnxt_re/ib_verbs.c
>   1313                  dev_err(rdev_to_dev(rdev), "Destroy HW SRQ failed!");
>   1314                  return rc;
>   1315          }
>   1316
>   1317          if (srq->umem && !IS_ERR(srq->umem))
>                                   ^^^^^^^^^^^^^^^^
> We never store error pointers to srq->umem.  It's pretty consistently
> checked for error pointers though so maybe that's fine.  It causes a
> static checker warning because error pointer confusion is a pretty
> common source of bugs.  Anyway, feel free to ignore if you want...
Thanks for reporting Dan,

Is there a way out, I want to call ib_umem_release only if it was valid.
I think if ib_umem_release checks for the validity of pointer then I
can get rid of this?
There are other places also in bnxt_re driver where such checks are present.
>
>   1318                  ib_umem_release(srq->umem);
>   1319          kfree(srq);
>   1320          atomic_dec(&rdev->srq_count);
>   1321          if (nq)
>   1322                  nq->budget--;
>   1323          return 0;
>   1324  }
>   1325
>   1326  static int bnxt_re_init_user_srq(struct bnxt_re_dev *rdev,
>   1327                                   struct bnxt_re_pd *pd,
>   1328                                   struct bnxt_re_srq *srq,
>   1329                                   struct ib_udata *udata)
>   1330  {
>   1331          struct bnxt_re_srq_req ureq;
>   1332          struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
>   1333          struct ib_umem *umem;
>   1334          int bytes = 0;
>   1335          struct ib_ucontext *context = pd->ib_pd.uobject->context;
>   1336          struct bnxt_re_ucontext *cntx = container_of(context,
>   1337                                                       struct bnxt_re_ucontext,
>   1338                                                       ib_uctx);
>   1339          if (ib_copy_from_udata(&ureq, udata, sizeof(ureq)))
>   1340                  return -EFAULT;
>   1341
>   1342          bytes = (qplib_srq->max_wqe * BNXT_QPLIB_MAX_RQE_ENTRY_SIZE);
>   1343          bytes = PAGE_ALIGN(bytes);
>   1344          umem = ib_umem_get(context, ureq.srqva, bytes,
>   1345                             IB_ACCESS_LOCAL_WRITE, 1);
>   1346          if (IS_ERR(umem))
>   1347                  return PTR_ERR(umem);
>   1348
>   1349          srq->umem = umem;
>                 ^^^^^^^^^^^^^^^^
> Set here, I guess.
Yeah, the checker is confused due to this.
>
>   1350          qplib_srq->nmap = umem->nmap;
>
> regards,
> dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
