From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/16] xprtrdma: Use workqueue to process RPC/RDMA replies
Date: Wed, 7 Oct 2015 10:48:43 -0400
Message-ID: <4983C0DB-A6E3-4A64-B822-8D45D9847C31@oracle.com>
References: <20151006142430.11788.42604.stgit@manet.1015granger.net> <20151006145924.11788.64757.stgit@manet.1015granger.net> <56152E96.9040400@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56152E96.9040400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Oct 7, 2015, at 10:39 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>=20
> On 10/6/2015 5:59 PM, Chuck Lever wrote:
>> The reply tasklet is fast, but it's single threaded. After reply
>> traffic saturates a single CPU, there's no more reply processing
>> capacity.
>>=20
>> Replace the tasklet with a workqueue to spread reply handling across
>> all CPUs.  This also moves RPC/RDMA reply handling out of the soft
>> IRQ context and into a context that allows sleeps.
>=20
> Hi Chuck,
>=20
> I'm probably missing something here, but do you ever schedule in
> the workqueue context? Don't you need to explicitly schedule after
> a jiffie or so the code works also in a non fully preemptable kernel?

Each RPC reply gets its own work request. This is unlike
the tasklet, which continues to run as long as there are
items on xprtrdma=E2=80=99s global tasklet queue.

I can=E2=80=99t think of anything in the current reply handler
that would take longer than a few microseconds to run,
unless there is lock contention on the transport_lock.

wake_up_bit can also be slow sometimes, but it schedules
internally.

Eventually the reply handler will also synchronously
perform R_key invalidation. In that case, I think there
will be an implicit schedule while waiting for the
invalidation to finish.


-=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
