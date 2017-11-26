From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: possible isert bug in tear down sequence
Date: Sun, 26 Nov 2017 14:18:10 +0200
Message-ID: <77fdee90-b51c-1f38-16ea-0183a223f06c@grimberg.me>
References: <BN3PR07MB2578825BFC784DF5DDB6E125F8570@BN3PR07MB2578.namprd07.prod.outlook.com>
 <e196fa80-d7ad-cfa7-651b-f343c0198a84@grimberg.me>
 <BN3PR07MB2578A4A4D5B2A7C0DBA91843F8240@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578A4A4D5B2A7C0DBA91843F8240-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Ram,

> Let me add a third possibility, that is what we are hitting:
> I see that isert uses isert_cma_handler() and in the following cases
> drain won't be invoked:
>          case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
>                  isert_info("Connection rejected: %s\n",
>                             rdma_reject_msg(cma_id, event->status));
>          case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
>          case RDMA_CM_EVENT_CONNECT_ERROR:
>                  ret = isert_connect_error(cma_id);
>                  break;
> 
> Specifically, I hit the rejected case. See dmesg below with added prints (rrr...).
> We Are using
> 
> [ 2455.241978] rrr created QP ffff880e984d6c00
> [ 2455.241982] isert: isert_login_post_recv: Setup sge: addr: eb19e4000 length: 8268 0x00000000
> [ 2455.241987] rrr post_recv qp=ffff880e984d6c00, wr_id=ffff880eb19e6064
> [ 2455.242108] isert: isert_cma_handler: rejected (8): status 10 id ffff880eb1f9b000 np ffff8810454d2c40
> [ 2455.242114] isert: isert_cma_handler: Connection rejected: stale conn
> [ 2455.242121] isert: isert_release_kref: conn ffff880eb19e2000 final kref kworker/7:2/6058
> [ 2455.242127] isert: isert_connect_release: conn ffff880eb19e2000
> [ 2455.242156] rrr poll_recv qp=ffff880e984d6c00 RDMA_CQE_RESP_STS_WORK_REQUEST_FLUSHED_ERR, wr_id=ffff880eb19e6064
> [ 2455.242157] rrr destroyed QP ffff880e984d6c00
> [ 2455.242164] Modules linked in: netconsole target_core_user target_core_pscsi target_core_file target_core_iblock
> [ 2455.242183] BUG: unable to handle kernel
> [ 2455.242202]  [<ffffffffa0823813>] isert_login_recv_done+0x23/0x160 [ib_isert]
> 
> A QP gets created, post_recv is invoked, poll_cq as well (flushed) the QP is destroyed and then the workqueue tries to dereference the QP...
> 
> I'm checking why the connection got stale, but anyway I think ib_drain_qp() should be invoked.

100% correct :)

> What do you think?

Does this fix your issue:
--
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c 
b/drivers/infiniband/ulp/isert/ib_isert.c
index ceabdb85df8b..9d4785ba24cb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -741,6 +741,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
  {
         struct isert_conn *isert_conn = cma_id->qp->qp_context;

+       ib_drain_qp(isert_conn->qp);
         list_del_init(&isert_conn->node);
         isert_conn->cm_id = NULL;
         isert_put_conn(isert_conn);
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
