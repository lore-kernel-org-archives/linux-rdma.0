From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Thu, 5 May 2016 16:55:56 -0400 (EDT)
Message-ID: <804753248.34153510.1462481756460.JavaMail.zimbra@redhat.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com> <20160503093307.GL19931@lst.de> <572A8975.9060606@sandisk.com> <20160505140616.GA15000@lst.de> <2102017158.34060891.1462478304470.JavaMail.zimbra@redhat.com> <572BA98F.4090109@sandisk.com> <572BAA6F.1060607@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <572BAA6F.1060607-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, May 5, 2016 4:17:51 PM
> Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
> 
> On 05/05/2016 01:14 PM, Bart Van Assche wrote:
> > On 05/05/2016 12:58 PM, Laurence Oberman wrote:
> >> I added and tested this patch.
> >> I left the warn message in as I need it.
> >>
> >> [root@srptest ~]# dmesg | grep Reducing
> >> [  551.526015] scsi host4: ib_srp: Reducing max_sectors from 8192 to 4080
> >> [  559.367609] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
> >> [  570.449121] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
> >> [  577.831703] scsi host6: ib_srp: Reducing max_sectors from 8192 to 4080
> >>
> >> Its stable but only because we constrain the max_sectors.
> >> I am writing 4MB buffered to 10 file systems (ext3) however the
> >> max_sectors is constrained to 2040k and its stable.
> >>
> >> I have been told that RHEL6 and the Mofed stack happily does 4MB buffered
> >> I/O with mapping failures but I need to check that out.
> >> That would make no sense to me unless the Mofed stack has code that
> >> differs enough to what we have upstream to make a difference.
> >>
> >> I am about to install RHEL6 and Mofed to compare and see what happens with
> >> 4MB buffered.
> >>
> >> Tested-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > Thanks for the help with testing :-)
> >
> > Can you try to increase SRP_MAX_PAGES_PER_MR in ib_srp.h from 512 to
> > 1024 and see whether that allows 4MB I/O?
> 
> (replying to my own e-mail)
> 
> That was a typo - I meant 1025 instead of 1024.
> 
> Bart.
> 
> 
Set at 1025, rebuilt ib_srp module, rebooted client and:

Still get:

[root@srptest ~]# dmesg | grep Reducing
[  227.076550] scsi host4: ib_srp: Reducing max_sectors from 8192 to 4080
[  235.316995] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
[  245.726223] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
[  253.197573] scsi host6: ib_srp: Reducing max_sectors from 8192 to 4080

And then of course we are constrained

[root@srptest queue]# cat max_sectors_kb
2040
[root@srptest queue]# echo 4096 > max_sectors_kb
-bash: echo: write error: Invalid argument

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
