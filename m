From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 21:50:40 +0300
Message-ID: <CAJ3xEMg7vZnC6PUkQCy8xgrRGt4oU84UD4ZrZLzBxcBaDzQ8DQ@mail.gmail.com>
References: <56263CE6.5010005@dev.mellanox.co.il>
	<CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
	<56265702.1030209@dev.mellanox.co.il>
	<CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
	<20151021063830.GA19027@lst.de>
	<56273459.6050007@mellanox.com>
	<20151021065134.GA19210@lst.de>
	<56273AA1.6060607@mellanox.com>
	<5627B3BA.7060700@sandisk.com>
	<CAJ3xEMh3pE61sNaZKBr8k47Lb52cUc=n4JToXvvKyrTTu3WW2Q@mail.gmail.com>
	<20151021182019.GB15771@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151021182019.GB15771-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 9:20 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> No to the pointer idea.

can you spare few words why?

And if you have a valid argument, as Christoph said they teach in
cache 101 course which he's pretty sure I skipped as twenty other
courses taken by kernel developers, put the no pointer member @ the
end

> I have a slight preference toward ibdev->foo to match other subsystems.

I have a slight preference to keep the struct ib_device_attr notion to
match other portions of the RDMA stack such as the UAPI and the user
space API to applications.

> I have no idea why you care so much about something so trivial.

I don't care so much, I have the small right to speak without getting
so much mud on my head.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
