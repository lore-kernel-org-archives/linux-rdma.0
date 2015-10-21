From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 08:51:34 +0200
Message-ID: <20151021065134.GA19210@lst.de>
References: <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de> <56262CF9.1040509@dev.mellanox.co.il> <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com> <56263CE6.5010005@dev.mellanox.co.il> <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com> <56265702.1030209@dev.mellanox.co.il> <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com> <20151021063830.GA19027@lst.de> <56273459.6050007@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56273459.6050007-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 09:44:41AM +0300, Or Gerlitz wrote:
> Fact is that for struct net_device you will not add 333 new fields over 
> night in the coming 33 years, for sure.

That's because they never had this split and added fields to struct netdev
as required.  One interesting difference in netdev is that it move all
the function pointers out to a different structure so it could be kept
const.  This introduces one more level of pointer chasing but has other
advantages.

> This makes much sense to me, as a guideline. I don't think we should have a 
> device structure with the current
> 100 fields and another few hundreds without any notable benefit and against 
> the common practice in the networking
> subsystem.

Please understand the networking subsystem (or SCSI, or NVMe, or ...) before
making such incorrect comments.  We're moving towards how all other
subsystems work.

> We have a UAPI that requires us to keep the device query verb for ever, and 
> hence the returned device attr struct,
> it would be a much smaller and noisy patch to cache an device attr pointer 
> on the device structure.

Take a look at the code.  The only time we ever call into ->query_device is
for the userspace only timestamping extensions only implemented for mlx4.

With all the stuff we have on the plate the kernel API will look substatially
different from the arkane 'Verbs' implementation in userspace, and they will
use less and less common code.  Libuvers and the ABIs it uses are something
we can't change unfortunately, but we can make the kernel API much much
better by learining lessons from other kernel subsystems.  That's work
that Jason Sagi and me have been doing for a while.

I'd also suggest you update your Linux knowledge before trying to
micromanage patch submissions.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
