From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: add change_queue_depth and change_queue_type
 support
Date: Tue, 27 Aug 2013 18:39:04 +0200
Message-ID: <521CD628.8090902@profitbricks.com>
References: <521B5DD5.3020804@profitbricks.com> <521C63FA.3070709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521C63FA.3070709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

snip
> This code seems incorrect to me for the SRP protocol. In the SRP
> protocol, although there is no TCQ support, queue depths above one are
> supported.
> 
> I also have a more general remark. There is no TCQ support in the SRP
> protocol, which means that sdev->tagged_supported is always 0 (false).
> So my recommendation is to leave out all code that depends on "if
> (sdev->tagged_supported)" and to remove the "if
> (!sdev->tagged_supported)" tests.
> 
> Bart.

Hello Bart,

I look into scsi core about above statement:
In drivers/scsi/scsi_scan.c:865:		

 if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
            !(*bflags & BLIST_NOTQ))
                sdev->tagged_supported = 1;
It check inquiry result byte 7 with cmdque bit.

inquiry result of a disk export through srp/srpt
sg_inq /dev/sdb
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=66 (0x42)   Peripheral device type: disk
 Vendor identification: SCST_FIO
 Product identification: vol0
 Product revision level:  300
 Unit serial number: 609bbc13

So the sdev_>tagged_supported will be set in this case

In srpr16 p38
The TASK ATTRIBUTE field is defined in table 21, it includes support for:

    head of queue
    ordered
    simple

Do I miss something?

Regards,
Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
