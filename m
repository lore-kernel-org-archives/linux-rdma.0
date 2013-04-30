From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: NFS over RDMA benchmark
Date: Tue, 30 Apr 2013 14:38:59 +0000
Message-ID: <0EE9A1CDC8D6434DB00095CD7DB873462CF9CBD0@MTLDAG01.mtl.com>
References: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65@MTLDAG01.mtl.com>
 <CABgxfbF7c9ktSoMSPV21JU76V5J4iwbJQ257S91Y3z36WJbJVA@mail.gmail.com>
 <62745258-4F3B-4C05-BFFD-03EA604576E4@ornl.gov>
 <CABgxfbGxhnKj2n0Z-w87rZ6fwCssO31G009gwej957gv1p8PQQ@mail.gmail.com>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF9715B@MTLDAG01.mtl.com>
 <20130423210607.GJ3676@fieldses.org>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF988C9@MTLDAG01.mtl.com>
 <20130424150540.GB20275@fieldses.org> <20130424152631.GC20275@fieldses.org>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF9A820@MTLDAG01.mtl.com>
 <20130428144248.GA2037@fieldses.org>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF9C90C@MTLDAG01.mtl.com>
 <517FD327.3060901@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517FD327.3060901-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Tom Talpey [mailto:tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, April 30, 2013 17:20
> To: Yan Burman
> Cc: J. Bruce Fields; Wendy Cheng; Atchley, Scott; Tom Tucker; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz
> Subject: Re: NFS over RDMA benchmark
> 
> On 4/30/2013 1:09 AM, Yan Burman wrote:
> > I now get up to ~95K IOPS and 4.1GB/sec bandwidth.
> >...
> >  ib_send_bw with intel iommu enabled did get up to 4.5GB/sec
> 
> BTW, you may want to verify that these are the same GB. Many benchmarks
> say KB/MB/GB when they really mean KiB/MiB/GiB.
> 
> At GB/GiB, the difference is about 7.5%, very close to the difference between
> 4.1 and 4.5.
> 
> Just a thought.

The question is not why there is 400MBps difference between ib_send_bw and NFSoRDMA.
The question is why with IOMMU ib_send_bw got to the same bandwidth as without it while NFSoRDMA got half.

>From some googling, it seems that when IOMMU is enabled, dma mapping functions get a lot more expensive.
Perhaps that is the reason for the performance drop.

Yan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
