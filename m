From: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Subject: When is it safe to release connection resources?
Date: Thu, 29 Dec 2011 17:42:35 +0100
Message-ID: <4EFC987B.6070901@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm new to RDMA development and I have a question regarding resource release.
If I understood correctly, when ibv_get_cq_event returns, it holds some sort of lock over the completion queue, which is 
released when I call ibv_req_notify_cq. This lock is checked also in ibv_destroy_cq, so that:
1) When ibv_destroy_cq returns, I am certain that there is no thread running somewhere between ibv_get_cq_event and 
ibv_req_notify_cq
2) When ibv_destroy_cq returns, I am certain that ibv_get_cq_event will not return the destroyed cq any more.

Is all this correct?

Thanks
Flavio
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
