From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: mxl4 and rpcrdma: connection to 192.168.0.100:20049 on mlx4_0,
 memreg 5 slots 32 ird 16
Date: Wed, 17 Nov 2010 11:43:52 -0600
Message-ID: <4CE41458.7020202@opengridcomputing.com>
References: <AANLkTi=d6d2vydtcK+ux22e-QR5xqrkenMoeM8AzHBVq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=d6d2vydtcK+ux22e-QR5xqrkenMoeM8AzHBVq-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/15/2010 05:29 PM, Stephen Cousins wrote:
> The 2.7.700 firmware is brand new from Supermicro. Prior to this it
> was 2.7.0 and it showed the same thing.
>
> NFS is working for the most part but the client always logs messages
> like below after a modestly sizable transfer ( like 2GB) with dd:
>
> # dd if=/dev/zero of=node4.dat bs=1M count=2K oflag=direct
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 11.7277 seconds, 183 MB/s
>
> messages.log:
>
> Nov 15 09:39:00 node4 kernel: rpcrdma: connection to
> 192.168.0.100:20049 on mlx4_0, memreg 5 slots 32 ird 16
>
> and then 5 minutes later:
>
> Nov 15 09:44:00 node4 kernel: rpcrdma: connection to
> 192.168.0.100:20049 closed (-103)
>
>    

I think NFSRDMA server will close the connection after 5 minutes of 
inactivity...


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
