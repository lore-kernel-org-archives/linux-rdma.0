From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: srp state in current mainline
Date: Wed, 25 Nov 2015 11:34:30 -0800
Message-ID: <56560D46.1070904@sandisk.com>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org> <20151122143215.GA14667@infradead.org>
 <5651D775.9090500@dev.mellanox.co.il> <20151122151034.GA29240@infradead.org>
 <5651DEA4.8040506@dev.mellanox.co.il> <20151122153106.GA26919@infradead.org>
 <5653B9E8.7020907@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5653B9E8.7020907@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/23/2015 05:14 PM, Bart Van Assche wrote:
> On 11/22/2015 07:31 AM, Christoph Hellwig wrote:
>> On Sun, Nov 22, 2015 at 05:26:28PM +0200, Sagi Grimberg wrote:
>>>> No. register_always=Y is already broken in 4.3, but
>>>> register_always=N is
>>>> now also broken in 4.4.
>>>
>>> OK, I'm confused so please let me understand slowly :)
>>>
>>> Your patch "ib_srp: initialize dma_length in srp_map_idb" solves
>>> the register_always=Y dma_length = 0 WARN_ON() on 4.4-rc, does it solve
>>> the data integrity errors too?
>>
>> No, it doesn't.
>>
>>> This code path is specific to srp because all other ULPs guarantee
>>> no-gaps...
>>
>> Yes.  Life would be simpler if we could just set the virt_boundary
>> on SRP, and Bart has indicated that he's willing to at least looks at
>> this for the next merge window.
>
> Hello Christoph,
>
> Tomorrow I will try to reproduce this behavior on my test setup. I
> prepared a setup with kernel v4.4-rc2 and on which the SRP initiator and
> target are running on the same server. Tomorrow I will install xfstests
> and see whether these tests pass fine against an XFS filesystem.

(replying to my own e-mail)

I can reproduce this behavior with both LIO and SCST. I have modified 
initiator and target code such that the target appends a data CRC at the 
end of the SRP_RSP IU and such that the initiator checks that CRC. A CRC 
mismatch was reported for the following SG-list by the initiator:

scsi host10: srp_check_crc: bufflen 1024; resid 0; sg-list len 2; dir 
DMA_TO_DEVICE; CRC mismatch (0x7916620b <> 0xde97b796); sg-list:
[0] ffff880407378348 len 512
[1] ffff880407378000 len 512

I will check the memory registration code next.

Bart.
