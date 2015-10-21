From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 08:40:30 +0200
Message-ID: <20151021064030.GB19027@lst.de>
References: <1444633078-27166-1-git-send-email-hch@lst.de> <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de> <56262CF9.1040509@dev.mellanox.co.il> <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com> <56263CE6.5010005@dev.mellanox.co.il> <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com> <56265702.1030209@dev.mellanox.co.il> <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com> <56265A1F.6090204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56265A1F.6090204-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2015 at 06:13:35PM +0300, Sagi Grimberg wrote:
>> The networking community will let you work for 10y before they add a
>> field to struct net_device exactly b/c
>> of the reason I brought. Why here we can come out of the blue and add
>> tens if not hundreds of fields to our device structure?
>
> Keeping struct ib_device_attr embedded at the end of struct ib_device is
> exactly the same isn't it?

In terms of layout it is, in terms of usability it's worse.  Just to take
the networking example Or seems to like so much there is no struct netdev_attr
to which fields of struct netdev are moved out to, which you then need to
query and cache anyway in your private device structure.   This design simply
was a idiotic idea to start with and I don't understand why anyone would
han onto it.  I do understand Chuck's concern about churn, but I'd rather
fix the infiniband subsystem up before we're growing even more users.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
