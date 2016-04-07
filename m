From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Thu, 7 Apr 2016 10:14:17 +0300
Message-ID: <570608C9.1070805@grimberg.me>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me> <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org> <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org> <570548AB.4090802@grimberg.me>
 <20160406231658.GB11588@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160406231658.GB11588-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> So this scatterlist seems perfectly fine (no gaps). The only thing I
>> can think of is that we don't have enough space reserved, but I counted
>> 127 pages in the scatterlist when iser reserves 128 (by default).
>>
>> Just in case I mis-counted, can you (or Max) try with the below
>> patch:
>
> This works fine for me, but I wonder if the miscounting is in the
> block layer?

We communicate the "max_pages" via sg_tablesize and max_hw_sectors.

iSER communicates (or at least supposed to) sg_tablesize=128 and
max_sectors=1024 to scsi (which sets the block queues attributes), that
should be sufficient for handling all the incoming IO. Unless we didn't
account for the first-page offset and the reminder coming at the last
segment (which results in an extra page). The patch should fix the
problem, however in this particular sg list I don't see the violation
(counted 127 pages)...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
