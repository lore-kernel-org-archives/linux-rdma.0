From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Thu, 12 Jan 2012 11:29:23 +0200
Message-ID: <4F0EA7F3.8040704@mellanox.com>
References: <4EEA0577.5030304@profitbricks.com>	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>	<4F0D987B.4060206@profitbricks.com> <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w@mail.gmail.com> <4F0EA679.1020703@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0EA679.1020703-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2012 11:23 AM, Sebastian Riemer wrote:
> We are running iSER directly on the host. KVM is compiled in but there 
> aren't any VMs on our iSER test server. It is a diskless SuperMicro 
> server with NFS root. On productive servers we have a live-image and 
> KVM uses the iSER driven block devices for storage. This is the IB HCA 
> (mlx4): Mellanox MT26428 [ConnectX IB QDR, PCIe 2.0 5GT/s] We've 
> updated the firmware lately on all servers. How can I find out the 
> firmware version? With tvflash or mstflint? 

If you  have build the kernel IB user space support (uverbs) and the IB 
libs, do "ibv_devinfo" if not, just ossi "cat 
/sys/class/infiniband/mlx4_0/*" and send the output. To be clear, iser 
does work for you on the productive servers but not on this server?

> The storage has the same IB HCA, and they are connected via a switch. 
> I'll ask someone of the SysOps which one it is and if they have the 
> latest firmware on it. Perhaps this could be the problem.

As its local protection error on TX, I don't see how this could relate 
to the target node.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
