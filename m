From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: does i need compat-rdma package
Date: Wed, 24 Dec 2014 14:20:26 +0400
Message-ID: <CACaajQvDQ9N9v_q1AAk+bxpMbQ947FEJ7dqTaG9Nj9i--4-9Bw@mail.gmail.com>
References: <CACaajQs03WqcSdrxF3r78wGKL494V5YS5Woa8tW4t1e3qAGGaQ@mail.gmail.com>
 <549A772D.1040608@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <549A772D.1040608-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-12-24 11:19 GMT+03:00 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> You can use the inbox libraries and install them through your distro package
> installer, with RHEL, Fedora and such
> it would be just
>
> $ yum groupinstall "infiniband support"
>
> to get you the set of required RPMS [1] SLES and Ubuntu should have similar
> means, no need to use OFED, compat, etc.
>
> Or.
>
> [1] you mentioned ConnectX-3, so your basic needs are libmlx4, libibverbs
> and librdmacm


Thanks, last question - i'm try to use rsocket and AF_IB in my app,
what minimal kernel version does support this?


-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
