From: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Tue, 5 Apr 2016 11:55:42 +0300
Message-ID: <57037D8E.4030506@grimberg.me>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me> <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404225831.GA6725-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Odd, I see that Ming's patches made it to 4.5...
>>
>> Can you verify that this patches exist in your tree:
>> e827091cb1bc block: merge: get the 1st and last bvec via helpers
>> 25e71a99f10e block: get the 1st and last bvec via helpers
>> e0af29171aa8 block: check virt boundary in bio_will_gap()
>> 7bcd79ac50d9 block: bio: introduce helpers to get the 1st and last bvec
>
> I've done a clean rebuild because I didn't trust the previous one
> lingering around, and the syptoms are slightly different now, in that I
> still get the same spew of messages, but it seems like xfstests is
> very slowly progressing regardless.
>
> Also when testing srp I see similar messages with the same setup:
>
> [  130.896116] scsi host7: ib_srp: Failed to map data (-12)
> [  130.896225] scsi host7: ib_srp: Failed to map data (-12)
> [  130.896232] scsi host7: ib_srp: Failed to map data (-12)
> [  130.896235] scsi host7: ib_srp: Failed to map data (-12)
> [  130.896835] scsi host7: ib_srp: Failed to map data (-12)
> [  130.993339] scsi host7: ib_srp: Failed to map data (-12)
> [  130.993345] scsi host7: ib_srp: Failed to map data (-12)
> [  130.993349] scsi host7: ib_srp: Failed to map data (-12)
> [  130.993841] scsi host7: ib_srp: Failed to map data (-12)
> [  130.993844] scsi host7: ib_srp: Failed to map data (-12)
> [  131.035723] scsi host7: ib_srp: Failed to map data (-12)
> [  131.058006] scsi host7: ib_srp: Failed to map data (-12)
> [  131.058059] scsi host7: ib_srp: Failed to map data (-12)
>

This implies that maybe something broke in ib_sg_to_pages:

Can you run iser with this patch applied (FR or FMR):
--
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c 
b/drivers/infiniband/ulp/iser/iser_memory.c
index 44cc85f206f3..67499d8f6a3a 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -143,7 +143,7 @@ static void iser_data_buf_dump(struct iser_data_buf 
*data,
         int i;

         for_each_sg(data->sg, sg, data->dma_nents, i)
-               iser_dbg("sg[%d] dma_addr:0x%lX page:0x%p "
+               iser_err("sg[%d] dma_addr:0x%lX page:0x%p "
                          "off:0x%x sz:0x%x dma_len:0x%x\n",
                          i, (unsigned long)ib_sg_dma_address(ibdev, sg),
                          sg_page(sg), sg->offset,
@@ -450,6 +450,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task 
*iser_task,
         if (unlikely(n != mem->size)) {
                 iser_err("failed to map sg (%d/%d)\n",
                          n, mem->size);
+               iser_data_buf_dump(mem, 
iser_task->iser_conn->ib_conn.device->ib_device);
                 return n < 0 ? n : -EINVAL;
         }
--

This sg dump will tell us what sort of scatterlist we can't
handle.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
