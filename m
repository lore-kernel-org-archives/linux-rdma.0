From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4 query in sriov mode
Date: Thu, 28 Aug 2014 22:58:50 +0530
Message-ID: <CANwwZzXowyGmg-cfCHQqeJ_iqjT+Ec+JPy+OWzNGeyN=hRqmPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,


I really appreciate this wonderful community which has immensely
helped me broaden my knowledge and understanding.


I was going through the mlx4 sriov code, trying to understand the
communication between the VF driver and the PF driver.

I was having a few queries..hoping to get a better understanding.


As I understand, the commands are communicated between VF and PF
through a mechanism called communication channel. VF writes to
specific address in its BAR space, PF gets an event and then proceeds
ahead to read the command from its BAR space and then complete the
execution of it..


Now, my query is, lets say the VF driver is not yet present and only
the PF driver is there...

In this case, can we simulate a VF command write and get notified
through an event?

For eg. we write to some offset in the PF BAR space itself upon
completion of which, an event is generated because of the write? kind
of like loopback mechanism.


I searched through the code but couldn't find anywhere.

Can anyone please help me understand if this is possible? And if there
is any location in the code where i can find this?

Thanks a lot in advance!!


Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
