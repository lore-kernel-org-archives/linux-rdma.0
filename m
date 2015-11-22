From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: srp state in current mainline
Date: Sun, 22 Nov 2015 16:55:49 +0200
Message-ID: <5651D775.9090500@dev.mellanox.co.il>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org> <20151122143215.GA14667@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151122143215.GA14667@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 22/11/2015 16:32, Christoph Hellwig wrote:
> On Sun, Nov 22, 2015 at 05:53:43AM -0800, Christoph Hellwig wrote:
>> To me this sounds like another argument to just allocate one FR
>> per request and don't allow non-contiguous SGLs.
>>
>> Also note that 4.4-rc  prefer_fr=y register_always=n
>> !register_always still blows up badly with XFS and ext4 due to
>> data integrity errors.

So the register_always=N makes bad things happen? if we register
all the frags we're OK (i.e. register_always=Y)?
