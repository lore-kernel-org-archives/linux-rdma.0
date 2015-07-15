From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 11:52:54 +0300
Message-ID: <55A61F66.5090008@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org>
 <20150714155340.GA7399@obsidianresearch.com>
 <55A53CFA.7070509@dev.mellanox.co.il>
 <20150714170808.GA19814@obsidianresearch.com> <55A5CDE2.4060904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A5CDE2.4060904-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/15/2015 6:05 AM, Doug Ledford wrote:
> On 07/14/2015 01:08 PM, Jason Gunthorpe wrote:
>> On Tue, Jul 14, 2015 at 07:46:50PM +0300, Sagi Grimberg wrote:
>>> Which drivers doesn't support FRWR that we need to do other things?
>>> ipath - depracated
>>
>> We have permission to move this to staging and then RM it, so yay!
>
> Correct.
>
>>> mthca - soon to be deprecated
>>
>> This one I have a problem with. There is alot of mthca hardware out
>> there, it feels wrong to nuke it.. If we can continue to support the
>> FMR scheme it uses transparently, that would be excellent.
>>
>> I'm not hearing a strong reason why that shouldn't be the case...
>
> I'm not so sure about deprecating mthca either.  There are still a
> number of people I know that like to buy cheap SDR/DDR switches on EBay
> and pair them with cheap mthca cards and have cheap 10/20GBit/s home
> networks.  We have a couple people inside Red Hat that occasionally tell
> people what to look for on EBay to do just this.

I didn't mean deprecate it altogether, I meant that I don't think we
should do backflips for a single (old) driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
