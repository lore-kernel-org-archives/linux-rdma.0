From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Fix a recently introduced deadlock
Date: Tue, 19 Jan 2016 16:06:13 -0500
Message-ID: <569EA545.5040907@redhat.com>
References: <56866E6A.8040503@sandisk.com>
 <CAAk-MO8KhiEzgackTEouhdzY+bff8o_m+_dtdGavp4Umj2QvsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MxkpNcvD2tRmDhMrX7MLTISMmkdudOfjF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO8KhiEzgackTEouhdzY+bff8o_m+_dtdGavp4Umj2QvsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MxkpNcvD2tRmDhMrX7MLTISMmkdudOfjF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/06/2016 06:35 AM, Erez Shitrit wrote:
> On Fri, Jan 1, 2016 at 2:17 PM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> ib_send_cm_drep() calls cm_enter_timewait() while holding a spinlock
>> that can be locked from inside an interrupt handler. Hence do not
>> enable interrupts inside cm_enter_timewait() if called with interrupts=

>> disabled.
>>
>> This patch fixes e.g. the following deadlock:
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [ INFO: inconsistent lock state ]
>> 4.4.0-rc7+ #1 Tainted: G            E
>> ---------------------------------
>> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>> swapper/8/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>> (&(&cm_id_priv->lock)->rlock){?.+...}, at: [<ffffffffa036eec4>] cm_est=
ablish+0x
>> 74/0x1b0 [ib_cm]
>> {HARDIRQ-ON-W} state was registered at:
>>   [<ffffffff810a3c11>] mark_held_locks+0x71/0x90
>>   [<ffffffff810a3e87>] trace_hardirqs_on_caller+0xa7/0x1c0
>>   [<ffffffff810a3fad>] trace_hardirqs_on+0xd/0x10
>>   [<ffffffff8151c40b>] _raw_spin_unlock_irq+0x2b/0x40
>>   [<ffffffffa036ea8e>] cm_enter_timewait+0xae/0x100 [ib_cm]
>>   [<ffffffffa036ff76>] ib_send_cm_drep+0xb6/0x190 [ib_cm]
>>   [<ffffffffa052ed08>] srp_cm_handler+0x128/0x1a0 [ib_srp]
>>   [<ffffffffa0370340>] cm_process_work+0x20/0xf0 [ib_cm]
>>   [<ffffffffa0371335>] cm_dreq_handler+0x135/0x2c0 [ib_cm]
>>   [<ffffffffa03733c5>] cm_work_handler+0x75/0xd0 [ib_cm]
>>   [<ffffffff8107184d>] process_one_work+0x1bd/0x460
>>   [<ffffffff81073148>] worker_thread+0x118/0x420
>>   [<ffffffff81078454>] kthread+0xe4/0x100
>>   [<ffffffff8151cbbf>] ret_from_fork+0x3f/0x70
>> irq event stamp: 1672286
>> hardirqs last  enabled at (1672283): [<ffffffff81408ec0>] poll_idle+0x=
10/0x80
>> hardirqs last disabled at (1672284): [<ffffffff8151d304>] common_inter=
rupt+0x84/0x89
>> softirqs last  enabled at (1672286): [<ffffffff8105b4dc>] _local_bh_en=
able+0x1c/0x50
>> softirqs last disabled at (1672285): [<ffffffff8105b697>] irq_enter+0x=
47/0x70
>>
>> other info that might help us debug this:
>>  Possible unsafe locking scenario:
>>
>>        CPU0
>>        ----
>>   lock(&(&cm_id_priv->lock)->rlock);
>>   <Interrupt>
>>     lock(&(&cm_id_priv->lock)->rlock);
>>
>>  *** DEADLOCK ***
>>
>> no locks held by swapper/8/0.
>>
>> stack backtrace:
>> CPU: 8 PID: 0 Comm: swapper/8 Tainted: G            E   4.4.0-rc7+ #1
>> Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
>>  ffff88045af5e950 ffff88046e503a88 ffffffff81251c1b 0000000000000007
>>  0000000000000006 0000000000000003 ffff88045af5ddc0 ffff88046e503ad8
>>  ffffffff810a32f4 0000000000000000 0000000000000000 0000000000000001
>> Call Trace:
>>  <IRQ>  [<ffffffff81251c1b>] dump_stack+0x4f/0x74
>>  [<ffffffff810a32f4>] print_usage_bug+0x184/0x190
>>  [<ffffffff810a36e2>] mark_lock_irq+0xf2/0x290
>>  [<ffffffff810a3995>] mark_lock+0x115/0x1b0
>>  [<ffffffff810a3b8c>] mark_irqflags+0x15c/0x170
>>  [<ffffffff810a4fef>] __lock_acquire+0x1ef/0x560
>>  [<ffffffff810a53c2>] lock_acquire+0x62/0x80
>>  [<ffffffff8151bd33>] _raw_spin_lock_irqsave+0x43/0x60
>>  [<ffffffffa036eec4>] cm_establish+0x74/0x1b0 [ib_cm]
>>  [<ffffffffa036f031>] ib_cm_notify+0x31/0x100 [ib_cm]
>>  [<ffffffffa0637f24>] srpt_qp_event+0x54/0xd0 [ib_srpt]
>>  [<ffffffffa0196052>] mlx4_ib_qp_event+0x72/0xc0 [mlx4_ib]
>>  [<ffffffffa00775b9>] mlx4_qp_event+0x69/0xd0 [mlx4_core]
>>  [<ffffffffa006000e>] mlx4_eq_int+0x51e/0xd50 [mlx4_core]
>>  [<ffffffffa006084f>] mlx4_msi_x_interrupt+0xf/0x20 [mlx4_core]
>>  [<ffffffff810b67b0>] handle_irq_event_percpu+0x40/0x110
>>  [<ffffffff810b68bf>] handle_irq_event+0x3f/0x70
>>  [<ffffffff810ba7f9>] handle_edge_irq+0x79/0x120
>>  [<ffffffff81007f3d>] handle_irq+0x5d/0x130
>>  [<ffffffff810071fd>] do_IRQ+0x6d/0x130
>>  [<ffffffff8151d309>] common_interrupt+0x89/0x89
>>  <EOI>  [<ffffffff8140895f>] cpuidle_enter_state+0xcf/0x200
>>  [<ffffffff81408aa2>] cpuidle_enter+0x12/0x20
>>  [<ffffffff810990d6>] call_cpuidle+0x36/0x60
>>  [<ffffffff81099163>] cpuidle_idle_call+0x63/0x110
>>  [<ffffffff8109930a>] cpu_idle_loop+0xfa/0x130
>>  [<ffffffff8109934e>] cpu_startup_entry+0xe/0x10
>>  [<ffffffff8103c443>] start_secondary+0x83/0x90
>>
>> Fixes: commit be4b499323bf ("IB/cm: Do not queue work to a device that=
's going away")
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>=20
> Acked-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

>=20
>> Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/cm.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm=
=2Ec
>> index 0a26dd6..d6d2b35 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -782,11 +782,11 @@ static void cm_enter_timewait(struct cm_id_priva=
te *cm_id_priv)
>>         wait_time =3D cm_convert_to_ms(cm_id_priv->av.timeout);
>>
>>         /* Check if the device started its remove_one */
>> -       spin_lock_irq(&cm.lock);
>> +       spin_lock_irqsave(&cm.lock, flags);
>>         if (!cm_dev->going_down)
>>                 queue_delayed_work(cm.wq, &cm_id_priv->timewait_info->=
work.work,
>>                                    msecs_to_jiffies(wait_time));
>> -       spin_unlock_irq(&cm.lock);
>> +       spin_unlock_irqrestore(&cm.lock, flags);
>>
>>         cm_id_priv->timewait_info =3D NULL;
>>  }
>> --
>> 2.1.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MxkpNcvD2tRmDhMrX7MLTISMmkdudOfjF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqVFAAoJELgmozMOVy/djBsP/iHXnFPlOCwoZVeZuJxrZqCl
0QFoHrgjO4BGUzcMdksLDTMh3AdCbvtbbuyemozixE6gdSrXChk1gL4wzqoXCV82
YLkrjw7CRcatJ7FetLBmFYIMBq7H17cZoHMKFFPqXQSBTKWKa423Z2Bc7QINErxd
Y7or0nC0OgU7Mw3rQ7FCPbXdb86oeIdjMsQbmBjnD+u+6JHDvO2TxrCVsIjqqFPg
wEqFD5RpCzD/FjEfINL1BEo+C3sXhmUlaW02wPGEzXeIvNMpIaxHLdhvNjSfIi6P
eCOtA/HW2jxA5jfHCf+UhsqlRjEgSQqRLHfR9AG+c352X8PQcZ5CL6jUTUZxKSyK
tpyNBkKDDyO1UeCRPzXCjP95FVKCp5ll1KNlvpDx83OsYeHH6d4hSDpfNt90xWu5
CILKuqnRMgeZO+h9gtk2chXcaBPSZtWUuArAeJJHUjlw84vp4VulbMM+ial8foBH
N/LlN05bhLuN9S1Cs5rtXA6TYTcijFNCfMSuOwReNVXqCcMl4VC6O5eJABPmv2lC
Gwwm0S8GrNXnxRaZnxp/rrprl1YTUNjJXsy/Rmper6NZIfndxpDRu8pV7yO42PXp
sDg62KT65Rbk6XxP+21y8ONyi+3zpgGPVs1pSY8QYQfhE4yUd/e2H25HDbdUNTHx
tSxvRW0Nxhfl/ceR8UsC
=opVW
-----END PGP SIGNATURE-----

--MxkpNcvD2tRmDhMrX7MLTISMmkdudOfjF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
