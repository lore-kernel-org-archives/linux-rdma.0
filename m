From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4: using dma_sync_single_for_cpu/dma_sync_single_for_cpu for
 writing MTT instead of WRITE_MTT hcr command
Date: Wed, 9 Jul 2014 18:40:46 +0530
Message-ID: <CANwwZzXShD8DvJb8vEeJrcwKeW4T0cx-zFdo1Mt1JftxCXtboA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the mr.c file as part of understanding WRITE_MTT
command in the mlx4 code.

I could see that instead of issuing the WRITE_MTT HCR command, in case
of SRIOV, we're directly accessing the ICM space for the MTT Table,
taking the ownership and updating it. We're doing this using
dma_sync_single_for_cpu and dma_sync_single_for_cpu.

I was curious as to why this approach was chosen instead of using the
HCR command.

Can anyone please explain the reason/motivation behind this approach?



Thanks so much,


Best Regards,
Marc
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
