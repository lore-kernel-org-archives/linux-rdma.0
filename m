From: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Subject: Re: How to recycle recv WR
Date: Sun, 10 Jul 2011 10:21:00 +0800 (CST)
Message-ID: <1310264460.50585.YahooMailNeo@web15805.mail.cnb.yahoo.com>
References: <1309884886.29374.YahooMailNeo@web15805.mail.cnb.yahoo.com> <OFC8B37F5E.50924AE5-ONC12578C4.0071E54F-C12578C4.00755216@ch.ibm.com>
Reply-To: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFC8B37F5E.50924AE5-ONC12578C4.0071E54F-C12578C4.00755216-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tan Li <tanli-q41pLDslbA3auI2f2gSDlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks.

However, it seems inconvenient for app programmer to handle this. Is it=
 possible for OFED to offer an API to cancel the tasks which is already=
 posted to the recv queue?

Yufei




----- Original Message -----
=46rom: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
To: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; linux-rd=
ma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Tan Li <tanli-q41pLDslbA3auI2f2gSDlQ@public.gmane.org>
Sent: Tuesday, July 5, 2011 5:21 PM
Subject: Re: How to recycle recv WR

moving the QP into the IBV_QPS_ERR state by using ibv_modify_qp()
will flush all its WQEs (SQ and RQ) to the associated CQ(s)
where they can be reaped. Those WRs will have the
IBV_WC_WR_FLUSH_ERR status.

bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 07/05/2011 06:54:46 PM:

> ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>=20
> Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>=20
> 07/05/2011 07:00 PM
>=20
> Please respond to
> ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
>=20
> To
>=20
> "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>=20
> cc
>=20
> Tan Li <tanli-q41pLDslbA3auI2f2gSDlQ@public.gmane.org>
>=20
> Subject
>=20
> How to recycle recv WR
>=20
> Hi,
>=20
> Suppose a WR has been posted to the receive queue by ibv_post_recv.=20
> How could the app recycle this work request or say remove this WR=20
> from receive queue? (Except the app got cq event - IBV_WC_RECV).
> My app pre-post a list of receive buffer into the receive queue, and
> those tasks should be removed from the rq and ibv_dereg_mr before=20
> the app exit. That would be more gentle than exit() directly.
>=20
>=20
> Thanks.
>=20
> Yufei
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
