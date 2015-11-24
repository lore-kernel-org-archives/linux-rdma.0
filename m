From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Mon, 23 Nov 2015 17:14:16 -0800
Message-ID: <5653B9E8.7020907@sandisk.com>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org> <20151122143215.GA14667@infradead.org>
 <5651D775.9090500@dev.mellanox.co.il> <20151122151034.GA29240@infradead.org>
 <5651DEA4.8040506@dev.mellanox.co.il> <20151122153106.GA26919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151122153106.GA26919-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/22/2015 07:31 AM, Christoph Hellwig wrote:
> On Sun, Nov 22, 2015 at 05:26:28PM +0200, Sagi Grimberg wrote:
>>> No. register_always=Y is already broken in 4.3, but register_always=N is
>>> now also broken in 4.4.
>>
>> OK, I'm confused so please let me understand slowly :)
>>
>> Your patch "ib_srp: initialize dma_length in srp_map_idb" solves
>> the register_always=Y dma_length = 0 WARN_ON() on 4.4-rc, does it solve
>> the data integrity errors too?
>
> No, it doesn't.
>
>> This code path is specific to srp because all other ULPs guarantee
>> no-gaps...
>
> Yes.  Life would be simpler if we could just set the virt_boundary
> on SRP, and Bart has indicated that he's willing to at least looks at
> this for the next merge window.

Hello Christoph,

Tomorrow I will try to reproduce this behavior on my test setup. I 
prepared a setup with kernel v4.4-rc2 and on which the SRP initiator and 
target are running on the same server. Tomorrow I will install xfstests 
and see whether these tests pass fine against an XFS filesystem.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
