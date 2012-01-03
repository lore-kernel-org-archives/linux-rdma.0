From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Send with immediate data completion
Date: Tue, 3 Jan 2012 12:38:17 -0500
Message-ID: <1DB8F21E-E3C4-4B0C-A8A6-5A9E4A221692@ornl.gov>
References: <11EC89F0-2BFD-4727-BC45-AD30E0F10348@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A823732566A099@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732566A099-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jan 3, 2012, at 11:55 AM, Hefty, Sean wrote:

>> I have a question about a completion for a send with immediate data. The IB
>> spec (1.2.1) only mentions that the WC's immediate data be present at the
>> receiver. It is silent on the value on the sender at completion. It does say
>> that it is only valid if the WC's immediate data indicator is set.
> 
> Can you provide a section reference to the spec on the areas that you're looking at?  Looking quickly, section 11.4.2.1 reads like immediate data should be available in either case.
> 
> I've never checked imm data on the send wc.  I'm just trying to determine if there's an issue in the spec that should be addressed, or if this is simply a bug in the hca/driver.

For the record, I am using:

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.7.626
        node_guid:                      0002:c903:000b:64e8
        sys_image_guid:                 0002:c903:000b:64eb
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xB0
        board_id:                       MT_0D90110009

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
