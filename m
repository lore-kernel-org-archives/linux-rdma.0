From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Tue, 25 Apr 2017 16:37:35 -0400 (EDT)
Message-ID: <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com> <20170425175849.GS14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425175849.GS14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, April 25, 2017 1:58:49 PM
> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> 
> On Mon, Apr 24, 2017 at 03:15:28PM -0700, Bart Van Assche wrote:
> > ib_map_mr_sg() can pass an SG-list to .map_mr_sg() that is larger
> > than what fits into a single MR. .map_mr_sg() must not attempt to
> > map more SG-list elements than what fits into a single MR.
> > Hence make sure that mlx5_ib_sg_to_klms() does not write outside
> > the MR klms[] array.
> >
> > Fixes: b005d3164713 ("mlx5: Add arbitrary sg list support")
> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> > Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/mr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> 
> Bart,
> 
> Thanks a lot, it indeed looks right.
> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Thanks
> 


Hello Bart, Leon, Max and Israel.

I cloned off Barts tree.

git clone https://github.com/bvanassche/linux
cd linux
git checkout block-scsi-for-next

I checked all patches were in for this test.

a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt

Built and tested the kernel.

However this issue is not resolved :(

[ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817edca86b0
[ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
[ 2708.121342] 00000000 00000000 00000000 00000000
[ 2708.147104] 00000000 00000000 00000000 00000000
[ 2708.172633] 00000000 00000000 00000000 00000000
[ 2708.198702] 00000000 0f007806 2500002a 14a527d0
[ 2732.434127] scsi host1: ib_srp: reconnect succeeded
[ 2733.048023] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817ed0a9c30

[root@localhost ~]# [ 2746.413277] mlx5_0:dump_cqe:262:(pid 15877): dump error cqe
[ 2746.443240] 00000000 00000000 00000000 00000000
[ 2746.469323] 00000000 00000000 00000000 00000000
[ 2746.495310] 00000000 00000000 00000000 00000000
[ 2746.521407] 00000000 0f007806 25000032 003c7ad0
[ 2752.445899] scsi host1: ib_srp: reconnect succeeded
[ 2752.481835] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817ed0a9cf0
[ 2763.267386] mlx5_0:dump_cqe:262:(pid 15877): dump error cqe
[ 2763.297826] 00000000 00000000 00000000 00000000
[ 2763.323352] 00000000 00000000 00000000 00000000
[ 2763.348722] 00000000 00000000 00000000 00000000
[ 2763.374681] 00000000 0f007806 2500003a 00084bd0

[root@localhost ~]# [ 2769.385203] fast_io_fail_tmo expired for SRP port-1:1 / host1.
[ 2769.415956] scsi host1: ib_srp: reconnect succeeded
[ 2769.450258] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817ed0a9cf0
[ 2780.064627] mlx5_0:dump_cqe:262:(pid 18771): dump error cqe
[ 2780.093520] 00000000 00000000 00000000 00000000
[ 2780.120067] 00000000 00000000 00000000 00000000
[ 2780.145575] 00000000 00000000 00000000 00000000
[ 2780.171153] 00000000 0f007806 25000042 000833d0
[ 2785.923399] scsi host1: ib_srp: reconnect succeeded
[ 2785.957504] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817ed0a9cf0
[ 2796.463426] mlx5_0:dump_cqe:262:(pid 18771): dump error cqe
[ 2796.495257] 00000000 00000000 00000000 00000000
[ 2796.521506] 00000000 00000000 00000000 00000000
[ 2796.547640] 00000000 00000000 00000000 00000000
[ 2796.573120] 00000000 0f007806 2500004a 00083bd0
[ 2802.562578] scsi host1: ib_srp: reconnect succeeded
[ 2802.596880] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817ed0a9cf0

Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
