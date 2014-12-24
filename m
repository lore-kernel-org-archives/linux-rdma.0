From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: does i need compat-rdma package
Date: Wed, 24 Dec 2014 10:19:57 +0200
Message-ID: <549A772D.1040608@mellanox.com>
References: <CACaajQs03WqcSdrxF3r78wGKL494V5YS5Woa8tW4t1e3qAGGaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQs03WqcSdrxF3r78wGKL494V5YS5Woa8tW4t1e3qAGGaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/23/2014 4:47 PM, Vasiliy Tolstov wrote:
> Hello. I want to develop some software under linux 3.14 and using
> infiniband libraries.

You can use the inbox libraries and install them through your distro 
package installer, with RHEL, Fedora and such
it would be just

$ yum groupinstall "infiniband support"

to get you the set of required RPMS [1] SLES and Ubuntu should have 
similar means, no need to use OFED, compat, etc.

Or.

[1] you mentioned ConnectX-3, so your basic needs are libmlx4, 
libibverbs and librdmacm

> I'm download latest ofed (3.12 ?) and see that
> some packages i don't need (i'm use only mellanox connect x3)
> But i can't understand in case of linux 3.14 does i need compat-rdma ?
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
