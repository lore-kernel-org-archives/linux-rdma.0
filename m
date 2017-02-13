From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Sun, 12 Feb 2017 22:14:53 -0500 (EST)
Message-ID: <1630482470.30208948.1486955693106.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170210235611.3243-9-bart.vanassche@sandisk.com> <20170212171928.GF14015@mtr-leonro.local> <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com> <1486929901.2918.1.camel@sandisk.com> <655392767.30136125.1486951636415.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <655392767.30136125.1486951636415.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Sunday, February 12, 2017 9:07:16 PM
> Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Sent: Sunday, February 12, 2017 3:05:16 PM
> > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a
> > QP
> > 
> > On Sun, 2017-02-12 at 13:02 -0500, Laurence Oberman wrote:
> > > [  861.143141] WARNING: CPU: 27 PID: 1103 at
> > > drivers/infiniband/core/verbs.c:1959 __ib_drain_sq+0x1bb/0x1c0 [ib_core]
> > > [  861.202208] IB_POLL_DIRECT poll_ctx not supported for drain
> > 
> > Hello Laurence,
> > 
> > That warning has been removed by patch 7/8 of this series. Please double
> > check
> > whether all eight patches have been applied properly.
> > 
> > Bart.N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��
> 
> Hello
> Just a heads up, working with Bart on this patch series.
> We have stability issues with my tests in my MLX5 EDR-100 test bed.
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I went back to Linus' latest tree for a baseline and we fail the same way.
This has none of the latest 8 patches applied so we will
have to figure out what broke this.

Dont forget that I tested all this recently with Bart's dma patch series
and its solid.

Will come back to this tomorrow and see what recently made it into Linus's tree by
checking back with Doug.

[  183.779175] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bd4270eb0
[  183.853047] 00000000 00000000 00000000 00000000
[  183.878425] 00000000 00000000 00000000 00000000
[  183.903243] 00000000 00000000 00000000 00000000
[  183.928518] 00000000 0f007806 2500002a ad9fafd1
[  198.538593] scsi host1: ib_srp: reconnect succeeded
[  198.573141] mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
[  198.603037] 00000000 00000000 00000000 00000000
[  198.628884] 00000000 00000000 00000000 00000000
[  198.653961] 00000000 00000000 00000000 00000000
[  198.680021] 00000000 0f007806 25000032 00105dd0
[  198.705985] scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880b92860138
[  213.532848] scsi host1: ib_srp: reconnect succeeded
[  213.568828] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  227.579684] scsi host1: ib_srp: reconnect succeeded
[  227.616175] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  242.633925] scsi host1: ib_srp: reconnect succeeded
[  242.668160] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  257.127715] scsi host1: ib_srp: reconnect succeeded
[  257.165623] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  272.225762] scsi host1: ib_srp: reconnect succeeded
[  272.262570] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  286.350226] scsi host1: ib_srp: reconnect succeeded
[  286.386160] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  301.109365] scsi host1: ib_srp: reconnect succeeded
[  301.144930] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  315.910860] scsi host1: ib_srp: reconnect succeeded
[  315.944594] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  330.551052] scsi host1: ib_srp: reconnect succeeded
[  330.584552] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  344.998448] scsi host1: ib_srp: reconnect succeeded
[  345.032115] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  359.866731] scsi host1: ib_srp: reconnect succeeded
[  359.902114] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
..
..
[  373.113045] scsi host1: ib_srp: reconnect succeeded
[  373.149511] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  388.401469] fast_io_fail_tmo expired for SRP port-1:1 / host1.
[  388.589517] scsi host1: ib_srp: reconnect succeeded
[  388.623462] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  403.086893] scsi host1: ib_srp: reconnect succeeded
[  403.120876] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f2234c30
[  403.140401] mlx5_0:dump_cqe:262:(pid 749): dump error cqe
[  403.140402] 00000000 00000000 00000000 00000000
[  403.140402] 00000000 00000000 00000000 00000000
[  403.140403] 00000000 00000000 00000000 00000000
[  403.140403] 00

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
