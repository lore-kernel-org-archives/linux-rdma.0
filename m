From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting announcement (4/30)
Date: Thu, 1 May 2014 12:03:41 -0400 (EDT)
Message-ID: <26724.841053556$1398960268@news.gmane.org>
References: <53614C03.80606@oracle.com> <CAJZOPZJioYdcbDGsk7278sZS7kD9W1dcGEGtYfsFk=Mm7DW3fQ@mail.gmail.com> <BBF761A6-2407-4457-92D5-8C2EC736BC9D@oracle.com> <CAJZOPZJgp-QdxR+PmwACWOSc4h_167J0iBjfmMrPX8sek600WA@mail.gmail.com> <536161D0.3000600@oracle.com> <"30686627.1636.1398902288314.JavaMail.Doug Ledford"@Phenom> <5361D89F.4070503@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5361D89F.4070503-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yanb <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Phil Cayton <phil.cayton-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Susan K Coulter <skc-YOWKrPYUwWM@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Devesh.Sharma" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Allen Andrews <Allen.Andrews-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/01/2014, Shirley Ma wrote: 
> On 04/30/2014 04:58 PM, Doug Ledford wrote:
> > On 04/302014 Shirley Ma wrote:
> >> I've created Xen guest on DomU. Dom0 PF works which has no mtts
> >> been
> >> enabled, however DomU I hit this problem by just mounting the file
> >> system:
> >> mlx4_core 0000:00:04.0: Failed to allocate mtts for 66 pages(order
> >> 7)
> >> mlx4_core 0000:00:04.0: Failed to allocate mtts for 4096
> >> pages(order
> >> 12)
> >> mlx4_core 0000:00:04.0: Failed to allocate mtts for 4096
> >> pages(order
> >> 12)
> >>
> >> RDMA microbenchmark perftest works ok. I enabled mtts scripts when
> >> booting the Xen guest. cat /proc/mtrr:
> > What OS/RDMA stack are you using?  I'm not familiar with any mtts
> > scripts, however I know there is an mtrr fixup script I wrote for
> > the RDMA stack in Fedora/RHEL (and so I assume it's in Oracle Linux
> > too, but I haven't checked).  In fact, I assume that's the script
> > you are referring to based on the fact that your next bit of your
> > email cats the /proc/mtrr file.  But I don't believe whether there
> > is an mtrr setting mixup or not that is should have any impact on
> > the mtts allocations in the driver.  Even if your mtrr registers
> > were set incorrectly, the problem then becomes either A) a serious
> > performance bottleneck (in the case of Intel hardware that needs
> > write combining in order to get more than about 50MByte/s of
> > throughput on their cards) or B) failed operation because MMIO
> > writes to the card are being cached/write combined when they should
> > not be.
> >
> > I suspect this is more likely Xen related than mtts/mtrr related.
> Yes. That's the script I used. I wonder whether it's possible to
> disable
> mtrr on DomU guest to debug this. I am new to Xen.

No, it's not possible to disable mtrr and expect any pass through
PCI devices to work.  The mtrr registers merely indicate what
portion of the memory map should be treated as normal memory (meaning
cacheable) and what should be treated as MMIO memory (meaning generally
non-cacheable).  That's all they do.  The mtts table allocation
failures are actually totally different.  In the VF on DomU they
are passed to the PF on Dom0 and the command is done there.  However,
the number of mtts available for the slave are limited (check the
code in resource_tracker.c).  In addition, the number of mtts
allocated is proportionally related to memory size in the guest
and inversely related to the log2_mtts_per_seg (probably both on
Dom0 and DomU, which I suspect need to agree on the log2_mtts_per_seg
module parameter).  I would try a combination of reducing the memory
in the quest, or increasing the log2_mtts_per_seg, or both, and
see if you can get it to work.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
