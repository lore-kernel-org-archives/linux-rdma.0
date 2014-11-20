From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting minutes (11/20)
Date: Thu, 20 Nov 2014 13:59:59 -0800
Message-ID: <546E645F.4090301@oracle.com>
References: <546E31C0.1070400@oracle.com> <1382BBBCFA085249836C0E3E91900D8999CA064C@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382BBBCFA085249836C0E3E91900D8999CA064C-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Cheng, Wendy" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 11/20/2014 12:15 PM, Cheng, Wendy wrote:
>> -----Original Message-----
>> From: Shirley Ma [mailto:shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>> Sent: Thursday, November 20, 2014 10:24 AM
>>
>> ....
>> iser 8K could reach 4.5GB/s in 56Gb/s link speed, 1.5 million IOPS. 32K could
>> reach 1.8 million IOPS
>>
> 
> How did the ISER data get measured ? Was the measure done on ISER layer, block layer, or filesystem layer ?

Here is the link on iser how to set up and measure performance:
http://community.mellanox.com/docs/DOC-1483
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
