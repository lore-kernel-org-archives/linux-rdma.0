From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Thu, 28 Dec 2017 11:48:31 +0200
Message-ID: <CAG9sBKNo=puiSJOHdg6mBLge2dsGEGCkmoGXNOL_JQRLoMJqCg@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMhoxazkdiO0wpCz-j30x-CAxBk+4sB8NYYugvts0T9s4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhoxazkdiO0wpCz-j30x-CAxBk+4sB8NYYugvts0T9s4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> +       if (verbs_init_attr->qp_type == IB_QPT_DRIVER)
>> +               qp->driver_qp_type = init_attr->qp_type;
>> +
>>         return &qp->ibqp;
>>  }

> so if the values passed by user space are legal and the FW supports
> DC, no error is returned to user-space, right? this doesn't seem bisectable,
> if only patches 1...4 are applied, create qp will succeed?
Wrong. Create QP will  fail before code reaches this line. Only after
applying the following patches in the series the operations of
create/modify will succeed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
