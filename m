From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Thu, 8 Dec 2016 16:42:17 -0500
Message-ID: <ebbc49aa-6904-c632-b590-0594a55119cb@redhat.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <a909ae78-ed49-407a-29c7-b86729f356b8@redhat.com>
 <CA+sbYW1P4MqsBF14d9ZK_VjV4edU2bh=sLNTVnGs9F3ojF6vWQ@mail.gmail.com>
 <cd667d80-cc1b-c8df-07d1-a5e7b9f94c68@redhat.com>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd667d80-cc1b-c8df-07d1-a5e7b9f94c68-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/08/2016 04:08 PM, Doug Ledford wrote:
> On 12/8/2016 4:38 AM, Selvin Xavier wrote:
>> On Thu, Dec 8, 2016 at 5:03 AM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> +#include <net/dcbnl.h>
>>
>> in the kernel which i used for compilation and testing,
>> linux/netdevice.h is including net/dcbnl.h. bnxt_re_main.c is
>> including netdevice.h.  Anyway, i will add this explicitly in
>> bnxt_re_main.c in V2.
>>
>> Doug,
>>  Since David Miller applied the bnxt_en changes to his net-next tree
>> (both pending patches and bnxt_re related changes), can you please
>> pull those changes to your bnxt_re branch?
>>
>> Thanks,
>> Selvin
>>
> 
> I had already pulled the changes, I just hadn't pushed them.  Now pushed.
> 

hummm ok I will retest. When I did the original compile test I did it on
top of net-next/master as well as rdma/k.o/for-4.10 + merge of
net-next/master + patches in this series not already merged into
net-next and still got compile error. So clearly there was a patch from
somewhere else I was missing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
