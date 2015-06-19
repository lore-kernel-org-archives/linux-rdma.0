From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upstream mlx4 driver very broken (when using SRIOV)
Date: Fri, 19 Jun 2015 13:41:52 +0300
Message-ID: <CAJ3xEMiiq_41jzkyuXyqcoUk-tV=i4grreQt_gNyQaXSdO-73Q@mail.gmail.com>
References: <557BC105.3070405@redhat.com>
	<CAJ3xEMi--ygFeYC12iiivXnbZLd=ox22fzt_f1+TFn7M0Emhug@mail.gmail.com>
	<CFEE2FE0-21D6-469F-8B16-C211DED6BB45@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CFEE2FE0-21D6-469F-8B16-C211DED6BB45-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 19, 2015 at 3:57 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Jun 14, 2015, at 10:31 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> The fix is easy, disable Granular VF QoS in that VPI config, I tested
>> it and sent that now to net [1]


> Did this fix the mlx4_en shutdown issue too, or is there another patch needed for that?

I don't think it would. I wasn't able to reproduce that one BTW, do
you see it only with your VPI IB/Eth SRIOV config or elsewhere too?
did the fix I sent solved the SQP SRIOV issue?


>> [1] http://patchwork.ozlabs.org/patch/483991/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
