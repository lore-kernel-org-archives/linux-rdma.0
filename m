From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Thu, 5 May 2016 15:58:24 -0400 (EDT)
Message-ID: <2102017158.34060891.1462478304470.JavaMail.zimbra@redhat.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com> <20160503093307.GL19931@lst.de> <572A8975.9060606@sandisk.com> <20160505140616.GA15000@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160505140616.GA15000-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, May 5, 2016 10:06:16 AM
> Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
> 
> On Wed, May 04, 2016 at 04:44:53PM -0700, Bart Van Assche wrote:
> > > FYI, even with this patch I see tons of errors like:
> > > 
> > > [ 2237.161106] scsi host7: ib_srp: Failed to map data (-12)
> > 
> > Hello Christoph,
> > 
> > The patch below makes these messages disappear on my setup. Are
> > you OK with including this change in patch 11/11?
> 
> Looks fine to me.
> 
> Btw, while we're at it - any chance you could move the fixes before
> the cleanups in the series so that they are more easily backportabke to
> -stable?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I added and tested this patch.
I left the warn message in as I need it.

[root@srptest ~]# dmesg | grep Reducing
[  551.526015] scsi host4: ib_srp: Reducing max_sectors from 8192 to 4080
[  559.367609] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
[  570.449121] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
[  577.831703] scsi host6: ib_srp: Reducing max_sectors from 8192 to 4080

Its stable but only because we constrain the max_sectors.
I am writing 4MB buffered to 10 file systems (ext3) however the max_sectors is constrained to 2040k and its stable.

I have been told that RHEL6 and the Mofed stack happily does 4MB buffered I/O with mapping failures but I need to check that out.
That would make no sense to me unless the Mofed stack has code that differs enough to what we have upstream to make a difference.

I am about to install RHEL6 and Mofed to compare and see what happens with 4MB buffered.

Tested-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
