From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 06/16] xprtrdma: Use workqueue to process RPC/RDMA
 replies
Date: Wed, 7 Oct 2015 18:17:26 +0300
Message-ID: <56153786.2000801@dev.mellanox.co.il>
References: <20151006142430.11788.42604.stgit@manet.1015granger.net>
 <20151006145924.11788.64757.stgit@manet.1015granger.net>
 <56152E96.9040400@dev.mellanox.co.il>
 <4983C0DB-A6E3-4A64-B822-8D45D9847C31@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4983C0DB-A6E3-4A64-B822-8D45D9847C31-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/7/2015 5:48 PM, Chuck Lever wrote:
>
>> On Oct 7, 2015, at 10:39 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>>
>> On 10/6/2015 5:59 PM, Chuck Lever wrote:
>>> The reply tasklet is fast, but it's single threaded. After reply
>>> traffic saturates a single CPU, there's no more reply processing
>>> capacity.
>>>
>>> Replace the tasklet with a workqueue to spread reply handling acros=
s
>>> all CPUs.  This also moves RPC/RDMA reply handling out of the soft
>>> IRQ context and into a context that allows sleeps.
>>
>> Hi Chuck,
>>
>> I'm probably missing something here, but do you ever schedule in
>> the workqueue context? Don't you need to explicitly schedule after
>> a jiffie or so the code works also in a non fully preemptable kernel=
?
>
> Each RPC reply gets its own work request. This is unlike
> the tasklet, which continues to run as long as there are
> items on xprtrdma=E2=80=99s global tasklet queue.

OK I understand now.

So this and the rest of the series looks good to me.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
