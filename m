From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Mon, 13 Feb 2017 16:17:24 +0200
Message-ID: <20170213141724.GQ14015@mtr-leonro.local>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
 <20170210235611.3243-9-bart.vanassche@sandisk.com>
 <20170212171928.GF14015@mtr-leonro.local>
 <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com>
 <1486929901.2918.1.camel@sandisk.com>
 <655392767.30136125.1486951636415.JavaMail.zimbra@redhat.com>
 <1630482470.30208948.1486955693106.JavaMail.zimbra@redhat.com>
 <1633827327.30531404.1486994093828.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WOTjKnJ88wpJKlWH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1633827327.30531404.1486994093828.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WOTjKnJ88wpJKlWH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2017 at 08:54:53AM -0500, Laurence Oberman wrote:
>
>
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzXQFizaE/u3fw@public.gmane.org=
m, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Sent: Sunday, February 12, 2017 10:14:53 PM
> > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying=
 a QP
> >
> >
> >
> > ----- Original Message -----
> > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr@mellanox.=
com,
> > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> > > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > Sent: Sunday, February 12, 2017 9:07:16 PM
> > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroyi=
ng a
> > > QP
> > >
> > >
> > >
> > > ----- Original Message -----
> > > > From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > > To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > Sent: Sunday, February 12, 2017 3:05:16 PM
> > > > Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destro=
ying a
> > > > QP
> > > >
> > > > On Sun, 2017-02-12 at 13:02 -0500, Laurence Oberman wrote:
> > > > > [  861.143141] WARNING: CPU: 27 PID: 1103 at
> > > > > drivers/infiniband/core/verbs.c:1959 __ib_drain_sq+0x1bb/0x1c0
> > > > > [ib_core]
> > > > > [  861.202208] IB_POLL_DIRECT poll_ctx not supported for drain
> > > >
> > > > Hello Laurence,
> > > >
> > > > That warning has been removed by patch 7/8 of this series. Please d=
ouble
> > > > check
> > > > whether all eight patches have been applied properly.
> > > >
> > > > Bart.N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=
=BDy=EF=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=
=BD^=EF=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=
=BF=BD=EF=BF=BD=D9=9A=EF=BF=BD{ay=EF=BF=BD=CA=87=DA=99=EF=BF=BD,j=EF=BF=BD=
=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=
=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=EF=BF=
=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=
=BD=EF=BF=BD
> > >
> > > Hello
> > > Just a heads up, working with Bart on this patch series.
> > > We have stability issues with my tests in my MLX5 EDR-100 test bed.
> > > Thanks
> > > Laurence
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> > I went back to Linus' latest tree for a baseline and we fail the same w=
ay.
> > This has none of the latest 8 patches applied so we will
> > have to figure out what broke this.
> >
> > Dont forget that I tested all this recently with Bart's dma patch series
> > and its solid.
> >
> > Will come back to this tomorrow and see what recently made it into Linu=
s's
> > tree by
> > checking back with Doug.
> >
> > [  183.779175] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff880bd4270eb0
> > [  183.853047] 00000000 00000000 00000000 00000000
> > [  183.878425] 00000000 00000000 00000000 00000000
> > [  183.903243] 00000000 00000000 00000000 00000000
> > [  183.928518] 00000000 0f007806 2500002a ad9fafd1
> > [  198.538593] scsi host1: ib_srp: reconnect succeeded
> > [  198.573141] mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > [  198.603037] 00000000 00000000 00000000 00000000
> > [  198.628884] 00000000 00000000 00000000 00000000
> > [  198.653961] 00000000 00000000 00000000 00000000
> > [  198.680021] 00000000 0f007806 25000032 00105dd0
> > [  198.705985] scsi host1: ib_srp: failed FAST REG status memory manage=
ment
> > operation error (6) for CQE ffff880b92860138
> > [  213.532848] scsi host1: ib_srp: reconnect succeeded
> > [  213.568828] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  227.579684] scsi host1: ib_srp: reconnect succeeded
> > [  227.616175] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  242.633925] scsi host1: ib_srp: reconnect succeeded
> > [  242.668160] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  257.127715] scsi host1: ib_srp: reconnect succeeded
> > [  257.165623] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  272.225762] scsi host1: ib_srp: reconnect succeeded
> > [  272.262570] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  286.350226] scsi host1: ib_srp: reconnect succeeded
> > [  286.386160] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  301.109365] scsi host1: ib_srp: reconnect succeeded
> > [  301.144930] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  315.910860] scsi host1: ib_srp: reconnect succeeded
> > [  315.944594] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  330.551052] scsi host1: ib_srp: reconnect succeeded
> > [  330.584552] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  344.998448] scsi host1: ib_srp: reconnect succeeded
> > [  345.032115] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  359.866731] scsi host1: ib_srp: reconnect succeeded
> > [  359.902114] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > ..
> > ..
> > [  373.113045] scsi host1: ib_srp: reconnect succeeded
> > [  373.149511] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  388.401469] fast_io_fail_tmo expired for SRP port-1:1 / host1.
> > [  388.589517] scsi host1: ib_srp: reconnect succeeded
> > [  388.623462] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  403.086893] scsi host1: ib_srp: reconnect succeeded
> > [  403.120876] scsi host1: ib_srp: failed RECV status WR flushed (5) fo=
r CQE
> > ffff8817f2234c30
> > [  403.140401] mlx5_0:dump_cqe:262:(pid 749): dump error cqe
> > [  403.140402] 00000000 00000000 00000000 00000000
> > [  403.140402] 00000000 00000000 00000000 00000000
> > [  403.140403] 00000000 00000000 00000000 00000000
> > [  403.140403] 00
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> Hello
>
> Let summarize where we are and how we got here.
>
> The last kernel I tested with mlx5 and ib_srp was vmlinuz-4.10.0-rc4 with=
 Barts dma patches.
