From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: rsockets with RoCE
Date: Wed, 27 Jun 2012 16:24:59 -0700
Message-ID: <4FEB964B.5060303@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I attempted to use rsockets with ConnectX-EN adapters and the client 
receives a "Connection refused" message. I debugged this a bit further 
and see that the client is actually receiving an IB_CM_REJ_RECEIVED with 
reason being 28 i.e. "Consumer Reject". Could this be because of the 
difference in how GIDs are obtained in the case of RoCE? Have you 
attempted rsockets on RoCE at all?

Incidentally this problem also highlights another issue we have 
encountered previously. The only way to debug issues like this in RDMA 
CM is to modify the kernel module. Currently there is no way we can turn 
on (and off) debug and get insights into the connection set up process. 
Are you open to considering patches to enhance debug with RDMA CM, 
particularly during the address resolution and connection setup process. 
That way it should not impact the performance during data transfer.

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
