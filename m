From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 8 Oct 2015 09:25:57 +0300
Message-ID: <CALq1K=+E-q1C6peWHPmkXxFnPWfQwXxnAitkRNuEEGx-Uh9mww@mail.gmail.com>
References: <1443091747-13881-1-git-send-email-wen.gang.wang@oracle.com>
 <CAJ3xEMgN4_gk4_hVXOW2GhcfnXxgPnm=Lrc7JwkxBAeKv4KRAQ@mail.gmail.com>
 <56049A8A.6040101@oracle.com> <20151008060609.GA19101@leon.nu> <561609D9.2080404@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561609D9.2080404-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 8, 2015 at 9:14 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 10/8/2015 9:06 AM, Leon Romanovsky wrote:
>>
>> Additionally, I want to spot Or's attention on the following discussion
>> in MM-subsystem about kmalloc/vmalloc and general function to fallback
>> from one to another.
>>
>>
>
> too busy to read them now, if you have review comments speak now and provide
> them to the author.
My comments to author that from my point of view this patch is a
correct to fix current behaviour.

The more general solution (I doubt if it is feasible) is to decrease
the dependency on high order allocations.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
