From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Wed, 3 May 2017 10:15:50 -0400 (EDT)
Message-ID: <501334895.4531615.1493820950718.JavaMail.zimbra@redhat.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com> <20170425175849.GS14088@mtr-leonro.local> <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com> <20170426061640.GV14088@mtr-leonro.local> <bcd56de8-0f17-f2bb-b079-bf22c1b92ca2@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bcd56de8-0f17-f2bb-b079-bf22c1b92ca2-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> To: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy"
> <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Wednesday, May 3, 2017 4:18:38 AM
> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> 
> 
> >> Hello Bart, Leon, Max and Israel.
> >>
> >> I cloned off Barts tree.
> >>
> >> git clone https://github.com/bvanassche/linux
> >> cd linux
> >> git checkout block-scsi-for-next
> >>
> >> I checked all patches were in for this test.
> >>
> >> a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
> >> dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> >> f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
> >>
> >> Built and tested the kernel.
> >>
> >> However this issue is not resolved :(
> >>
> >> [ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5) for
> >> CQE ffff8817edca86b0
> >> [ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
> >> [ 2708.121342] 00000000 00000000 00000000 00000000
> >> [ 2708.147104] 00000000 00000000 00000000 00000000
> >> [ 2708.172633] 00000000 00000000 00000000 00000000
> >> [ 2708.198702] 00000000 0f007806 2500002a 14a527d0
> >
> > Parsed version:
> > 	hw_error_syndrome                : 0xf
> > 	hw_syndrome_type                 : 0x0
> > 	vendor_error_syndrome            : 0x78
> > 	syndrome                         : MEMORY_WINDOW_BIND_ERROR (0x6)
> > 	s_wqe_opcode                     : UMR (0x25)
> > 	opcode                           : REQUESTOR_ERROR (0xd)
> > 	cqe_format                       : NO_INLINE_DATA (0x0)
> > 	owner                            : 0x0
> >
> > Description:
> > 	umr.klm_octoword_count > mkey.mtt_octoword_count
> >
> > Sagi, Max,
> > Any idea where can it be?
> 
> Laurence, Max,
> 
> We need to make sure that we never overflow number of mapping
> elements.
> 
> Looking at the code, it seems that some of it was reworked by
> Artemy for ODP.
> 
> Laurence, can you try and retest the below patch:
> --
> diff --git a/drivers/infiniband/hw/mlx5/qp.c
> b/drivers/infiniband/hw/mlx5/qp.c
> index ad8a2638e339..76f3857ecd53 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3224,22 +3224,19 @@ static void set_reg_mkey_seg(struct
> mlx5_mkey_seg *seg,
>                               struct mlx5_ib_mr *mr,
>                               u32 key, int access)
>   {
> -       int ndescs = ALIGN(mr->ndescs, 8) >> 1;
> +       int size = mr->ndescs * mr->desc_size;
> 
>          memset(seg, 0, sizeof(*seg));
> 
>          if (mr->access_mode == MLX5_MKC_ACCESS_MODE_MTT)
>                  seg->log2_page_size = ilog2(mr->ibmr.page_size);
> -       else if (mr->access_mode == MLX5_MKC_ACCESS_MODE_KLMS)
> -               /* KLMs take twice the size of MTTs */
> -               ndescs *= 2;
> 
>          seg->flags = get_umr_flags(access) | mr->access_mode;
>          seg->qpn_mkey7_0 = cpu_to_be32((key & 0xff) | 0xffffff00);
>          seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
>          seg->start_addr = cpu_to_be64(mr->ibmr.iova);
>          seg->len = cpu_to_be64(mr->ibmr.length);
> -       seg->xlt_oct_size = cpu_to_be32(ndescs);
> +       seg->xlt_oct_size = cpu_to_be32(get_xlt_octo(size));
>   }
> 
>   static void set_linv_mkey_seg(struct mlx5_mkey_seg *seg)
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Sagi
Against Bart's tree again

a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt

Above are all in
Added your most recent patch above

Same behavior.
[  579.368733] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817de9c57b0
[  579.369875] mlx5_1:dump_cqe:262:(pid 15140): dump error cqe
[  579.369877] 00000000 00000000 00000000 00000000
[  579.369877] 00000000 00000000 00000000 00000000
[  579.369878] 00000000 00000000 00000000 00000000
[  579.369878] 00000000 0f007806 2500002b 1c528dd0
[  579.369883] scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff88179a460af8
[  594.814222] scsi host1: ib_srp: reconnect succeeded
[  594.916876] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817e1d4a6b0
[  595.494532] mlx5_1:dump_cqe:262:(pid 15205): dump error cqe
[  595.525995] 00000000 00000000 00000000 00000000
[  595.552125] 00000000 00000000 00000000 00000000
[  595.578204] 00000000 00000000 00000000 00000000
[  595.603670] 00000000 0f007806 25000033 002d77d0
^C[  610.821911] scsi host1: ib_srp: reconnect succeeded
[  610.933298] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817e1d4a170
[  611.514234] mlx5_1:dump_cqe:262:(pid 15242): dump error cqe
[  611.543083] 00000000 00000000 00000000 00000000
[  611.568670] 00000000 00000000 00000000 00000000
[  611.594064] 00000000 00000000 00000000 00000000
[  611.620142] 00000000 0f007806 2500003b 003161d0

I will capture the function traces with your patch applied and the additional logging asked for by Max.
Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
