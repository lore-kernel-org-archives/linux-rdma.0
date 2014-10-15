From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: issue while executing RST2INIT_QP
Date: Wed, 15 Oct 2014 17:58:55 +0530
Message-ID: <CANwwZzXS3TgV+J=rKuVfxcz-1AR-vfcvwKtyg58r5eD8RS8akQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I ran into an issue while executing RST2INIT_QP HCR command on mlx4.

The command gets completed, but returns a status 3 instead of 0.

The 3 indicates that the QP number is reserved.

I did allocate ICM for all the QPs. I am using SRIOV mode.

The reserved number of QPs obtained from QUERY_DEV_CAP is 64.

My profile indicates I am using 2048 QPs. so as i understand QP
numbers from 65 to 2047 should not be reserved by the firmware..


Any idea why I am seeing this error?
Please help me debug the same, will be very much grateful to you.


Thanks

Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
