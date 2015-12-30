From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V3 00/11] Add RoCE v2 support
Date: Wed, 30 Dec 2015 12:48:02 +0200
Message-ID: <5683B662.4070609@mellanox.com>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
 <568373E4.2080409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568373E4.2080409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/30/2015 8:04 AM, Or Gerlitz wrote:
> Hi Matan,
>
> I see these two smatch complaints on code added with this series, can
> you please take a look?
>
> drivers/infiniband/core/addr.c:503 rdma_resolve_ip_route() warn:
> variable dereferenced before check 'src_addr' (see line 500)
> drivers/infiniband/core/cma_configfs.c:172 make_cma_ports() warn: double
> check that we're allocating correct size: 8 vs 128
>

I'll send fixes for both of them. Thanks for posting this.

>
> Or.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
