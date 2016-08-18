From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Thu, 18 Aug 2016 11:15:45 +0300
Message-ID: <d7cc807e-1a46-03c7-e6ba-3707ca9d61e8@mellanox.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <80ff6d05-201a-3fa6-deab-2dbb035a89c3@mellanox.com>
 <HE1PR05MB1418BA4382257289AB9DEA63CE150@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418BA4382257289AB9DEA63CE150-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/18/2016 10:55 AM, Yishai Hadas wrote:
>> 3) Add IBV_WC_TSO to be used as part of poll_cq to report a TSO completion.
>>
>> why is that needed? what's the proposed/possible applicative usage of
>> that bit?
> It's consistent with the kernel API that adds similar bit for LSO.
> http://lxr.free-electrons.com/source/include/rdma/ib_verbs.h#L842

C&P is not something you want to use as argument, specifically if no one 
uses this 10y old define nowadays (and maybe never)

net.git]# git grep IB_WC_LSO drivers/infiniband/ include/rdma/
drivers/infiniband/hw/mlx4/cq.c: wc->opcode    = IB_WC_LSO;
include/rdma/ib_verbs.h:        IB_WC_LSO,


> Specifically, it can give an application an accurate  knowledge about the completion type as done for other cases as part of ibv_post_send as of IBV_WC_BIND_MW, IBV_WC_LOCAL_INV, etc.

IPoIB uses LSO for 10y and doesn't need that, I don't see why user-space 
IPoIBs would need that


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
