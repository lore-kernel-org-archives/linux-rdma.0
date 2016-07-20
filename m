From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
Date: Wed, 20 Jul 2016 11:56:33 -0400 (EDT)
Message-ID: <841632333.5871847.1469030193498.JavaMail.zimbra@redhat.com>
References: <8fb358c3-3504-02ca-fcb8-1624f28be1b0@sandisk.com> <1465736110.5730453.1468948485702.JavaMail.zimbra@redhat.com> <93123318.5861700.1469025833903.JavaMail.zimbra@redhat.com> <8b8d2e22-4fb9-466f-5321-0745748bd793@sandisk.com> <88756403.5866837.1469027976552.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88756403.5866837.1469027976552.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Parav Pandit" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger"
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Wednesday, July 20, 2016 11:19:36 AM
> Subject: Re: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>,
> > "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> > "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Parav Pandit"
> > <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger"
> > <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Wednesday, July 20, 2016 11:07:34 AM
> > Subject: Re: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
> > 
> > On 07/20/2016 07:43 AM, Laurence Oberman wrote:
> >  > [ ... ]
> > > I am not sure yet if something in the  4.7.0-rc7 base changed ALUA
> > > behavior, likely that is the case.
> > > I have to go back and check.
> > >
> > > On an older kernel with recent patches from you and Leon everything looks
> > > fine and is working fine.
> > >
> > > 4.7.0-rc1.bartleon+
> > >
> > > 360001ff0b035d000000000098d79000a dm-11 DDN     ,SFA14K
> > > size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
> > > |-+- policy='round-robin 0' prio=90 status=active
> > > | `- 1:0:0:9  sdt  65:48  active ready running
> > > `-+- policy='round-robin 0' prio=50 status=enabled
> > >   `- 2:0:0:9  sdv  65:80  active ready running
> > > 360001ff0b035d000000000078d770008 dm-9 DDN     ,SFA14K
> > > size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
> > > |-+- policy='round-robin 0' prio=90 status=active
> > > | `- 2:0:0:7  sds  65:32  active ready running
> > > `-+- policy='round-robin 0' prio=50 status=enabled
> > >   `- 1:0:0:7  sdp  8:240  active ready running
> > 
> > Hello Laurence,
> > 
> > Can you check your /etc/multipath.conf? In the multipath -ll output
> > "hwhandler" should be something like hwhandler='1 alua' instead of '0'
> > when communicating with an array that supports ALUA.
> > 
> > Thanks,
> > 
> > Bart.
> > 
> 
> Hi Bart
> 
> I have not changed my multipath.conf and the older kernel works fine.
> Its been the same configuration all along.
> 
> I have had this all along (came from the vendor) and its also on the other
> server booting the older kernel.
> 
>        device {
>         vendor                  "DDN"
>         product                 "SFA14K"
>         path_grouping_policy    group_by_prio
>         prio                    alua
>         path_selector           "round-robin 0"
>         path_checker            tur
>         failback                2
>         rr_weight               uniform
>         no_path_retry           12
>         dev_loss_tmo            10
>         fast_io_fail_tmo        5
>     }
> 
> Older kernel is coming up ALUA
> 
> 360001ff0b035d000000000078d770008 dm-9 DDN     ,SFA14K
> size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=90 status=active            Active/optimized
> | `- 2:0:0:7  sds  65:32  active ready running
> `-+- policy='round-robin 0' prio=50 status=enabled
> Active/non-optimized
>   `- 1:0:0:7  sdp  8:240  active ready running
> 
> New kernel with latest patches
> 
> 360001ff0b035d000000000078d770008 dm-12 DDN     ,SFA14K
> size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=10 status=active
>   |- 1:0:0:7  sdj  8:144  active ready running
>   `- 2:0:0:7  sday 67:32  active ready running
> 
> I dont think its your recent 5 patches, but I will test the latest kernel
> without them to validate that its not your changes.
> Let me go ahead and test the generic 4.7.0-rc7 and confirm.
> 
> Thanks!!
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Replying to my own email.

Hi Bart

OK, seems something on the connectivity to this other server has changed without my knowledge.
Booting the older kernel on this node showing the issue also sees this same behavior so something has changed on the back-end here for this server.
Its not the kernel or your patches.
I need to go into the lab and check what has has changed but that's for another day.

So I installed the new kernel with latest 5 patches on the other server and its passed all my tests.
Comes up as normal and passes all SRP tests I know need to be performed.

Looks better :)

360001ff0b035d000000000078d770008 dm-9 DDN     ,SFA14K          
size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=90 status=active
| `- 2:0:0:7  sdq  65:0   active ready running
`-+- policy='round-robin 0' prio=50 status=enabled
  `- 1:0:0:7  sdr  65:16  active ready running


XFS tests are fast

# time mkfs -t xfs -f  /dev/mapper/360001ff0b035d000000000078d770008
meta-data=/dev/mapper/360001ff0b035d000000000078d770008 isize=256    agcount=33, agsize=243265536 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=7784628224, imaxpct=5
         =                       sunit=4096   swidth=4096 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

real	0m1.799s
user	0m0.009s
sys	0m0.179s


For the series:
Tested-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
