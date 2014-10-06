From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: NFS over RDMA with no TCP/UDP
Date: Mon, 06 Oct 2014 14:57:24 -0500
Message-ID: <5432F424.1030804@opengridcomputing.com>
References: <CAO9TOLckugLP5_r+9MMeRWfCC3oXq8XcXbyaT7QgTyfg5i-now@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO9TOLckugLP5_r+9MMeRWfCC3oXq8XcXbyaT7QgTyfg5i-now-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2014 2:11 PM, Adam Brenner wrote:
> Howdy,
>
> On our HPC cluster, we are exploring the option of mounting a NFS
> client over RDMA where no TCP/UDP connection will be available. Both
> the client and the server will have RDMA configured with OFED.
>
> Is this possible?

I'm not sure what you mean by "where no TCP/UDP connection will be 
available."?  What iWARP devices are you using?

>
> If so, what address would we specify on the NFS client side as the
> source host? iWARP address + port number? How I find out the iWARP
> address? Is that the same as the GID given by the command ibaddr? Or
> is this the Node GUID from ibstat? Do we have to safe escape or quote
> this address for both the mount option and /etc/exports?

Basically you configure the iWARP device's ethernet interface for normal 
NIC traffic, and use that IP address for the NFSRDMA mount. See 
Documentation/filesystems/nfs/nfs-rdma.txt for details.

Steve.


> thanks,
> /adam
>
> --
> Adam Brenner
> Computer Science, Undergraduate Student
> Donald Bren School of Information and Computer Sciences
>
> System Administrator, HPC Cluster
> Office of Information Technology
> http://hpc.oit.uci.edu/
>
> University of California, Irvine
> www.ics.uci.edu/~aebrenne/
> aebrenne-sXc7qaQca9o@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
