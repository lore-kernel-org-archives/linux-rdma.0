From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Sun, 1 Nov 2015 14:10:48 +0200
Message-ID: <56360148.8060608@mellanox.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com> <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151029115114.GA18466-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/29/2015 1:51 PM, Christoph Hellwig wrote:
> On Wed, Oct 28, 2015 at 10:57:59PM -0400, Doug Ledford wrote:
>>> > >I had to do a minor hand merge to get this to apply, but it has been
>>> > >pulled in for 4.4.
>> >
>> >This breaks all of the drivers in staging BTW.  That will need fixed up
>> >before the pull request goes in during the merge window.
> That latest branch on infradead.org should have fixed all the staging
> drivers.  But Linus just clarified that we indeed do not have to care for
> staging drivers, I asked him at kernel summit in front of the whole audience.

Can you and/or Greg clarify this a little further... when someone 
modified an API called by others
drivers,  they don't have to deal with staging drivers? that is, the 
folks that care for this staging code
need to handle that?


Or.

> If you were not merging the latest branch you might also have to pick up
> the mlx5 fix separately, Eli or Sagi might be able to help with that as
> I'll be offline for a few days.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
