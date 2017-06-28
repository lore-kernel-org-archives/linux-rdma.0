From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Wed, 28 Jun 2017 12:11:55 -0400
Message-ID: <7D1C540B-FEA0-4101-8B58-87BCB7DB5492@oracle.com>
References: <20170620074639.GP17846@mtr-leonro.local> <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me> <20170620083309.GQ17846@mtr-leonro.local> <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me> <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me> <59FF0C04-2BFB-4F66-81BA-A598A9A087FC@oracle.com> <20170620173532.GA827@obsidianresearch.com> <D3DC49A2-FFC9-4F62-8876-3E6AD5167DE5@oracle.com> <20170620192742.GB827@obsidianresearch.com> <C14B071E-F1B2-466A-82CF-4E20BFAD9DC1@oracle.com> <20170620211958.GA5574@obsidianresearch.com> <4f0812f1-0067-4e63-e383-b913ee1f319d@grimberg.me> <28F6F58E-B6F4-4114-8DFF-B72353CE814B@oracle.com> <52ad3547-efcf-f428-6b39-117efda3379f@grimberg.me> <9990B5CB-E0FF-481E-9F34-21EACF0E796E@oracle.com> <f1f1a68c-90db-e6bf-e35e-55c4b469c339@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f1f1a68c-90db-e6bf-e35e-55c4b469c339-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 28, 2017, at 3:08 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> Thinking out loud:
>> IIRC the message head and tail reside in the persistently registered
>> and DMA mapped buffers with few exceptions.
>> However, when page cache pages are involved, xprtrdma will do a DMA
>> unmap as you say.
>> So:
>> - we don't have a problem transmitting a garbled request thanks to
>>   exactly-once receive semantics
>> - we don't have a problem with the timing of registration and
>>   invalidation on the initiator because the PD's DMA lkey is used
>> - we do have a problem with DMA unmap
>> Using only persistently registered and DMA mapped Send buffers
>> should avoid the need to signal all Sends. However, when page
>> cache pages are involved, then the Send needs to be signaled,
>> and the pages unmapped only after Send completion, to be completely
>> safe.
> 
> How do you know when that happens?

The RPC Call send path sets up the Send SGE array. If it includes
page cache pages, it can set IB_SEND_SIGNALED.

The SGE array and the ib_cqe for the send are in the same data
structure, so the Send completion handler can find the SGE array
and figure out what needs to be unmapped.

The only problem is if a POSIX signal fires. In that case the
data structure can be released before the Send completion fires,
and we get touch-after-free in the completion handler.

I'm thinking that it just isn't going to be practical to handle
unmapping this way, and I should just revert back to using RDMA
Read instead of adding page cache pages to the Send SGE.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
