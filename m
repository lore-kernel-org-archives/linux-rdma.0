From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4 VLAN filtering support: mlx4_SET_VLAN_FLTR_wrapper
Date: Tue, 24 Feb 2015 22:59:27 +0530
Message-ID: <CANwwZzWbe8pZc9Ta6HTuEY2CUVZjVhFMDCjmHZ79by4-Oaeayg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the code and noticed that this function
mlx4_SET_VLAN_FLTR_wrapper has an empty body and returns success.

Also this function mlx4_common_set_vlan_fltr doesn't have an implementation.

I was going through the 3.19 Linux kernel.


So, does that mean VLAN filtering is not being handled in mlx4?

Any other place this code has been moved to?


Thanks

Best Regards,
Ahsan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
