From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: How to recycle recv WR
Date: Tue, 5 Jul 2011 23:21:27 +0200
Message-ID: <OFC8B37F5E.50924AE5-ONC12578C4.0071E54F-C12578C4.00755216@ch.ibm.com>
References: <1309884886.29374.YahooMailNeo@web15805.mail.cnb.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309884886.29374.YahooMailNeo-bJgPt2WvBWXFTsyTBrxSqPhMsxRAUFZ5QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tan Li <tanli-q41pLDslbA3auI2f2gSDlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

moving the QP into the IBV_QPS_ERR state by using ibv_modify_qp()
will flush all its WQEs (SQ and RQ) to the associated CQ(s)
where they can be reaped. Those WRs will have the
IBV_WC_WR_FLUSH_ERR status.

bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 07/05/2011 06:54:46 PM:

> ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org> 
> Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> 07/05/2011 07:00 PM
> 
> Please respond to
> ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
> 
> To
> 
> "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> 
> cc
> 
> Tan Li <tanli-q41pLDslbA3auI2f2gSDlQ@public.gmane.org>
> 
> Subject
> 
> How to recycle recv WR
> 
> Hi,
> 
> Suppose a WR has been posted to the receive queue by ibv_post_recv. 
> How could the app recycle this work request or say remove this WR 
> from receive queue? (Except the app got cq event - IBV_WC_RECV).
> My app pre-post a list of receive buffer into the receive queue, and
> those tasks should be removed from the rq and ibv_dereg_mr before 
> the app exit. That would be more gentle than exit() directly.
> 
> 
> Thanks.
> 
> Yufei
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
