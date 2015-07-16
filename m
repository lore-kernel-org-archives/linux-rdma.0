From: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: [PULL REQUEST] Please pull rdma.git
Date: Thu, 16 Jul 2015 13:59:37 +0000
Message-ID: <CY1PR03MB14409F7C639ADF21A2AD782FDE990@CY1PR03MB1440.namprd03.prod.outlook.com>
References: <55A56640.2000206@redhat.com>
 <CA+55aFzdE94JcGT3aF0+rp-ym6UdMCAcQD2LSCBeedv9dLRfhQ@mail.gmail.com>
 <20150716075542.GA9093@infradead.org> <55A7A6CD.4080900@redhat.com>
 <20150716124507.GA5943@infradead.org> <55A7A878.1090704@redhat.com>
 <55A7B02C.6080009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A7B02C.6080009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Hal, we indeed do. And we would like to continue to do so, be it by setting a flag or otherwise. I hope removing that functionality from the kernel is not an option, as it would be a major inconvenience for us.
Thanks,
Suri

-----Original Message-----
From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
Sent: Thursday, July 16, 2015 9:23 AM
To: Doug Ledford
Cc: Christoph Hellwig; Linus Torvalds; linux-rdma; Suri Shelvapille
Subject: Re: [PULL REQUEST] Please pull rdma.git

On 7/16/2015 8:50 AM, Doug Ledford wrote:
> On 07/16/2015 08:45 AM, Christoph Hellwig wrote:
>> Hi Doug,
>>
>> the point is that there is no driver that even set the is_switch flag
>> in-tree and I can't find a publicly available one elsewhere either.
>
> Try looking on Mellanox.com for their source code.  I know they use
> upstream linux kernels as the base for their switch OS and in their
> switch-X driver it should set this flag.
>
> However, this is a point that I don't really care about, but I
> inherited (and I know other people care about).

There are 2 vendors that I'm aware of that use linux for their embedded IB switch platforms: Mellanox and Bay Microsystems and there may be others.

Mellanox has switch drivers for the various different switch ICs that have been used over time (InfiniScale IV, SwitchX/SwitchX-2, and most Switch-IB).

-- Hal

This correspondence, and any attachments or files transmitted with this correspondence, contains information which may be confidential and privileged and is intended solely for the use of the addressee. Unless you are the addressee or are authorized to receive messages for the addressee, you may not use, copy, disseminate, or disclose this correspondence or any information contained in this correspondence to any third party. If you have received this correspondence in error, please notify the sender immediately and delete this correspondence and any attachments or files transmitted with this correspondence from your system, and destroy any and all copies thereof, electronic or otherwise. Your cooperation and understanding are greatly appreciated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
