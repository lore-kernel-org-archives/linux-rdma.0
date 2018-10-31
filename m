From: Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING in rds_message_alloc_sgs
Date: Wed, 31 Oct 2018 08:42:20 +0200
Message-ID: <20181031064220.GN3974@mtr-leonro.mtl.com>
References: <0000000000003c6b7b0579772ff3@google.com>
 <a7a834e0-c300-b5b9-67b5-78fa3eba8ebb@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q8BnQc91gJZX4vDc"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a7a834e0-c300-b5b9-67b5-78fa3eba8ebb@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: syzbot <syzbot+26de17458aeda9d305d8@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com, davem@davemloft.net, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Q8BnQc91gJZX4vDc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2018 at 12:38:02PM -0700, Santosh Shilimkar wrote:
> On 10/30/2018 12:28 PM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:=A0=A0=A0 6201f31a39f8 Add linux-next specific files for 20=
181030
> > git tree:=A0=A0=A0=A0=A0=A0 linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1397d06d400=
000
> > kernel config:=A0 https://syzkaller.appspot.com/x/.config?x=3D2a22859d8=
70756c1
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=3D26de17458aeda9d305d8
> > compiler:=A0=A0=A0=A0=A0=A0 gcc (GCC) 8.0.1 20180413 (experimental)
> > syz repro:=A0=A0=A0=A0=A0 https://syzkaller.appspot.com/x/repro.syz?x=
=3D10bb52eb400000
> > C reproducer:=A0=A0 https://syzkaller.appspot.com/x/repro.c?x=3D118bdfc=
5400000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+26de17458aeda9d305d8@syzkaller.appspotmail.com
> >
> > WARNING: CPU: 0 PID: 19789 at net/rds/message.c:316
> > rds_message_alloc_sgs+0x10c/0x160 net/rds/message.c:316
> > Kernel panic - not syncing: panic_on_warn set ...
> Looks like this kernel build has panic on warn enabled which
> triggers panic for " WARN_ON(!nr_pages)" case. Will look into
> it. Thanks !!

Please don't forget to remove user triggered WARN_ON.
https://lwn.net/Articles/769365/
"Greg Kroah-Hartman raised the problem of core kernel API code that will
use WARN_ON_ONCE() to complain about bad usage; that will not generate
the desired result if WARN_ON_ONCE() is configured to crash the machine.
He was told that the code should just call pr_warn() instead, and that
the called function should return an error in such situations. It was
generally agreed that any WARN_ON() or WARN_ON_ONCE() calls that can be
triggered from user space need to be fixed."

Thanks

>
> Regards,
> Santosh

--Q8BnQc91gJZX4vDc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb2U7MAAoJEORje4g2clinySoP/1M2x8wQN60bkPszYgFYoOqD
rouJticqrcknoxCPIzwHEMtzdEMvEnEKD5980BIHank13TJ3MIb9NIhDGZ3N9lVY
Is5x9YJRsKLouY68Ui7VDNsJ0DPYO5ylfvyyp7eSUyf0hGbRZ3axqeoLQFCo2S6e
4VOYlYJlLJ+tEueEyEY/gnD6yaVlYfXijDIZzd/olDxDIx6eGfPg2kscNqDD/M6Z
Js4scqLtMGqsjYn+yR50e8TFVKssLdSDhY7ADl0DDzPiZZHpqRVHRwrGu9XO3O8e
XUNCGBlzqA0O+ltbvgLRIBlQ1fIrBOo0q/qAvp8dPQs/k+VnQe6AzHlLGMaE9DuL
qlS536JxC3f/WsOc+sk7e/zMphiH44crLzZ6LI56PVdCKANdAAN47lOr/HroOh5v
PFEuFUALrOSo4Yl6Xsoc/6L+qdVZDB4JtbrDUvuzmAkTz0cQKSrWH3JN+IYQErzZ
LUHk3Pf1/r81/DxkirokTfHpUSKiruDvaAFs3Q925xxNGUjU5axj8X10c7sQNchD
lkRhT3TIa5KCtOK4m7fW53j24WUe6NtBbym0/bhoC0fX4gekF5bp3AqY0I7WF+w6
gDd/etlAfYlK4yTQbVKWbHTKEmMxBsEFDUJSvsn9HrgeWEZdbfVOV6CfPj0qz5nu
EeprTD0XCeG4M0bWxkNU
=uvwi
-----END PGP SIGNATURE-----

--Q8BnQc91gJZX4vDc--
