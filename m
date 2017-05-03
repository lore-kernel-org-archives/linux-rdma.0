From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows
 the klms[] array
Date: Wed, 3 May 2017 11:18:38 +0300
Message-ID: <bcd56de8-0f17-f2bb-b079-bf22c1b92ca2@grimberg.me>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
 <20170425175849.GS14088@mtr-leonro.local>
 <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com>
 <20170426061640.GV14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170426061640.GV14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Hello Bart, Leon, Max and Israel.
>>
>> I cloned off Barts tree.
>>
>> git clone https://github.com/bvanassche/linux
>> cd linux
>> git checkout block-scsi-for-next
>>
>> I checked all patches were in for this test.
>>
>> a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
>> dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
>> f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
>>
>> Built and tested the kernel.
>>
>> However this issue is not resolved :(
>>
>> [ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817edca86b0
>> [ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
>> [ 2708.121342] 00000000 00000000 00000000 00000000
>> [ 2708.147104] 00000000 00000000 00000000 00000000
>> [ 2708.172633] 00000000 00000000 00000000 00000000
>> [ 2708.198702] 00000000 0f007806 2500002a 14a527d0
>
> Parsed version:
> 	hw_error_syndrome                : 0xf
> 	hw_syndrome_type                 : 0x0
> 	vendor_error_syndrome            : 0x78
> 	syndrome                         : MEMORY_WINDOW_BIND_ERROR (0x6)
> 	s_wqe_opcode                     : UMR (0x25)
> 	opcode                           : REQUESTOR_ERROR (0xd)
> 	cqe_format                       : NO_INLINE_DATA (0x0)
> 	owner                            : 0x0
>
> Description:
> 	umr.klm_octoword_count > mkey.mtt_octoword_count
>
> Sagi, Max,
> Any idea where can it be?

Laurence, Max,

We need to make sure that we never overflow number of mapping
elements.

Looking at the code, it seems that some of it was reworked by
Artemy for ODP.

Laurence, can you try and retest the below patch:
--
diff --git a/drivers/infiniband/hw/mlx5/qp.c 
b/drivers/infiniband/hw/mlx5/qp.c
index ad8a2638e339..76f3857ecd53 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3224,22 +3224,19 @@ static void set_reg_mkey_seg(struct 
mlx5_mkey_seg *seg,
                              struct mlx5_ib_mr *mr,
                              u32 key, int access)
  {
-       int ndescs = ALIGN(mr->ndescs, 8) >> 1;
+       int size = mr->ndescs * mr->desc_size;

         memset(seg, 0, sizeof(*seg));

         if (mr->access_mode == MLX5_MKC_ACCESS_MODE_MTT)
                 seg->log2_page_size = ilog2(mr->ibmr.page_size);
-       else if (mr->access_mode == MLX5_MKC_ACCESS_MODE_KLMS)
-               /* KLMs take twice the size of MTTs */
-               ndescs *= 2;

         seg->flags = get_umr_flags(access) | mr->access_mode;
         seg->qpn_mkey7_0 = cpu_to_be32((key & 0xff) | 0xffffff00);
         seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
         seg->start_addr = cpu_to_be64(mr->ibmr.iova);
         seg->len = cpu_to_be64(mr->ibmr.length);
-       seg->xlt_oct_size = cpu_to_be32(ndescs);
+       seg->xlt_oct_size = cpu_to_be32(get_xlt_octo(size));
  }

  static void set_linv_mkey_seg(struct mlx5_mkey_seg *seg)
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
