From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ipath: fix error return code in ipath_register_ib_device()
Date: Thu, 28 Mar 2013 12:18:19 +0800
Message-ID: <CAPgLHd_wmyj=kLLfikrWxngnVKOp9iW1K9KU_bvix4UuFAfdvQ@mail.gmail.com>
References: <CAPgLHd-ZH-DTBKHBfppYX409qLddst46dXkZ_dn5c2i_A+YCQQ@mail.gmail.com>
	<32E1700B9017364D9B60AED9960492BC0DF6AB22@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0DF6AB22-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Mike,

On 03/27/2013 10:41 PM, Marciniszyn, Mike wrote:
>> -	if (ipath_verbs_register_sysfs(dev))
> I would suggest modifying ipath_verbs_register_sysfs() to correctly return the failure from device_create_file() in ret out of ipath_verbs.c:
>
> ...
>
> I will post a patch shortly for qib, which has the same ret flaw in the caller to qib_verbs_register_sysfs().    If you want me to hit both, I can.

Since your will change qib_verbs_register_sysfs() as the same, you can
change both of them.

Thanks,
Yongjun Wei


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
