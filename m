From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: How to monitor traffic with IBoE/RoCEE?
Date: Thu, 25 Mar 2010 17:18:42 -0700
Message-ID: <4BABFD62.70608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With IBoE/RoCEE, the traditional SM in IB clusters is not needed. Most of the current
IB tools rely on the SM and PM to get packet and error statistics and so on. These 
won't be applicable with IBoE/RoCEE. netstat will have no value since the kernel 
has been bypassed. So, how does one monitor traffic in such a cluster?

The possibilities that I can think of are to get information from the switches or if there 
are some special tools to get information from the adapter ports themselves. Are such tools
available with ConnectX adapters? How would one get cluster-wide traffic information when
such a cluster is deployed?

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
