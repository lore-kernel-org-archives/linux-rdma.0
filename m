From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: cqe dump errors on target while running nvme-of large block read
 IO
Date: Thu, 20 Apr 2017 16:23:09 +0300
Message-ID: <991b26ec-69d3-9e1c-ed3e-0d6e6618e73a@grimberg.me>
References: <DE927C68B458BE418D582EC97927A9285505C9EA@ORSMSX113.amr.corp.intel.com>
 <47f19583-1882-09d4-ce1c-534b8e59068b@mellanox.com>
 <DE927C68B458BE418D582EC97927A9285505F0C9@ORSMSX113.amr.corp.intel.com>
 <52c550c1-849b-7ea5-ab34-56543cb9069d@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52c550c1-849b-7ea5-ab34-56543cb9069d-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org'" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Sen, Sujoy" <sujoy.sen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> hi Joe,
>>> can you run and repro it with null_blk backing store instead the nvme ?
>>> you can emulate the delay of the nvme device using module param
>>> completion_nsec.
>>> is it reproducable in case B2B connectivity ?
>>
>> Hey Max,
>>
>> I ran overnight using null_blk devices but was unable to reproduce in
>> that configuration.  I set completion_nsec to 50000.  Although my
>> measured completion latencies in FIO were more like 17-18usec so not
>> sure why they did not come in closer to 50usec.  Anyway, failure did
>> not reproduce using null_blk instead of real NVMe SSDs.
>
> Hi,
> you should set also the irqmode=2 (timer) and run local fio with
> iodepth=1 and numjobs=1 to verify the latency (worked for me).
> Let's try to repro again with the new configuration, to be sure that
> this is not a transport issue.

The backend has absolutely nothing to do with these errors.

The target side cqe dumps indicate failures for RDMA write operations,
because we don't ask for completions on those we don't see logging from
the nvmet-rdma code, we simply trigger fatal errors from the rain of
flush errors that follow the queue-pair moving to error state.

These errors are either from:
1. mapping error on the host side - not sure given we don't see
any error completions/events from the rdma device. However, can you
turn on dynamic debug to see QP events?

echo "func nvme_rdma_qp_event +p" > /sys/kernel/debug/dynamic_debug/control

2. retry exhaustions due to network congestion - likely due to the
topology used.

3. Maybe something I'm missing...

The fact that null_blk didn't reproduce this was probably because it is
less bursty (which can cause network congestion).

On the host side we see I/O failures which immediately followed by
reconnect. On reconnects we stop all incoming IO and fail all IO
inflight so we can safely handle the reestablishment of the controller
queues. The fact that we fail the IO and remove the buffer mappings
correlates with the cqe dumps we see on the target.

So what I suspect happening is:
1. target tries to ingest a lot servicing large reads (more than 25G)
2. either flow control stop the target device (in case flow
control works as expected) or target retries handling drops.
3. these rdma writes stall so much that the host gives up on
I/O timeout (30 seconds)
4. host error recovery kicks in, host stops queues and fast fail
inflight IO, removing buffer mappings
5. target retries finally passes switch congestion, makes it to the
host but the buffer mappings are gone, host device fails rdma write
operations.
6. target generates these CQE dumps.

If this is the case, I'm not exactly sure how to resolve this.

Joseph, are you sure that flow control is correctly configured
and working reliably?

Perhaps the experts in Linux-rdma can help...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