> All tests passed.
>
> I pulled Linus's tree and applied all 8 patches of the above series and w=
e failed in the
> "failed FAST REG status memory management" area.
>
> I applied only 7 of the 8 patches to Linus's tree because Bart and I thou=
ght patch 6 of the series
> may have been the catalyst.
>
> This also failed.
>
> Building from Barts tree which is based on 4.10.0-rc7 failed again.
>
> This made me decide to baseline Linus's tree 4.10.0-rc7 and we fail.
>
> So something has crept into 4.10.0-rc7 affecting this with mlx5 and ib_sr=
p.

=46rom infiniband side:
=E2=9E=9C  linux-rdma git:(queue-next) git log v4.10-rc4...v4.10-rc7 -- dri=
vers/inifiniband |wc
      0       0       0

=46rom eth nothing suspicious too:
=E2=9E=9C  linux-rdma git:(queue-next) git l v4.10-rc4...v4.10-rc7 -- drive=
rs/net/ethernet/mellanox/mlx5
d15118af2683 net/mlx5e: Check ets capability before ets query FW command
a100ff3eef19 net/mlx5e: Fix update of hash function/key via ethtool
1d3398facd08 net/mlx5e: Modify TIRs hash only when it's needed
3e621b19b0bb net/mlx5e: Support TC encapsulation offloads with upper devices
5bae8c031053 net/mlx5: E-Switch, Re-enable RoCE on mode change only after F=
DB destroy
5403dc703ff2 net/mlx5: E-Switch, Err when retrieving steering name-space fa=
ils
eff596da4878 net/mlx5: Return EOPNOTSUPP when failing to get steering name-=
space
9eb7892351a3 net/mlx5: Change ENOTSUPP to EOPNOTSUPP
e048fc50d7bd net/mlx5e: Do not recycle pages from emergency reserve
ad05df399f33 net/mlx5e: Remove unused variable
639e9e94160e net/mlx5e: Remove unnecessary checks when setting num channels
abeffce90c7f net/mlx5e: Fix a -Wmaybe-uninitialized warning


>
> Thanks
> Laurence

--WOTjKnJ88wpJKlWH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlihv/MACgkQ5GN7iDZy
WKcI1Q/9FjQhJyB51xbmkAF3xvQ/FlCA5rA7Vq1cGPNGTMPAmkUF4m6vRuqYrSs1
1vyr9RtWommQ2O7EnkZ9kEdNdqeXV0owJ1IG/9K/RGxVgNHa3JSgMCWPRbQ+xIIT
yw2oRYD3a1/1eBV/QpxvcLU9/2NLpNpRT6I0LOssOpCOEBPCAM4KkYhRS5vcEg82
WYUn2iJX5og/IK+fFX8qL2V3SfyjnGQN+CHXBRRlqNRjv0zXZ4lRyuCLOSngqgG9
LQU3KUJmXsfc3iCl2YMWoorclixwROmVcp/LDb+Q6yjL5Nqm5RU+WF4ge7xpbxgR
lK9FqvbDV4d6SGjF04Drim5npGz0IPU3kphyEwP9kvQIYkd08/CmqWWNA1CuJzRV
pa+jZXnVMut0ajhlEz1m1lmkDbfkcrnYY/84wZYCZ6FPTu9PlFGRIxz/Jl+EJDkX
6/CWFynH02wuR9Auf/PhEtESVaoQit1mFdVsXrTpnybZyUHK3wK/2phIB1NuC6di
5Fs7j2LMkyc6fmBBdtYBe5cqHoeLwEs+YElHVnFyj1qkdyMa3WqAMD946u62VFsP
kGEV7wT/nRz5/ScQDxO1sePA/mK0srMWvNsEWiVbdYBQuEOYxI9vR7O6PfF3mu+H
TzDzK89CPporuNru18BGHKdwbZhcJL92KmTXRgl8I7J3JMOo5z4=
=RzIn
-----END PGP SIGNATURE-----

--WOTjKnJ88wpJKlWH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
