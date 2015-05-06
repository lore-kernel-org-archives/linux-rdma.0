From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Wed, 06 May 2015 15:15:57 +0300
Message-ID: <554A05FD.5080605@dev.mellanox.co.il>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net> <20150505154411.GA16729@infradead.org> <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com> <20150505172540.GA19442@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150505172540.GA19442-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/5/2015 8:25 PM, Christoph Hellwig wrote:
> On Tue, May 05, 2015 at 12:04:00PM -0400, Chuck Lever wrote:
>>> Just curious if you ever though of moving this into the generic
>>> rdma layer?
>>
>> Not really. The new files are really just shims that adapt the RPC/RDMA
>> transport to memory registration verbs. There?s only a few hundred lines
>> per registration mode, and it?s all fairly specific to RPC/RDMA.
>
> While it's using RPC/RDMA specific data structures it basically
> abstracts out the action of mapping a number of pages onto the rdma
> hardware.   There isn't a whole lot of interaction with the actual
> sunrpc layer except for a few hardcoded limits.
>
> Btw, this is not a critique of the code, it's an obvious major
> improvement of what was there before, it justs seems like it would be
> nice to move it up to a higher layer.
>
>>> And from I see we litterly dont use them much different from the generic
>>> dma mapping API helpers (at a very high level) so it seems it should
>>> be easy to move a slightly expanded version of your API to the core
>>> code.
>>
>> IMO FRWR is the only registration mode that has legs for the long term,
>> and is specifically designed for storage.
>>
>> If you are not working on a legacy piece of code that has to support
>> older HCAs, why not stay with FRWR?

Hey Christoph,

I agree here,

FMRs (and FMR pools) are not supported over VFs. Also, I've seen some
unpredictable performance in certain workloads because the fmr pool
maintains a flush thread that executes a HW sync (terribly blocking on
mlx4 devices) when hitting some dirty_watermark...

If you are writing a driver, I suggest to stick FRWR as well.

>
> The raw FRWR API seems like an absolute nightmare, and I'm bound to
> get it wrong at first :)  This is only half joking, but despite that
> it's the first target for sure.  It's just very frustrating that there
> is no usable common API.

The FRWR API is a work request interface. The advantage here is the
option to concatenate it with a send/rdma work request and save an extra
send queue lock and more importantly a doorbell. This matters in high
workloads. The iser target is doing this and I have a patch for the
initiator code as well.

I'm not sure that providing an API that allows you to do post-lists
might be simpler...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
