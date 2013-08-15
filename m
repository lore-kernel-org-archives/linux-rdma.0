From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Helps to Decode rpc_debug Output
Date: Thu, 15 Aug 2013 08:46:51 -0400
Message-ID: <520CCDBB.1020501@talpey.com>
References: <CABgxfbGFHv2n5=78_irkxXnX9BFDFPzZvqgs_iDn64AR_3cf5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbGFHv2n5=78_irkxXnX9BFDFPzZvqgs_iDn64AR_3cf5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/14/2013 8:14 PM, Wendy Cheng wrote:
> Longer version of the question:
> I'm trying to enable NFS-RDMA on an embedded system (based on 2.6.38
> kernel) as a client. The IB stacks are taken from OFED 1.5.4. NFS
> server is a RHEL 6.3 Xeon box. The connection uses mellox-4 driver.
> Memory registration is "RPCRDMA_ALLPHYSICAL". There are many issues so
> far but I do manage to get nfs mount working. Simple file operations
> (such as "ls", file read/write, "scp", etc) seem to work as well.

You're probably seeing connection loss from bad RDMA handles, which
come into play when you send large r/w traffic. The fact that small
i/o such as simple ls, and non-NFS traffic such as scp, means the
network itself is ok.

 > While trying to run iozone to see whether the performance gain can be
 > justified for the development efforts, the program runs until it
 > reaches 2MB file size - at that point, RDMA CM sends out
 > "TIMEWAIT_EXIT" event, the xprt is disconnected, and all IOs on that
 > share hang. IPOIB still works though. Not sure what would be the best
 > way to debug this.

I would suggest enabling RPC "transport" debugging, and any tracing
in the IB stack itself, looking to see if you can find any patterns.
You may want to look at the server side, too.

Unfortunately, because you are using Infiniband, packet capture is
going to be next to impossible. You might try using an iWARP adapter,
or one which can be sniffed, if you suspect a traffic issue.

Why did you replace the Linux IB stack with OFED? Did you also take the
NFS/RDMA from that package, and if so are you sure that it all is
is working properly? Doesn't 2.6.38 already have all this?

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
