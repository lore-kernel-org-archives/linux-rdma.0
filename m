From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Thu, 7 Sep 2017 12:15:30 -0400
Message-ID: <34b036d2-2841-8a1d-412d-3dd8e0c93b4c@talpey.com>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net>
 <1230f9d9-07c1-6d00-b197-f408712fb5c1@grimberg.me>
 <890CC58C-7F8F-4B7E-8620-21F07007D3AA@oracle.com>
 <6dcdcc25-2613-cdb5-1db2-6c944f05242b@grimberg.me>
 <4E2E5580-69A5-4C3B-9FCA-E61AE2042E6B@oracle.com>
 <9059315f-1985-042e-a59f-26a66fbece3e@grimberg.me>
 <5B2F42B8-2CBD-43F4-BBAD-71EDD4F871FB@oracle.com>
 <20170906193946.GC18461@obsidianresearch.com>
 <f2cb453d-a59f-de64-7a42-09e075562895@talpey.com>
 <20170907150829.GA20644@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170907150829.GA20644-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/7/2017 11:08 AM, Jason Gunthorpe wrote:
> On Thu, Sep 07, 2017 at 09:17:16AM -0400, Tom Talpey wrote:
> 
>>> Why is waiting for the send completion so fundamentally different from
>>> waiting for the remote RPC reply?
>>>
>>> I would say that 99% of time the send completion and RPC reply
>>> completion will occure approximately concurrently.
>>
>> Absolutely not. The RPC reply requires upper layer processing at
>> the server, which involves work requests, context switches, file
> 
> I should have said '99% of the time the SEND will occure approximately
> concurrently or sooner'

Ok, that I agree with. Unfortunately though, the code has to handle
either sequence, and sends do complete after replies in many cases.

One reason for that is the RNIC and network, but another is more
insidious. When sends and receives go to separate CQs, there's
basically no causality between the two, and they synchronize with
different MSI vectors (and therefore CPU cores), different locks,
and different upcall code paths. There's no way to sort that out
without serializing everything much too heavily.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
