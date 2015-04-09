From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Multicast Filtering - mlx4_SET_MCAST_FLTR
Date: Thu, 9 Apr 2015 19:56:52 +0530
Message-ID: <CANwwZzU7gVhaicvnmS26xBmi3rdDX01gAHWXbmAme7W5Aen4wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the mlx4 code and noticed that this function
mlx4_SET_MCAST_FLTR calls the mlx4_SET_MCAST_FLTR_wrapper which in
turns has an empty body.


So, I was just wondering if the multicast filtering functionality is disabled?

Is QP_ATTACH the replacement for this?

Couldn't understand so wanted your help on this...


Thanks

Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
