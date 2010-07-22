From: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: mlx4_core unable to use MSI-x on our nodes
Date: Thu, 22 Jul 2010 10:56:55 -0700
Message-ID: <6203933669E90E4AB42B5BC4EDE38D350CF01EF379@orsmsx510.amr.corp.intel.com>
References: <AANLkTinco6znrHkoE9vL1n7KrrZ68zPExPUPQeDHD64i@mail.gmail.com>
 <Pine.GSO.4.40.1007221320200.17-300000@kappa.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.40.1007221320200.17-300000-ItQMRKI8FOvVp4Hyp30HIZ9NZdITTVap@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In our dmesg log I see "mlx4_core 0000:02:00.0: Only 12 MSI-X vectors available, need 25. Not using MSI-X" which if I read it correctly says our mlx4_core is unable to use MSI-X which if I also understand correctly means the mlx4_core can't use the sharing of interrupts among all processors.

If this is correct, do we want to try to fix this so the mlx4_core can use MSI-X and share the interrupts?

And if we do want to fix this, do you have any suggestions for how to fix it?

Thanks,
Don Meyer
Senior Network/System Engineer/Programmer
US+ (253) 371-9532 iNet 8-371-9532
*Other names and brands may be claimed as the property of others

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
