From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Tue, 19 Apr 2016 21:46:08 +0300
Message-ID: <57167CF0.5090405@grimberg.me>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
 <1461010463-6603-12-git-send-email-hch@lst.de> <57163E99.8090301@grimberg.me>
 <20160419172627.GC20844@obsidianresearch.com> <20160419182950.GC989@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160419182950.GC989-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>> In isert if the we have a single sg entry, we use the local_dma_lkey
>>> just so we can skip a registration (also for protection sg), perhaps
>>> rdma_rw_init_one_mr can do this optimization too?
>>
>> Can't more than a single SG can be packed into a WR? Ideally this
>> common code should try and max out the SG entries before falling back
>> to using a WR?
>
> Mellanox signature MRs don't support registering more than a single SGE.

It can theoretically, but large sg lists can potentially
clog up the send queue in this case, and it would not perform
as well as in the current scheme the driver has a smart
repetition format optimization...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
