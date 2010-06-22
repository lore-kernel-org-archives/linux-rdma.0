From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How do I get scst_vdisk/IB_SRP(T) to properly handle drives w/ 4KB
	sectors?
Date: Tue, 22 Jun 2010 10:06:45 -0600
Message-ID: <AANLkTin2bONNlTF8mseOt3-pPcFF523-6EWHFD2XBOPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When given an LBA w/ a bad boundary, the drive returns an error and
the target side says:

dev_vdisk: ***ERROR***: cmd ffff810196f58b70 returned error -22

... and the initiator:

sd 8:0:0:0: SCSI error: return code = 0x08000002
sdc: Current: sense key: Medium Error
    Add. Sense: Unrecovered read error

Is there a way to tell scst that this drive requires 4KB block sizes,
and pass that upstream?

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
