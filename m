From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] How to monitor traffic with IBoE/RoCEE?
Date: Fri, 26 Mar 2010 10:29:00 -0700
Message-ID: <382A478CAD40FA4FB46605CF81FE39F455FF9847@orsmsx507.amr.corp.intel.com>
References: <4BABFD62.70608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BABFD62.70608-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pradeep wrote,

>With IBoE/RoCEE, the traditional SM in IB clusters is not needed. Most of the current
>IB tools rely on the SM and PM to get packet and error statistics and so on. These 
>won't be applicable with IBoE/RoCEE. netstat will have no value since the kernel 
>has been bypassed. So, how does one monitor traffic in such a cluster?

Some managed Ethernet switches have the ability to log into them and get information
on packets transmited/received on each port and errors that are detected. However,
these are typically proprietary. I am not sure about the Mellanox card. 

So I guess the answer is that you manage RoCCE and iWarp clusters just like
you would any Ethernet cluster, with existing management tools that are available
for managing Ethernet.

woody


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
