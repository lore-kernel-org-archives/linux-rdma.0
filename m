From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: double CLOSE event indication crash
Date: Mon, 16 Aug 2010 17:51:26 +0300
Message-ID: <4C69506E.6040605@Voltaire.com>
References: <20100814210456.GA7116@FLATIF-MOBL3>	<4C677DD9.5030308@Voltaire.com> <2EFBCAEF10980645BBCFB605689E08E9049F5E881C@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E9049F5E881C-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Latif, Faisal wrote:
> BUG() was in iw_cm.ko in its close handler mentioned as core in my email and caused by iw_nes.ko.

I see, looks like iwcm.c accounts for most of the BUG* calls made from the core, could be nice
to reduce them over time.

Or.

> # grep -n BUG drivers/infiniband/core/*.c | grep "("
> drivers/infiniband/core/cma.c:1262:             BUG_ON(1);
> drivers/infiniband/core/cm.c:1169:      BUG_ON(cm_id->state != IB_CM_IDLE);
> drivers/infiniband/core/cm.c:1318:              BUG_ON(!work);
> drivers/infiniband/core/device.c:175:   BUG_ON(size < sizeof (struct ib_device));
> drivers/infiniband/core/device.c:194:   BUG_ON(device->reg_state != IB_DEV_UNREGISTERED);
> drivers/infiniband/core/iwcm.c:120:     BUG_ON(!list_empty(&cm_id_priv->work_free_list));
> drivers/infiniband/core/iwcm.c:163:     BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
> drivers/infiniband/core/iwcm.c:165:             BUG_ON(!list_empty(&cm_id_priv->work_list));
> drivers/infiniband/core/iwcm.c:186:             BUG_ON(!list_empty(&cm_id_priv->work_list));
> drivers/infiniband/core/iwcm.c:241:     BUG_ON(qp == NULL);
> drivers/infiniband/core/iwcm.c:298:             BUG();
> drivers/infiniband/core/iwcm.c:374:             BUG();
> drivers/infiniband/core/iwcm.c:397:     BUG_ON(test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags));
> drivers/infiniband/core/iwcm.c:518:             BUG_ON(cm_id_priv->state != IW_CM_STATE_CONN_RECV);
> drivers/infiniband/core/iwcm.c:583:             BUG_ON(cm_id_priv->state != IW_CM_STATE_CONN_SENT);
> drivers/infiniband/core/iwcm.c:620:     BUG_ON(iw_event->status);
> drivers/infiniband/core/iwcm.c:695:     BUG_ON(cm_id_priv->state != IW_CM_STATE_CONN_RECV);
> drivers/infiniband/core/iwcm.c:723:     BUG_ON(cm_id_priv->state != IW_CM_STATE_CONN_SENT);
> drivers/infiniband/core/iwcm.c:795:             BUG();
> drivers/infiniband/core/iwcm.c:824:             BUG();
> drivers/infiniband/core/iwcm.c:865:             BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
> drivers/infiniband/core/iwcm.c:869:                             BUG_ON(!list_empty(&cm_id_priv->work_list));
> drivers/infiniband/core/mad.c:587:      BUG_ON(!mad_list->mad_queue);
> drivers/infiniband/core/mad.c:1396:                     BUG_ON(!*method);
> drivers/infiniband/core/mad.c:1406:                     BUG_ON(*method);
> drivers/infiniband/core/mad.c:2242:                             BUG_ON(1);
> drivers/infiniband/core/verbs.c:91:             BUG();


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
