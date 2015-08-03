From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/iser: Support up to 8MB data transfer in a
 single command
Date: Mon, 3 Aug 2015 13:57:27 +0000
Message-ID: <25F51949-82B5-4BA8-8472-6056BC43C747@ornl.gov>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-21-git-send-email-sagig@mellanox.com>
 <55BA3EF6.6080800@opengridcomputing.com>
 <55BDCE4D.5080601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BDCE4D.5080601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Content-ID: <5F88362B095AF6488BC663FBCFA45BC1-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Aug 2, 2015, at 4:01 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

>>> +static void
>>> +iser_calc_scsi_params(struct iser_conn *iser_conn,
>>> +              unsigned int max_sectors)
>>> +{
>>> +    struct iser_device *device = iser_conn->ib_conn.device;
>>> +    unsigned short sg_tablesize, sup_sg_tablesize;
>>> +
>>> +    sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
>>> +    sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
>>> +                 device->dev_attr.max_fast_reg_page_list_len);
>>> +
>>> +    if (sg_tablesize > sup_sg_tablesize) {
>>> +        sg_tablesize = sup_sg_tablesize;
>>> +        iser_conn->scsi_max_sectors = sg_tablesize * SIZE_4K / 512;
>>> +    } else {
>>> +        iser_conn->scsi_max_sectors = max_sectors;
>>> +    }
>>> +
>> 
>> Why SIZE_4K and not PAGE_SIZE?
> 
> Yes, I'll change that to PAGE_SIZE.
> 
> Thanks.

Would non-4KB pages (e.g. PPC 64KB) be an issue? Would this work between hosts with different page sizes?

Scott

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
