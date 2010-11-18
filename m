From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: mxl4 and rpcrdma: connection to 192.168.0.100:20049 on mlx4_0,
 memreg 5 slots 32 ird 16
Date: Thu, 18 Nov 2010 11:36:15 -0600
Message-ID: <4CE5640F.6040005@opengridcomputing.com>
References: <AANLkTi=d6d2vydtcK+ux22e-QR5xqrkenMoeM8AzHBVq@mail.gmail.com>	<4CE41458.7020202@opengridcomputing.com> <ada62vvigdx.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada62vvigdx.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/17/2010 07:12 PM, Roland Dreier wrote:
>   >  >  Nov 15 09:39:00 node4 kernel: rpcrdma: connection to
>   >  >  192.168.0.100:20049 on mlx4_0, memreg 5 slots 32 ird 16
>   >  >
>   >  >  and then 5 minutes later:
>   >  >
>   >  >  Nov 15 09:44:00 node4 kernel: rpcrdma: connection to
>   >  >  192.168.0.100:20049 closed (-103)
>   >  >
>   >  >
>   >
>   >  I think NFSRDMA server will close the connection after 5 minutes of
>   >  inactivity...
>
> Should the code be spamming the logs for normal events?  (Or is this
> with an elevated log level)
>    

IMO its not needed.  From net/sunrpx/xprtrdma/verbs.c (nfsrdma client):

[root@r10 xprtrdma]# grep "connection to" *.c
verbs.c:        printk(KERN_INFO "rpcrdma: connection to %pI4:%u "
verbs.c:        printk(KERN_INFO "rpcrdma: connection to %pI4:%u closed 
(%d)\n",
[root@r10 xprtrdma]#



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
