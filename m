From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Tue, 24 Jan 2017 00:20:26 +0200
Message-ID: <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Robert,

Seeing this, makes me realize that the entire "iscsi_trx going
into D state" thread which I did not bother to read is actually an
iser-target related bug. I'm really sorry for not addressing this
sooner (much sooner).

The patch looks wrong to me, but lets try and talk about
the hang you are trying to solve.

> In certain circumstances the RDMA connection can be abruptly
> terminated,

Does it make a difference which port is causing the abruption?
Is it the target switch port? or the initiator switch port?

> but something is getting stuck preventing the iSCSI clean
> up commands from being completed.

I think this means, that at least one command was missing
a final kref_put and causing target_wait_for_sess_cmds() to
block forever.

> Just removing the isert_wait4*
> commands isn't enough.

Yes, because all the inflight IO needs to be properly cleaned up
for the session to terminate gracefully.

> Just resetting the queue pair isn't enough
> either.

This is true as well. Before tearing down the RDMA queue pair we
need to make sure we will never see a completion for it on its
corresponding completion queue. This is why ib_drain_qp exists.

> some help getting this patch fixed right as resetting the queue pair
> is probably not the right approach and overkill to solving the
> problem. I think it at least shows where the problem is occurring and
> how I can get around it.

As said, I have a feeling that we have a flow we are missing the last
kref_put on (at least) one of the session commands. The fact that this
involves port toggling, probably boils down to error completions.

Bart, I recall you had a patch at some point to periodically print
out the hanging session commands in target_wait_for_sess_cmds(), do we
want to get it in? I think we can all benefit from it.

Would it be possible to turn on isert debug_level=4 and send us the log?
$ echo 4 > /sys/module/ib_isert/parameters/debug_level

> The problem easily shows up with two ConnectX-4-LX card connected to a
> 10 Gb switch. The target is a RAM disk and the initiator just mounts
> it as ext4 and runs fio.

Can you please share the fio workload? Does this happen when for example
you run 100% read workload? or 100% write workload?

And, can you try and disable the unsolicited-data-out in the target
(IIRC its InitialR2T=Yes)? unsol dataout has been known to trigger
cause similar hangs before (which were supposed to be solved).

Also, can you please summarize what kernel versions do you see this
with? The previous thread is a bit hard to follow at once.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
