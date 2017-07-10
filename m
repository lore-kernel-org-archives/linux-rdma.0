From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 10 Jul 2017 18:04:18 -0400
Message-ID: <A342254B-1ECB-4644-8D68-328A52940C52@oracle.com>
References: <f1f1a68c-90db-e6bf-e35e-55c4b469c339@grimberg.me> <7D1C540B-FEA0-4101-8B58-87BCB7DB5492@oracle.com> <66b1b8be-e506-50b8-c01f-fa0e3cea98a4@grimberg.me> <9D8C7BC8-7E18-405A-9017-9DB23A6B5C15@oracle.com> <11aa1a24-9f0b-dbb8-18eb-ad357c7727b2@grimberg.me> <9E30754F-464A-4B62-ADE7-F6B2F6D95763@oracle.com> <20170709164755.GB3058@obsidianresearch.com> <A7C8C159-E916-4060-9FD1-8726D816B3C0@oracle.com> <20170710212430.GA21721@obsidianresearch.com> <C142385D-3A54-44C9-BA3D-0AABBC5E9E7B@oracle.com> <20170710213251.GA21908@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170710213251.GA21908-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jul 10, 2017, at 5:32 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> On Mon, Jul 10, 2017 at 05:29:53PM -0400, Chuck Lever wrote:
>> 
>>> On Jul 10, 2017, at 5:24 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>> 
>>> On Mon, Jul 10, 2017 at 03:03:18PM -0400, Chuck Lever wrote:
>>> 
>>>>>> Or I could revert all the "map page cache pages" logic and
>>>>>> just use memcpy for small NFS WRITEs, and RDMA the rest of
>>>>>> the time. That keeps everything simple, but means large
>>>>>> inline thresholds can't use send-in-place.
>>>>> 
>>>>> Don't you have the same problem with RDMA WRITE?
>>>> 
>>>> The server side initiates RDMA Writes. The final RDMA Write in a WR
>>>> chain is signaled, but a subsequent Send completion is used to
>>>> determine when the server may release resources used for the Writes.
>>>> We're already doing it the slow way there, and there's no ^C hazard
>>>> on the server.
>>> 
>>> Wait, I guess I meant RDMA READ path.
>>> 
>>> The same contraints apply to RKeys as inline send - you cannot DMA
>>> unmap rkey memory until the rkey is invalidated at the HCA.
>>> 
>>> So posting an invalidate SQE and then immediately unmapping the DMA
>>> pages is bad too..
>>> 
>>> No matter how the data is transfered the unmapping must follow the
>>> same HCA synchronous model.. DMA unmap must only be done from the send
>>> completion handler (inline send or invalidate rkey), from the recv
>>> completion handler (send with invalidate), or from QP error state teardown.
>>> 
>>> Anything that does DMA memory unmap from another thread is very, very
>>> suspect, eg async from a ctrl-c trigger event.
>> 
>> 4.13 server side is converted to use the rdma_rw API for
>> handling RDMA Read. For non-iWARP cases, it's using the
>> local DMA key for Read sink buffers. For iWARP it should
>> be using Read-with-invalidate (IIRC).
> 
> The server sounds fine, how does the client work?

The client does not initiate RDMA Read or Write today.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
