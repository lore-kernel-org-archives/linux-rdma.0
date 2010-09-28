From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how should consumer process IB_WC_WR_FLUSH_ERR?
Date: Tue, 28 Sep 2010 14:42:08 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AEB9F237@orsmsx501.amr.corp.intel.com>
References: <82370.12072.qm@web30103.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <82370.12072.qm-C4kfVBbaGy+vuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> When consumer application receive IB_WC_WR_FLUSH_ERR, for one of the WQE,
> In that case does mean that CQEs for the subsequent WQEs/RQEs should not be
> polled by the consumer?
> Or stack/HCA will return the CQEs for all the pending WQEs/RQEs?

You should receive an entry for each posted receive and can continue to poll the CQ.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
