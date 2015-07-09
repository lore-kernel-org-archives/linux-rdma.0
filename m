From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Thu, 9 Jul 2015 14:21:17 +0300
Message-ID: <559E592D.5000201@mellanox.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
	<559D1562.2070309@mellanox.com>
	<CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw@mail.gmail.com>
	<559D2A80.4040909@mellanox.com>
	<CAD+HZHWBn-KZCsskSGPKLtntj-LjDRodda9jngr+qcKSxLhkGQ@mail.gmail.com>
 <CAD+HZHXcrejwu=dAhmL7vZ=tkAPswm2LiCgwK42kEe5XDvBvhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHXcrejwu=dAhmL7vZ=tkAPswm2LiCgwK42kEe5XDvBvhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 2:14 PM, Jack Wang wrote:
> I managed to update the kernel to OFED 3.0 to verify the bug, but I
> can still produce the bug, maybe there're still some synchronice_irq
> is missing?

Again, even if you don't use the upstream kernel for production, I 
suggest you
try to reproduce the bug there and if it exists we'll try to solve it on 
upstream
and later port to MLNX OFED, makes sense?You can start with just the 
installed 3.18.14

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
