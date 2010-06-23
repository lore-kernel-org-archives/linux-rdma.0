From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: How do I get scst_vdisk/IB_SRP(T) to properly handle drives w/
 4KB sectors?
Date: Wed, 23 Jun 2010 21:08:51 +0400
Message-ID: <4C223FA3.3090300@vlnb.net>
References: <AANLkTin2bONNlTF8mseOt3-pPcFF523-6EWHFD2XBOPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin2bONNlTF8mseOt3-pPcFF523-6EWHFD2XBOPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 06/22/2010 08:06 PM wrote:
> When given an LBA w/ a bad boundary, the drive returns an error and
> the target side says:
> 
> dev_vdisk: ***ERROR***: cmd ffff810196f58b70 returned error -22
> 
> ... and the initiator:
> 
> sd 8:0:0:0: SCSI error: return code = 0x08000002
> sdc: Current: sense key: Medium Error
>     Add. Sense: Unrecovered read error
> 
> Is there a way to tell scst that this drive requires 4KB block sizes,
> and pass that upstream?

I'm not sure what you mean here under "tell" and "pass upstream". 
Generally, such problems are outside of SCST scope and responsibilities. 
With vdisk kernel I/O stack should make sure you use correct alignment 
accessing your backend drive and you can always choose your own >512b 
block size for all vdisk devices.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
