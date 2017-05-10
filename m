From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Wed, 10 May 2017 10:06:47 -0400 (EDT)
Message-ID: <1415936724.7101967.1494425207538.JavaMail.zimbra@redhat.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com> <20170425175849.GS14088@mtr-leonro.local> <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com> <20170426061640.GV14088@mtr-leonro.local> <bcd56de8-0f17-f2bb-b079-bf22c1b92ca2@grimberg.me> <501334895.4531615.1493820950718.JavaMail.zimbra@redhat.com> <374fcc74-4b84-610b-b55e-d385563bef6f@grimberg.me> <1072634318.5542006.1494001866306.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1072634318.5542006.1494001866306.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Friday, May 5, 2017 12:31:06 PM
> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> 
> 
> 
> ----- Original Message -----
> > From: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> > To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Bart Van Assche"
> > <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford"
> > <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Israel Rukshin"
> > <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Wednesday, May 3, 2017 10:58:43 AM
> > Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
> > overflows the klms[] array
> > 
> > 
> > > Hello Sagi
> > > Against Bart's tree again
> > >
> > > a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
> > > dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> > > f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
> > >
> > > Above are all in
> > > Added your most recent patch above
> > >
> > > Same behavior.
> > > [  579.368733] scsi host1: ib_srp: failed RECV status WR flushed (5) for
> > > CQE ffff8817de9c57b0
> > > [  579.369875] mlx5_1:dump_cqe:262:(pid 15140): dump error cqe
> > > [  579.369877] 00000000 00000000 00000000 00000000
> > > [  579.369877] 00000000 00000000 00000000 00000000
> > > [  579.369878] 00000000 00000000 00000000 00000000
> > > [  579.369878] 00000000 0f007806 2500002b 1c528dd0
> > > [  579.369883] scsi host1: ib_srp: failed FAST REG status memory
> > > management
> > > operation error (6) for CQE ffff88179a460af8
> > > [  594.814222] scsi host1: ib_srp: reconnect succeeded
> > > [  594.916876] scsi host1: ib_srp: failed RECV status WR flushed (5) for
> > > CQE ffff8817e1d4a6b0
> > > [  595.494532] mlx5_1:dump_cqe:262:(pid 15205): dump error cqe
> > > [  595.525995] 00000000 00000000 00000000 00000000
> > > [  595.552125] 00000000 00000000 00000000 00000000
> > > [  595.578204] 00000000 00000000 00000000 00000000
> > > [  595.603670] 00000000 0f007806 25000033 002d77d0
> > > ^C[  610.821911] scsi host1: ib_srp: reconnect succeeded
> > > [  610.933298] scsi host1: ib_srp: failed RECV status WR flushed (5) for
> > > CQE ffff8817e1d4a170
> > > [  611.514234] mlx5_1:dump_cqe:262:(pid 15242): dump error cqe
> > > [  611.543083] 00000000 00000000 00000000 00000000
> > > [  611.568670] 00000000 00000000 00000000 00000000
> > > [  611.594064] 00000000 00000000 00000000 00000000
> > > [  611.620142] 00000000 0f007806 2500003b 003161d0
> > >
> > > I will capture the function traces with your patch applied and the
> > > additional logging asked for by Max.
> > 
> > Thanks, that would be helpful,
> > 
> > Can you try the following patch, just to see if there is an off by 1 case:
> > 
> > --
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > b/drivers/infiniband/hw/mlx5/mr.c
> > index b8f9382a8b7d..3d6ef7bce7d9 100644
> > --- a/drivers/infiniband/hw/mlx5/mr.c
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -1525,7 +1525,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
> >   {
> >          struct mlx5_ib_dev *dev = to_mdev(pd->device);
> >          int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
> > -       int ndescs = ALIGN(max_num_sg, 4);
> > +       int ndescs = ALIGN(max_num_sg + 1, 4);
> >          struct mlx5_ib_mr *mr;
> >          void *mkc;
> >          u32 *in;
> > --
> > 
> > It's not a fix, but if it works it can give us a clue...
> > 
> 
> Sorry, been delayed this week, will get this done this weekend.
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Sagi, Max 

With the patch below against Barts tree we still see the cqe_dump issue.

Is what is in the everything you wanted applied.
Please check I did not miss anything before I start the tracing.

May  9 17:16:00 localhost kernel: scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817ed75c830
May  9 17:16:00 localhost kernel: mlx5_1:dump_cqe:262:(pid 14567): dump error cqe
May  9 17:16:00 localhost kernel: 00000000 00000000 00000000 00000000
May  9 17:16:00 localhost kernel: 00000000 00000000 00000000 00000000
May  9 17:16:00 localhost kernel: 00000000 00000000 00000000 00000000
May  9 17:16:00 localhost kernel: 00000000 0f007806 2500002a 0b670bd0
May  9 17:16:00 localhost kernel: scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff8817972ac278
May  9 17:16:16 localhost kernel: scsi host2: ib_srp: reconnect succeeded
May  9 17:16:16 localhost kernel: scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817d819b130


diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 99beacf..cf899b4 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1525,7 +1525,8 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 {
        struct mlx5_ib_dev *dev = to_mdev(pd->device);
        int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-       int ndescs = ALIGN(max_num_sg, 4);
+       //int ndescs = ALIGN(max_num_sg, 4);
+       int ndescs = ALIGN(max_num_sg + 1, 4);
        struct mlx5_ib_mr *mr;
        void *mkc;
        u32 *in;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ad8a263..cb726a5 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3224,22 +3224,19 @@ static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
                             struct mlx5_ib_mr *mr,
                             u32 key, int access)
 {
-       int ndescs = ALIGN(mr->ndescs, 8) >> 1;
+        int size = mr->ndescs * mr->desc_size;
 
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
+        seg->xlt_oct_size = cpu_to_be32(get_xlt_octo(size));
 }

I will see about capturing traces, but I am writing to a RAM disk on the target so likely will have a flood of trace data.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
