From: Craig Prescott <prescott-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>
Subject: ib0: failed send event
Date: Thu, 04 Nov 2010 16:45:21 -0400
Message-ID: <4CD31B61.5090605@hpc.ufl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi,

We have a new-ish node whose IPoIB access was interrupted last night; 
last message in the syslog was:

ib0: failed send event (status=2, wrid=74 vend_err 67)

The node has a Mellanox ConnectX HCA (MHQH19-XTC).

I understand the status corresponds to IB_WC_LOC_QP_OP_ERR.  What does a 
vendor error code of 67 mean?

Thanks,
Craig Prescott
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
