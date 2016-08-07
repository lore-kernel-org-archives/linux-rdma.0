From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
Date: Sun, 7 Aug 2016 20:19:39 +0800
Message-ID: <087f4381-d830-fc57-ea5d-c516a1b160b5@gmail.com>
References: <1470445284-28970-1-git-send-email-weiyj.lk@gmail.com>
 <20160807053115.GQ27667@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160807053115.GQ27667-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/07/2016 01:31 PM, Leon Romanovsky wrote:
> On Sat, Aug 06, 2016 at 01:01:24AM +0000, Wei Yongjun wrote:
>> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
>> and never returns NULL. The NULL test in the return value check should
>> be replaced with IS_ERR().
>>
>> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> On which branch did you base your patch?
> It would be helpful to us if you followed SubmittionPatches document,
> section with Fixes description. In such case "git describe" will give
> immediate answer on my first question.
>
This patch is based on the linux-next.git tree.
Fixes: 5e43122add63 ('IB/hns: Add driver files for hns RoCE driver')

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
