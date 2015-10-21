From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 09:44:41 +0300
Message-ID: <56273459.6050007@mellanox.com>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
 <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de>
 <56262CF9.1040509@dev.mellanox.co.il>
 <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
 <56263CE6.5010005@dev.mellanox.co.il>
 <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
 <56265702.1030209@dev.mellanox.co.il>
 <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
 <20151021063830.GA19027@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151021063830.GA19027-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/21/2015 9:38 AM, Christoph Hellwig wrote:
> On Tue, Oct 20, 2015 at 06:07:31PM +0300, Or Gerlitz wrote:
>> >But this makes struct ib_device much much bigger, and this structure
>> >is used in **fast** path,
>> >e.g the ULP traverses through a pointer from struct ib_device to
>> >post_send/recv, poll_cq and friends.
> But it doesn't get near the end of the structure.  Maybe it's time for a
> little cache line 101 primer?

Oh, not that I am fully qualified on that front, but I understand  the 
end-of-structure argument.

Fact is that for struct net_device you will not add 333 new fields over 
night in the coming 33 years, for sure.

This makes much sense to me, as a guideline. I don't think we should 
have a device structure with the current
100 fields and another few hundreds without any notable benefit and 
against the common practice in the networking
subsystem.

We have a UAPI that requires us to keep the device query verb for ever, 
and hence the returned device attr struct,
it would be a much smaller and noisy patch to cache an device attr 
pointer on the device structure.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
