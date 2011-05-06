From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Call to ibv_post_recv fails
Date: Fri, 6 May 2011 22:10:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373B6CE@ORSMSX101.amr.corp.intel.com>
References: <BANLkTik2t9dFrtpMqGd29xQWHk=EB8_g6Q@mail.gmail.com>
 <269364.2773.qm@web15806.mail.cnb.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <269364.2773.qm-QZ8mQyt8kqnFTsyTBrxSqPhMsxRAUFZ5QQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>, Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I was hoping some of you might be able to tell me why the call to
> ibv_post_recv fails in the following code snippet, based off of
> rc_pingpong.

rc_pingpong allocates a QP with the maximum sge size set to 1.  That needs to be adjusted as well.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
