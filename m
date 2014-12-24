From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: does i need compat-rdma package
Date: Wed, 24 Dec 2014 16:02:07 +0400
Message-ID: <CACaajQvC6s3bzx+i9FLXYOEiHOTPme4MtnaW3nv8S+DKKvGRow@mail.gmail.com>
References: <CACaajQs03WqcSdrxF3r78wGKL494V5YS5Woa8tW4t1e3qAGGaQ@mail.gmail.com>
 <549A772D.1040608@mellanox.com> <CACaajQvDQ9N9v_q1AAk+bxpMbQ947FEJ7dqTaG9Nj9i--4-9Bw@mail.gmail.com>
 <549AA5B6.3020106@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <549AA5B6.3020106-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-12-24 14:38 GMT+03:00 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> AF_IB was merged in 3.11, BTW - can you share what's your motivation to use
> it? as for rsockets, basically any kernel thatsupports the rdma_cm along
> with it's user-space device, this goes a while back... you mentioned 3.14,
> should be OK


I'm try to modify sheepdog and qemu to allows via name name guid and
establish communication with remote node without IPoIB.
But my knowledge about rdma not very good, and i try to see sources
and write simple app =).


-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
