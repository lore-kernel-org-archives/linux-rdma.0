From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4 qp allocation
Date: Tue, 11 Feb 2014 13:31:41 +0200
Message-ID: <20140211133141.7d5f4929@jpm-OptiPlex-GX620>
References: <CANwwZzUfoNB1pyyu8VC2Do3mvCBOmeam+_9CAEW-eQbVCMdHNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANwwZzUfoNB1pyyu8VC2Do3mvCBOmeam+_9CAEW-eQbVCMdHNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 29 Jan 2014 15:52:09 +0530
Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> These paths are taken based on the return value of mlx4_is_func(dev).
> This is true for MASTER or SLAVE which I believe is Physical Function
> Driver/Virtual Function Driver. So for SRIOV, it covers all cases.
> 
> The MAP_ICM portion which gets executed as part of __mlx4_qp_alloc_icm
> never gets called??

For slaves (VFs), the command is sent via the comm channel to the
Hypervisor.  It is the Hypervisor which invokes map_icm on behalf of
that slave.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
