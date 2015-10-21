From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 21:08:31 +0300
Message-ID: <CAJ3xEMh3pE61sNaZKBr8k47Lb52cUc=n4JToXvvKyrTTu3WW2Q@mail.gmail.com>
References: <561B7CAE.3040505@dev.mellanox.co.il>
	<20151012144212.GB24770@lst.de>
	<56262CF9.1040509@dev.mellanox.co.il>
	<CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
	<56263CE6.5010005@dev.mellanox.co.il>
	<CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
	<56265702.1030209@dev.mellanox.co.il>
	<CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
	<20151021063830.GA19027@lst.de>
	<56273459.6050007@mellanox.com>
	<20151021065134.GA19210@lst.de>
	<56273AA1.6060607@mellanox.com>
	<5627B3BA.7060700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5627B3BA.7060700-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 6:48 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 10/21/2015 12:11 AM, Or Gerlitz wrote:
>>
>> haven't found any review or ack to your giant patch that touches the
>
>> whole subsystem (drivers, core and ULPs) expect from Sagi's -- lets
>> hear more opinions.
>
> Although I have not yet had the time to review the entire patch, removing
> ib_query_device() seems a great idea to me and an idea that I welcome very
> much. The ib_device_attr structure is too large to be allocated on the
> stack. This means that with Christoph's patch it is no longer needed to call
> kmalloc() + ib_query_device() + kfree() when a device attribute is needed
> from kernel code.


Bart, Jason, Steve,

The alternative approach to address this which was also running here
in the form of a patch from Ira following a reviewer comment from me,
is the have struct ib_device to contain a struct ib_device_attr member
(potentially a pointer) which is filled by the device driver before
they register themselves with the IB core.

This way there's no need for kmalloc() + ib_query_device() + kfree()
when a device attribute is needed and we don't introduce tens/hundreds
new fields for struct ib_device.

Thoughts?


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
