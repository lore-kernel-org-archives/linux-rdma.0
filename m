From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: how should consumer process IB_WC_WR_FLUSH_ERR?
Date: Fri, 24 Sep 2010 11:15:13 -0700 (PDT)
Message-ID: <82370.12072.qm@web30103.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

When consumer application receive IB_WC_WR_FLUSH_ERR, for one of the WQE,
In that case does mean that CQEs for the subsequent WQEs/RQEs should not be polled by the consumer? 
Or stack/HCA will return the CQEs for all the pending WQEs/RQEs?

Regards,
Parav Pandit



      
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
