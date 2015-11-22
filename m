From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: srp state in current mainline
Date: Sun, 22 Nov 2015 17:26:28 +0200
Message-ID: <5651DEA4.8040506@dev.mellanox.co.il>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org> <20151122143215.GA14667@infradead.org>
 <5651D775.9090500@dev.mellanox.co.il> <20151122151034.GA29240@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151122151034.GA29240@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 22/11/2015 17:10, Christoph Hellwig wrote:
> On Sun, Nov 22, 2015 at 04:55:49PM +0200, Sagi Grimberg wrote:
>>>> Also note that 4.4-rc  prefer_fr=y register_always=n
>>>> !register_always still blows up badly with XFS and ext4 due to
>>>> data integrity errors.
>>
>> So the register_always=N makes bad things happen? if we register
>> all the frags we're OK (i.e. register_always=Y)?
>
> No. register_always=Y is already broken in 4.3, but register_always=N is
> now also broken in 4.4.

OK, I'm confused so please let me understand slowly :)

Your patch "ib_srp: initialize dma_length in srp_map_idb" solves
the register_always=Y dma_length = 0 WARN_ON() on 4.4-rc, does it solve
the data integrity errors too?

> The 4.3+ issue that only affects register_always=Y is the FR mapping
> of the indirect buffer that is not accounted for.

So it fails because there are no free FRs to use. I see.


> The 4.4+ issue that also affects register_always=N is something in your
> MR patches when we hit a gappy SG list.

This is something I'd need to look at. I tested this code path using
Bart's discontigiuous_io utility and didn't see problems.

This code path is specific to srp because all other ULPs guarantee
no-gaps...
