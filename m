From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Querying the GID from a Provider Library
Date: Wed, 1 Feb 2017 18:11:07 +0200
Message-ID: <d435251a-00a9-9304-afed-76aa46f0aa26@dev.mellanox.co.il>
References: <SN1PR07MB22070E07E3610AFDD7F6DD97F84D0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB22070E07E3610AFDD7F6DD97F84D0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/1/2017 2:26 PM, Amrani, Ram wrote:
> Hi Doug, Yishay,
> I need to translate sgid_index to sgid in the library to check for loopback.
>
> While invoking ibv_query_gid does the job, it seems to me somewhat
> inadequate that a provider library invokes an ibv function and not
> an ibv_cmd function. What are your thoughts on this?
>
> I would have invoked the  ibv_cmd_query_gid, but there is no such function
> because ibv_query_gid does not require the kernel. However there's an old
> *declaration* of the ibv_cmd_query_gid. Perhaps I will define the function
> in a similar way to ibv_query_gid?!

ibv_query_gid is used all around by vendors, it serves as some helper 
function which is exported from libibverbs, you can just use it.

Re 'ibv_cmd_query_gid' looks like some 'dead' code that should be delted.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
