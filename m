From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 10:11:29 +0300
Message-ID: <56273AA1.6060607@mellanox.com>
References: <561B7CAE.3040505@dev.mellanox.co.il>
 <20151012144212.GB24770@lst.de> <56262CF9.1040509@dev.mellanox.co.il>
 <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
 <56263CE6.5010005@dev.mellanox.co.il>
 <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
 <56265702.1030209@dev.mellanox.co.il>
 <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
 <20151021063830.GA19027@lst.de> <56273459.6050007@mellanox.com>
 <20151021065134.GA19210@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151021065134.GA19210-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/21/2015 9:51 AM, Christoph Hellwig wrote:
>> We have a UAPI that requires us to keep the device query verb for ever, and
>> hence the returned device attr struct, it would be a much smaller and noisy patch pointer
>> to cache an device attr  on the device structure.
> Take a look at the code.  The only time we ever call into ->query_device is
> for the userspace only timestamping extensions only implemented for mlx4.

We will have many more device query extensions, but the point I tried to 
make here is a bit different --
we do need to keep the user/kernel device attr struct as part of the 
UAPI, and don't see any reason to
avoid it in the kernel, just because some other subsystems do that, 
according to your view. As I said, you
would have to work real (real) hard to convince the networking ppl to 
add fields to struct net_device sk_buff
and friends... the nature of rdma/offloading is such that new attr come 
often and I don't think we need
to touch our device struct every release.


> With all the stuff we have on the plate the kernel API will look substatially
> different from the arkane 'Verbs' implementation in userspace, and they will
> use less and less common code.  Libuvers and the ABIs it uses are something
> we can't change unfortunately, but we can make the kernel API much much
> better by learining lessons from other kernel subsystems.  That's work
> that Jason Sagi and me have been doing for a while.
>
> I'd also suggest you update your Linux knowledge before trying to
> micromanage patch submissions.

not trying to micro-manage @ all, I went over the archives and haven't 
found any review or ack
to your giant patch that touches the whole subsystem (drivers, core and 
ULPs) expect from Sagi's
-- lets hear more opinions. Re my education -- can you make the argument 
more precise: what are we
making much much better in the kernel API by thins house moving exercise?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
