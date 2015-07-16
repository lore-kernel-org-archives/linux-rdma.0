From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 17:40:49 +0300
Message-ID: <55A7C271.6010806@dev.mellanox.co.il>
References: <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
 <55A754BC.6010706@dev.mellanox.co.il> <20150716080702.GD9093@infradead.org>
 <55A76B84.30504@dev.mellanox.co.il>
 <000b01d0bfd3$3b7e1df0$b27a59d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000b01d0bfd3$3b7e1df0$b27a59d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I can drop it, unless anyone can think of a use-case where a ULP would
>> want to register a region with a different offset from sg[0]->offset
>> and/or ends before the sum(sg->length).
>
> What if the sg list has to be chunked up due to the device's FRWR pbl depth limits?  Or is that handled underneath rdma_reg_sg()?
>

Should be handled underneath...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
