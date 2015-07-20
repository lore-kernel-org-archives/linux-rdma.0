From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Mon, 20 Jul 2015 19:29:33 +0300
Message-ID: <55AD21ED.5080203@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150715073233.GA11535@infradead.org>
 <20150715170750.GA23588@obsidianresearch.com>
 <55A7A1B0.5000808@dev.mellanox.co.il>
 <20150716180806.GC3680@obsidianresearch.com>
 <55AB36A4.1070102@dev.mellanox.co.il>
 <20150720162340.GB18336@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720162340.GB18336-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/20/2015 7:23 PM, Jason Gunthorpe wrote:
> On Sun, Jul 19, 2015 at 08:33:24AM +0300, Sagi Grimberg wrote:
>> I was thinking that the user won't explicitly say which key it registers
>> and it will be decided from the registration itself.
>> Meaning, the registration code will do:
>
> Please don't..
>
>> if (access | (IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE)
>>          register rkey...
>> else
>>          register lkey...
>>
>> Will that work with iWARP? or will this break because
>> iWARP needs REMOTE_WRITE for lkeys?
>
> Right, it will break.
>
> Access flags are only weakly related to lkey/rkey.
>
> It needs to be explicit. We have spots in the API that take lkeys and
> other spots the take rkeys - the caller must always know the intended
> use of the key it is requesting, there is no reason not to describe
> that explicitly.

OK, keep it explicit. got it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
