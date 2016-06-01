From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Fix a recently introduced locking bug
Date: Wed, 1 Jun 2016 13:26:50 -0700
Message-ID: <44db361b-d5e1-a529-be62-b03a7d9f9163@sandisk.com>
References: <56F55A3C.2080608@sandisk.com>
 <CAAk-MO9BbZ_cpT2vQofG3DLCXfV1CAtqm1je1KE1u1Y3Gg8Pdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO9BbZ_cpT2vQofG3DLCXfV1CAtqm1je1KE1u1Y3Gg8Pdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/27/2016 03:30 AM, Erez Shitrit wrote:
> On Fri, Mar 25, 2016 at 6:33 PM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> ib_cm_notify() can be called from interrupt context. Hence do not
>> reenable interrupts unconditionally in cm_establish().
>>  [ ... ]
>> Fixes: commit be4b499323bf (IB/cm: Do not queue work to a device that's going away)
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>
> Acked-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello Doug,

Do you think it will be possible to send this patch to Linus before 
kernel v4.7 is released?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
