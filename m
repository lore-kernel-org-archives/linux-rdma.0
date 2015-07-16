From: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: [PULL REQUEST] Please pull rdma.git
Date: Thu, 16 Jul 2015 14:47:30 +0000
Message-ID: <CY1PR03MB1440338FDE2187E3C85B5EFCDE990@CY1PR03MB1440.namprd03.prod.outlook.com>
References: <55A56640.2000206@redhat.com>
 <CA+55aFzdE94JcGT3aF0+rp-ym6UdMCAcQD2LSCBeedv9dLRfhQ@mail.gmail.com>
 <20150716075542.GA9093@infradead.org> <55A7A6CD.4080900@redhat.com>
 <20150716124507.GA5943@infradead.org> <55A7A878.1090704@redhat.com>
 <55A7B02C.6080009@dev.mellanox.co.il>
 <CY1PR03MB14409F7C639ADF21A2AD782FDE990@CY1PR03MB1440.namprd03.prod.outlook.com>
 <20150716140157.GA27586@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716140157.GA27586-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Christoph:

Is that a requirement? Because, we have a lot of proprietary things that is tied to our FPGA that is in the driver and to rip all of that to make it more consumable to the community would be another effort that we don't have resources for.
Please let me know.
Thanks,
Suri

-----Original Message-----
From: Christoph Hellwig [mailto:hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
Sent: Thursday, July 16, 2015 10:02 AM
To: Suri Shelvapille
Cc: Hal Rosenstock; Doug Ledford; Christoph Hellwig; Linus Torvalds; linux-rdma
Subject: Re: [PULL REQUEST] Please pull rdma.git

On Thu, Jul 16, 2015 at 01:59:37PM +0000, Suri Shelvapille wrote:
> Thanks Hal, we indeed do. And we would like to continue to do so, be it by setting a flag or otherwise. I hope removing that functionality from the kernel is not an option, as it would be a major inconvenience for us.

Hi Suri,

how about you submit the driver to the kernel tree?

This correspondence, and any attachments or files transmitted with this correspondence, contains information which may be confidential and privileged and is intended solely for the use of the addressee. Unless you are the addressee or are authorized to receive messages for the addressee, you may not use, copy, disseminate, or disclose this correspondence or any information contained in this correspondence to any third party. If you have received this correspondence in error, please notify the sender immediately and delete this correspondence and any attachments or files transmitted with this correspondence from your system, and destroy any and all copies thereof, electronic or otherwise. Your cooperation and understanding are greatly appreciated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
