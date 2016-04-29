From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 12/12] IB/isert: convert to the generic RDMA READ/WRITE
 API
Date: Fri, 29 Apr 2016 14:46:50 +0300
Message-ID: <572349AA.2070407@grimberg.me>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-13-git-send-email-hch@lst.de> <57227ADC.80000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57227ADC.80000@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>> Replace the homegrown RDMA READ/WRITE code in isert with the generic API,
>> which also adds iWarp support to the I/O path as a side effect.  Note
>> that full iWarp operation will need a few additional patches from Steve.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/infiniband/ulp/isert/ib_isert.c | 841 ++++----------------------------
>>   drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
>>   2 files changed, 85 insertions(+), 825 deletions(-)
>
> Hi Sagi,
>
> I've seen your reviews on the smaller patches in this series, but this
> one in particular has your name all over it.  If you could review it, I
> would appreciate it ;-)

~800 LOC deleted, what's not to love ? :)

The patch looks fine to me,
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

I did some light testing with rxe and it works fine (no signature stuff
though). I've asked Mellanox folks to get this set into their regression
systems and still hoping to get their tested-by tag, but if we don't
hear from them by the merge window I don't think we should block it.
