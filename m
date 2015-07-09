From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Thu, 9 Jul 2015 16:57:31 +0300
Message-ID: <559E7DCB.5040000@mellanox.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
	<559D1562.2070309@mellanox.com>
	<CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw@mail.gmail.com>
	<559D2A80.4040909@mellanox.com>
	<CAD+HZHWBn-KZCsskSGPKLtntj-LjDRodda9jngr+qcKSxLhkGQ@mail.gmail.com>
	<CAD+HZHXcrejwu=dAhmL7vZ=tkAPswm2LiCgwK42kEe5XDvBvhQ@mail.gmail.com>
	<559E592D.5000201@mellanox.com>
 <CAD+HZHVukRdGnfTWHin8O=hUkuOq0SS_aPqxbqjKCmk--OHn=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHVukRdGnfTWHin8O=hUkuOq0SS_aPqxbqjKCmk--OHn=w@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 4:35 PM, Jack Wang wrote:
> We have other kernel modules together also the autotest
> infrastructure. It's not that easy to install a 3.18.14 kernel.

you said you are running on 3.18.14 and just replaced their stock RDMA 
stack with MLNX OFED

>
> I look into the code a little bit. I think the bug may relate
> radix_tree usage in mlx4_cq_free , OFED code in radix_tree_delete
> before synchronize_irq, but mainline code call radix_tree_delete after
> synchronize_irq,  does this matter?

possibly yes, as in life location && timings matter

> I'm building a new kernel with
> this small change:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
