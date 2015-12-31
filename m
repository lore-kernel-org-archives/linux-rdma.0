From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/core: Allocating larger memory than required for cma_configfs
Date: Thu, 31 Dec 2015 10:50:43 +0200
Message-ID: <CAAKD3BB25Nq7AuojA1diMVmFjpX+1o3Ei_AkJK8K8oM0Sw8=1w@mail.gmail.com>
References: <1451484858-1530-1-git-send-email-matanb@mellanox.com>
	<5684DE5D.7040700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5684DE5D.7040700-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 31, 2015 at 9:50 AM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 12/30/2015 03:14 PM, Matan Barak wrote:
>>
>> We were allocating larger memory space than requried for
>> cma_dev_group->default_ports_group.
>
>
> Please change the subject into something like "Do not allocate more ...".
> Please also fix the spelling error in the patch description.
>

No problem, I'll fix and send V1.

> Thanks,
>
> Bart.
>

Regards,
Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
