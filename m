From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Mon, 13 Feb 2017 16:46:40 -0500 (EST)
Message-ID: <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <1630482470.30208948.1486955693106.JavaMail.zimbra@redhat.com> <1633827327.30531404.1486994093828.JavaMail.zimbra@redhat.com> <20170213141724.GQ14015@mtr-leonro.local> <225897984.30545262.1486995841880.JavaMail.zimbra@redhat.com> <1971987443.30613645.1487002375580.JavaMail.zimbra@redhat.com> <21338434.30712464.1487004451595.JavaMail.zimbra@redhat.com> <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301607843.30852658.1487021644535.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Monday, February 13, 2017 4:34:04 PM
> Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org,
> > maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Sent: Monday, February 13, 2017 11:47:31 AM
> > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a
> > QP
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org,
> > > maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > Sent: Monday, February 13, 2017 11:12:55 AM
> > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a
> > > QP
> > > 
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org,
> > > > maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > Sent: Monday, February 13, 2017 9:24:01 AM
> > > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying
> > > > a
> > > > QP
> > > > 
> > > > 
> > > > 
> > > > ----- Original Message -----
> > > > > From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > > To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org,
> > > > > maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > > Sent: Monday, February 13, 2017 9:17:24 AM
> > > > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before
> > > > > destroying
> > > > > a
> > > > > QP
> > > > > 
> > > > > On Mon, Feb 13, 2017 at 08:54:53AM -0500, Laurence Oberman wrote:
> > > > > >
> > > > > >
> > > > > > ----- Original Message -----
> > > > > > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > > > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > > > > > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > > > > israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> > > > > > > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > > > > Sent: Sunday, February 12, 2017 10:14:53 PM
> > > > > > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before
> > > > > > > destroying
> > > > > > > a
> > > > > > > QP
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > ----- Original Message -----
> > > > > > > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > > > > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > > > > > > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > > > > > israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > > > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> > > > > > > > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > > > > > Sent: Sunday, February 12, 2017 9:07:16 PM
> > > > > > > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before
> > > > > > > > destroying
> > > > > > > > a
> > > > > > > > QP
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > ----- Original Message -----
> > > > > > > > > From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > > > > > > > To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > > > > > > Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > > > > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > > > > > > Sent: Sunday, February 12, 2017 3:05:16 PM
> > > > > > > > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before
> > > > > > > > > destroying a
> > > > > > > > > QP
> > > > > > > > >
> > > > > > > > > On Sun, 2017-02-12 at 13:02 -0500, Laurence Oberman wrote:
> > > > > > > > > > [  861.143141] WARNING: CPU: 27 PID: 1103 at
> > > > > > > > > > drivers/infiniband/core/verbs.c:1959
> > > > > > > > > > __ib_drain_sq+0x1bb/0x1c0
> > > > > > > > > > [ib_core]
> > > > > > > > > > [  861.202208] IB_POLL_DIRECT poll_ctx not supported for
> > > > > > > > > > drain
> > > > > > > > >
> > > > > > > > > Hello Laurence,
> > > > > > > > >
> > > > > > > > > That warning has been removed by patch 7/8 of this series.
> > > > > > > > > Please
> > > > > > > > > double
> > > > > > > > > check
> > > > > > > > > whether all eight patches have been applied properly.
> > > > > > > > >
> > > > > > > > > Bart.N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��
> > > > > > > >
> > > > > > > > Hello
> > > > > > > > Just a heads up, working with Bart on this patch series.
> > > > > > > > We have stability issues with my tests in my MLX5 EDR-100 test
> > > > > > > > bed.
> > > > > > > > Thanks
> > > > > > > > Laurence
> > > > > > > > --
> > > > > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > > > > linux-rdma"
> > > > > > > > in
> > > > > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > > > More majordomo info at
> > > > > > > > http://vger.kernel.org/majordomo-info.html
> > > > > > > >
> > > > > > >
> > > > > > > I went back to Linus' latest tree for a baseline and we fail the
> > > > > > > same
> > > > > > > way.
> > > > > > > This has none of the latest 8 patches applied so we will
> > > > > > > have to figure out what broke this.
> > > > > > >
> > > > > > > Dont forget that I tested all this recently with Bart's dma patch
> > > > > > > series
> > > > > > > and its solid.
> > > > > > >
> > > > > > > Will come back to this tomorrow and see what recently made it
> > > > > > > into
> > > > > > > Linus's
> > > > > > > tree by
> > > > > > > checking back with Doug.
> > > > > > >
> > > > > > > [  183.779175] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff880bd4270eb0
> > > > > > > [  183.853047] 00000000 00000000 00000000 00000000
> > > > > > > [  183.878425] 00000000 00000000 00000000 00000000
> > > > > > > [  183.903243] 00000000 00000000 00000000 00000000
> > > > > > > [  183.928518] 00000000 0f007806 2500002a ad9fafd1
> > > > > > > [  198.538593] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  198.573141] mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > > > > > > [  198.603037] 00000000 00000000 00000000 00000000
> > > > > > > [  198.628884] 00000000 00000000 00000000 00000000
> > > > > > > [  198.653961] 00000000 00000000 00000000 00000000
> > > > > > > [  198.680021] 00000000 0f007806 25000032 00105dd0
> > > > > > > [  198.705985] scsi host1: ib_srp: failed FAST REG status memory
> > > > > > > management
> > > > > > > operation error (6) for CQE ffff880b92860138
> > > > > > > [  213.532848] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  213.568828] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  227.579684] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  227.616175] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  242.633925] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  242.668160] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  257.127715] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  257.165623] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  272.225762] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  272.262570] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  286.350226] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  286.386160] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  301.109365] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  301.144930] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  315.910860] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  315.944594] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  330.551052] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  330.584552] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  344.998448] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  345.032115] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  359.866731] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  359.902114] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > ..
> > > > > > > ..
> > > > > > > [  373.113045] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  373.149511] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  388.401469] fast_io_fail_tmo expired for SRP port-1:1 / host1.
> > > > > > > [  388.589517] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  388.623462] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  403.086893] scsi host1: ib_srp: reconnect succeeded
> > > > > > > [  403.120876] scsi host1: ib_srp: failed RECV status WR flushed
> > > > > > > (5)
> > > > > > > for
> > > > > > > CQE
> > > > > > > ffff8817f2234c30
> > > > > > > [  403.140401] mlx5_0:dump_cqe:262:(pid 749): dump error cqe
> > > > > > > [  403.140402] 00000000 00000000 00000000 00000000
> > > > > > > [  403.140402] 00000000 00000000 00000000 00000000
> > > > > > > [  403.140403] 00000000 00000000 00000000 00000000
> > > > > > > [  403.140403] 00
> > > > > > >
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > > > linux-rdma"
> > > > > > > in
> > > > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > > More majordomo info at
> > > > > > > http://vger.kernel.org/majordomo-info.html
> > > > > > >
> > > > > > Hello
> > > > > >
> > > > > > Let summarize where we are and how we got here.
> > > > > >
> > > > > > The last kernel I tested with mlx5 and ib_srp was
> > > > > > vmlinuz-4.10.0-rc4
> > > > > > with
> > > > > > Barts dma patches.
> > > > > > All tests passed.
> > > > > >
> > > > > > I pulled Linus's tree and applied all 8 patches of the above series
> > > > > > and
> > > > > > we
> > > > > > failed in the
> > > > > > "failed FAST REG status memory management" area.
> > > > > >
> > > > > > I applied only 7 of the 8 patches to Linus's tree because Bart and
> > > > > > I
> > > > > > thought patch 6 of the series
> > > > > > may have been the catalyst.
> > > > > >
> > > > > > This also failed.
> > > > > >
> > > > > > Building from Barts tree which is based on 4.10.0-rc7 failed again.
> > > > > >
> > > > > > This made me decide to baseline Linus's tree 4.10.0-rc7 and we
> > > > > > fail.
> > > > > >
> > > > > > So something has crept into 4.10.0-rc7 affecting this with mlx5 and
> > > > > > ib_srp.
> > > > > 
> > > > > From infiniband side:
> > > > > ➜  linux-rdma git:(queue-next) git log v4.10-rc4...v4.10-rc7 --
> > > > > drivers/inifiniband |wc
> > > > >       0       0       0
> > > > > 
> > > > > From eth nothing suspicious too:
> > > > > ➜  linux-rdma git:(queue-next) git l v4.10-rc4...v4.10-rc7 --
> > > > > drivers/net/ethernet/mellanox/mlx5
> > > > > d15118af2683 net/mlx5e: Check ets capability before ets query FW
> > > > > command
> > > > > a100ff3eef19 net/mlx5e: Fix update of hash function/key via ethtool
> > > > > 1d3398facd08 net/mlx5e: Modify TIRs hash only when it's needed
> > > > > 3e621b19b0bb net/mlx5e: Support TC encapsulation offloads with upper
> > > > > devices
> > > > > 5bae8c031053 net/mlx5: E-Switch, Re-enable RoCE on mode change only
> > > > > after
> > > > > FDB
> > > > > destroy
> > > > > 5403dc703ff2 net/mlx5: E-Switch, Err when retrieving steering
> > > > > name-space
> > > > > fails
> > > > > eff596da4878 net/mlx5: Return EOPNOTSUPP when failing to get steering
> > > > > name-space
> > > > > 9eb7892351a3 net/mlx5: Change ENOTSUPP to EOPNOTSUPP
> > > > > e048fc50d7bd net/mlx5e: Do not recycle pages from emergency reserve
> > > > > ad05df399f33 net/mlx5e: Remove unused variable
> > > > > 639e9e94160e net/mlx5e: Remove unnecessary checks when setting num
> > > > > channels
> > > > > abeffce90c7f net/mlx5e: Fix a -Wmaybe-uninitialized warning
> > > > > 
> > > > > 
> > > > > >
> > > > > > Thanks
> > > > > > Laurence
> > > > > 
> > > > 
> > > > Hi Leon,
> > > > Yep, I also looked for outliers here that may look suspicious and did
> > > > not
> > > > see
> > > > any.
> > > > 
> > > > I guess I will have to start bisecting.
> > > > I will start with rc5, if that fails will bisect between rc4 and rc5,
> > > > as
> > > > we
> > > > know rc4 was fine.
> > > > 
> > > > I did re-run tests on rc4 last night and I was stable.
> > > > 
> > > > Thanks
> > > > Laurence
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > > in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > 
> > > OK, so 4.10.0-rc5 is fine, 4.10.0-rc6 fails, so will start bisecting.
> > > Unless one of you think you know what may be causing this in rc6.
> > > This will take time so will come back to the list once I have it
> > > isolated.
> > > 
> > > Thanks
> > > Laurence
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > Bisect has 8 possible kernel builds, 200 + changes, started the first one.
> > 
> > Thanks
> > Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> Hello
> 
> Bisecting got me to this commit, I had reviewed this looking for an
> explanation at some point.
> At the time, I did not understand the need for the change but after
> explanation I accepted it.
> I reverted this and we are good again but reading the code, not seeing how
> this is affecting us.
>  
> Makes no sense how this can be the issue.
> 
> Nevertheless we will need to revert this please.
> 
> I will now apply the 8 patches from Bart to Linus's tree with this reverted
> and test again.
> 
> Bisect run
> 
> git bisect start
> git bisect bad  566cf877a1fcb6d6dc0126b076aad062054c2637
> git bisect good 7a308bb3016f57e5be11a677d15b821536419d36
> git bisect good
> git bisect good
> git bisect bad
> git bisect bad
> git bisect bad
> git bisect bad
> git bisect good
> 
> Bisecting: 0 revisions left to test after this (roughly 1 step)
> [0a475ef4226e305bdcffe12b401ca1eab06c4913] IB/srp: fix invalid
> indirect_sg_entries parameter value
> [loberman@ibclient linux-torvalds]$ git show
> 0a475ef4226e305bdcffe12b401ca1eab06c4913
> commit 0a475ef4226e305bdcffe12b401ca1eab06c4913
> Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Wed Jan 4 15:59:37 2017 +0200
> 
>     IB/srp: fix invalid indirect_sg_entries parameter value
>     
>     After setting indirect_sg_entries module_param to huge value (e.g
>     500,000),
>     srp_alloc_req_data() fails to allocate indirect descriptors for the
>     request
>     ring (kmalloc fails). This commit enforces the maximum value of
>     indirect_sg_entries to be SG_MAX_SEGMENTS as signified in module param
>     description.
>     
>     Fixes: 65e8617fba17 (scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS)
>     Fixes: c07d424d6118 (IB/srp: add support for indirect tables that don't
>     fit in SRP_CMD)
>     Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.7+
>     Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Reviewed-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>--
>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> b/drivers/infiniband/ulp/srp/ib_srp.c
> index 0f67cf9..79bf484 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3699,6 +3699,12 @@ static int __init srp_init_module(void)
>                 indirect_sg_entries = cmd_sg_entries;
>         }
>  
> +       if (indirect_sg_entries > SG_MAX_SEGMENTS) {
> +               pr_warn("Clamping indirect_sg_entries to %u\n",
> +                       SG_MAX_SEGMENTS);
> +               indirect_sg_entries = SG_MAX_SEGMENTS;
> +       }
> +
>         srp_remove_wq = create_workqueue("srp_remove");
>         if (!srp_remove_wq) {
>                 ret = -ENOMEM;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello

The revert actually does not help. it failed after a while.

This mail was in drafts while I was testing and it got sent and should not have been.
The revert does not help which I am happy about because it made no sense.

So not sure how the bisect got me here but it did.

I will have to run through this again and see where the bisect went wrong.

Thanks
Laurence

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
