From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 08/14] xprtrdma: Acquire MRs in rpcrdma_register_external()
Date: Sun, 10 May 2015 13:17:39 +0300
Message-ID: <554F3043.4090303@dev.mellanox.co.il>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175758.3483.44890.stgit@manet.1015granger.net> <554B3EEB.7070302@dev.mellanox.co.il> <CANjDDBiGLcaAofGwz6OGEXUUE_b2rcZepv0ebvTc-XNVEBq5Mw@mail.gmail.com> <6FBAAAF3-3E70-418F-A887-C022525D6C4F@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6FBAAAF3-3E70-418F-A887-C022525D6C4F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/8/2015 6:40 PM, Chuck Lever wrote:

>>>
>>> Don't you need a call to flush_workqueue(frwr_recovery_wq) when you=
're
>>> about to destroy the endpoint (and the buffers and the MRs...)?
>>
>> I agree with Sagi here, in xprt_rdma_destroy() before calling
>> rpcrdma_destroy_buffer(), flush_workqueue and cancelling any pending
>> work seems required.
>
> The buffer list is destroyed only when all work has completed on the
> transport (no RPCs are outstanding, and the upper layer is shutting
> down). It=92s pretty unlikely that there will be ongoing recovery wor=
k
> at this point.

It may be that there aren't any outstanding RPCs, but it is possible
that those that finished queued a frwr recovery work if the QP flushed
inflight frwr's.

>
> That said, would it be enough to add a defensive call to flush_workqu=
eue()
> at the top of frwr_op_destroy() ?

If at this point you can guarantee that no one will queue another frwr
work (i.e. all flushe errors were consumed), then yes, I think
flush_workqueue() would do the job.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
