From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Mon, 08 Jun 2015 17:42:15 +0300
Message-ID: <5575A9C7.7000409@dev.mellanox.co.il>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com> <20150608132254.GA14773@infradead.org> <55759B0B.8050805@mellanox.com> <20150608135151.GA14021@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150608135151.GA14021-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/8/2015 4:51 PM, Christoph Hellwig wrote:
> On Mon, Jun 08, 2015 at 04:39:23PM +0300, Sagi Grimberg wrote:
>> I have learned about QUEUE_FLAG_SG_GAPS from your recent comments on
>> the list. Won't setting this flag interfere with bio merges?
>
> It would if any in-kernel consumer would actually generate such SG
> lists.  But none does - the only source is vectored SG_IO support.

I think O_DIRECT allows user-space to generate vectored SG lists that
are not aligned as well.

>>
>> I must say that I've always considered SW bounce buffering as a
>> work-around for an RDMA driver.
>
> bounce buffering is always a workaround, and offloading it to silicone
> just makes it a worse hack.

I wouldn't say this is about offloading bounce buffering to silicon.
The RDMA stack always imposed the alignment limitation as we can only
give a page lists to the devices. Other drivers (qlogic/emulex FC
drivers for example), use an _arbitrary_ SG lists where each element can
point to any {addr, len}.

This puts the RDMA stack in line with other devices effectively
allowing to register arbitrary SG lists.

> So please fix it in the proper layers
> first,

I agree that we can take care of bounce buffering in the block layer
(or scsi for SG_IO) if the driver doesn't want to see any type of
unaligned SG lists.

But do you think that it should come before the stack can support this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
