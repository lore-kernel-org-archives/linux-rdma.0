From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 11:37:27 -0500 (EST)
Message-ID: <1557361565.31861655.1487176647067.JavaMail.zimbra@redhat.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com> <20170214185636.29250-2-bart.vanassche@sandisk.com> <cebcaeae-94a6-de82-cfc8-ce055b273836@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cebcaeae-94a6-de82-cfc8-ce055b273836-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "# 4 . 7+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Leon
> Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Mark Bloch" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "# 4 .
> 7+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Sent: Wednesday, February 15, 2017 10:38:06 AM
> Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> 
> 
> > Tests have shown that the following error message is reported when
> > using SG-GAPS registration with an mlx5 adapter:
> >
> > scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE
> > ffff880bd4270eb0
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 0f007806 2500002a ad9fafd1
> > scsi host1: ib_srp: reconnect succeeded
> > mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 0f007806 25000032 00105dd0
> > scsi host1: ib_srp: failed FAST REG status memory management operation
> > error (6) for CQE ffff880b92860138
> >
> > Hence avoid using SG-GAPS memory registrations. Additionally,
> > always configure the blk_queue_virt_boundary() to avoid to trigger
> > a mapping failure when using adapters that support SG-GAPS (e.g.
> > mlx5).
> 
> Hi Guys,
> 
> Sorry for addressing this late, but has this failure been investigated?
> 
> Max, Israel, what does this error syndrome map to?
> 
> Looking at mlx5_ib_sg_to_klms, I think the mr->length is incorrectly
> incremented. Does the following change fix the problem?
> --
> diff --git a/drivers/infiniband/hw/mlx5/mr.c
> b/drivers/infiniband/hw/mlx5/mr.c
> index 8f608debe141..c21c9eee37f6 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1832,7 +1832,7 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
>                  klms[i].va = cpu_to_be64(sg_dma_address(sg) + sg_offset);
>                  klms[i].bcount = cpu_to_be32(sg_dma_len(sg) - sg_offset);
>                  klms[i].key = cpu_to_be32(lkey);
> -               mr->ibmr.length += sg_dma_len(sg);
> +               mr->ibmr.length += sg_dma_len(sg) - sg_offset;
> 
>                  sg_offset = 0;
>          }
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Started with Linus's tree, applied the change requested by Sagi, built the kernel, rebooted and started the tests.

Linux ibclient 4.10.0-rc8.sagi+ #1 SMP Wed Feb 15 11:09:44 EST 2017 x86_64 x86_64 x86_64 GNU/Linux

Very quickly get to this

[  180.990285] mlx5_0:dump_cqe:262:(pid 0): dump error cqe
[  181.016899] 00000000 00000000 00000000 00000000
[  181.040949] 00000000 00000000 00000000 00000000
[  181.066960] 00000000 00000000 00000000 00000000
[  181.092030] 00000000 0f007806 2500002a bf1913d0
[  181.117254] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bdbe88778
[  196.288933] fast_io_fail_tmo expired for SRP port-2:1 / host2.
[  197.090886] scsi host2: ib_srp: reconnect succeeded
[  197.127628] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f09b6f30

So does not help.
I think my and Barts suggestion to revert for now is the best way forward.
I have already tested this in-depth from Bart's tree and its been sent to Doug as V2 of Bart'recent 8 patch series.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
