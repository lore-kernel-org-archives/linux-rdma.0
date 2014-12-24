From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: does i need compat-rdma package
Date: Wed, 24 Dec 2014 18:03:15 +0900
Message-ID: <CA+Tq-Rq_2ieyc=Z37G70w2=3oHVr3dA_hOMAvZV2CqoPMFyc6w@mail.gmail.com>
References: <CACaajQs03WqcSdrxF3r78wGKL494V5YS5Woa8tW4t1e3qAGGaQ@mail.gmail.com>
	<549A772D.1040608@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <549A772D.1040608-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Vasilly Tolstov

This URL might be help.
http://www.rdmamojo.com

There are RDMA configuration for many OSs. (RHEL, Ubuntu, SLES..)

--
Hiroyuki Sato



2014-12-24 17:19 GMT+09:00 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> On 12/23/2014 4:47 PM, Vasiliy Tolstov wrote:
>>
>> Hello. I want to develop some software under linux 3.14 and using
>> infiniband libraries.
>
>
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
>
>> I'm download latest ofed (3.12 ?) and see that
>> some packages i don't need (i'm use only mellanox connect x3)
>> But i can't understand in case of linux 3.14 does i need compat-rdma ?
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hiroyuki Sato
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
