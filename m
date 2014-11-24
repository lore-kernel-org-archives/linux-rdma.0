From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: NFSoRDMA developers bi-weekly meeting minutes (11/20)
Date: Mon, 24 Nov 2014 11:43:15 +0000
Message-ID: <fbe466929145478dade2c724f2134c40@DB4PR05MB461.eurprd05.prod.outlook.com>
References: <546E31C0.1070400@oracle.com>
 <1382BBBCFA085249836C0E3E91900D8999CA064C@ORSMSX115.amr.corp.intel.com>
 <546E645F.4090301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546E645F.4090301-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Cheng, Wendy" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Shirley Ma [mailto:shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Friday, November 21, 2014 00:00
> To: Cheng, Wendy; Charles EDWARD Lever; Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org;
> Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> dominique.martinet-KCE40YydGKI@public.gmane.org; jeffrey.c.becker-NSQ8wuThN14@public.gmane.org; rsdance@soft-
> forge.com; skc-YOWKrPYUwWM@public.gmane.org; sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; Yan Burman; linux-rdma; Linux NFS Mailing
> List
> Subject: Re: NFSoRDMA developers bi-weekly meeting minutes (11/20)
> 
> 
> On 11/20/2014 12:15 PM, Cheng, Wendy wrote:
> >> -----Original Message-----
> >> From: Shirley Ma [mailto:shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> >> Sent: Thursday, November 20, 2014 10:24 AM
> >>
> >> ....
> >> iser 8K could reach 4.5GB/s in 56Gb/s link speed, 1.5 million IOPS.
> >> 32K could reach 1.8 million IOPS
> >>
> >
> > How did the ISER data get measured ? Was the measure done on ISER layer,
> block layer, or filesystem layer ?
> 
> Here is the link on iser how to set up and measure performance:
> http://community.mellanox.com/docs/DOC-1483

Actual numbers are (there seems to be some misunderstanding in the meeting minutes):
For single LUN/session in iSER on ConnectX-3 FDR link with 8 core 2.6GHz Xeon are:
8K block size reaches 2.5GB/s
Somewhere between 16K and 32K block size iSER reaches 5.5GB/s which is almost line rate
256K block size gives 5.7GB/s

With 16 sessions, it is possible to reach 1.7M IOPS with 1K block size and about 600K IOPS with 8K block size.

Note these numbers are for SCST iSER implementation and there are some more tunings and enhancements
that can be applied to further improve performance.

Another issue that came up is the benefit of RDMA vs send.
In order to check that you can use ib_send_lat vs ib_write_lat and see the latencies of different block sizes.
>From past experience RDMA starts to get more efficient somewhere around 8K.

Yan

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
