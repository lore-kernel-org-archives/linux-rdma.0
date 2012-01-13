From: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Subject: Leak in rdma_get_cm_event on pthread_cancel?
Date: Fri, 13 Jan 2012 12:46:00 +0100
Message-ID: <4F101978.6010608@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When I want to stop the thread reading rdma events, I kill it with a pthread_cancel(), since it is blocked in a 
rdma_get_cm_event(). This causes a leak of the evt variable in the rdma_get_cm_event() function. Not a big deal, of 
course, but a couple of pthread_cleanup_push(free, evt) and pthread_cleanup_pop() should solve it.

Flavio
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
