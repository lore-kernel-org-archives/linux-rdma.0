From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Thu, 12 Jan 2012 11:16:47 +0100
Message-ID: <4F0EB30F.8040504@profitbricks.com>
References: <4EEA0577.5030304@profitbricks.com>	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>	<4F0D987B.4060206@profitbricks.com> <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w@mail.gmail.com> <4F0EA679.1020703@profitbricks.com> <4F0EA7F3.8040704@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0EA7F3.8040704-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/01/12 10:29, Or Gerlitz wrote:
> If you  have build the kernel IB user space support (uverbs) and the
> IB libs, do "ibv_devinfo" if not, just ossi "cat
> /sys/class/infiniband/mlx4_0/*" and send the output. To be clear, iser
> does work for you on the productive servers but not on this server?

Yes, we've got consistent OFED-1.5.4 user-space. "ibv_devinfo" reports a
"mismatch between the kernel and the userspace libraries" - "kernel does
not support XRC.". "ibverbs-driver-mlx4" is at version
1.0.1-1.20.g6771d22 and "libibverbs" is at version 1.1.4-1.24.gb89d4d7.

But O.K., the other method shows firmware version "2.9.1000".

iSER only works on productive servers, because we use the OFA kernel
modules from OFED for them at the moment (with 3.0 ported *iscsi*
drivers). But there the IPoIB traffic is too slow for us.
We connect customer VMs with IPv6 between different servers via IB.

And yes, we could also test kernel 3.2 on our iSER test server.

Regards,
Sebastian


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
