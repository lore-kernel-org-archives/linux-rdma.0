From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: WARNING: ODEBUG bug in process_one_req
Date: Thu, 22 Mar 2018 17:31:40 +0200
Message-ID: <20180322153140.GP19440@mtr-leonro.local>
References: <94eb2c0bc3aa8b2432056623c735@google.com>
 <20180322124823.GB19440@mtr-leonro.local>
 <CACT4Y+Ya8iMgV=7YGgsO2XnusF9tnGcHHPF5U5oNjQz_eJ+vMw@mail.gmail.com>
 <20180322132031.GC19440@mtr-leonro.local>
 <CACT4Y+a2KB6vvgFcqkq7cMCiCZQEFNxsCTgP+_gtgju8H2q9hQ@mail.gmail.com>
 <20180322142900.GD19440@mtr-leonro.local>
 <CACT4Y+ZEGHp9vg68O7dDfRWj+_bKZQCGQX2AcFckm8GBYaREug@mail.gmail.com>
 <20180322151358.GE19440@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DEZnBEgdqIPZuRMC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180322151358.GE19440@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+3b4acab09b6463472d0a@syzkaller.appspotmail.com>, danielj@mellanox.com, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, monis@mellanox.com, Paolo Abeni <pabeni@redhat.com>, parav@mellanox.com, Roland Dreier <roland@purestorage.com>, syzkaller-bugs@googlegroups.com, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org


--DEZnBEgdqIPZuRMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2018 at 05:13:58PM +0200, Leon Romanovsky wrote:
> On Thu, Mar 22, 2018 at 03:47:41PM +0100, Dmitry Vyukov wrote:
> > On Thu, Mar 22, 2018 at 3:29 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
> > > On Thu, Mar 22, 2018 at 02:36:55PM +0100, Dmitry Vyukov wrote:
> > >> On Thu, Mar 22, 2018 at 2:20 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
> > >> > On Thu, Mar 22, 2018 at 02:10:21PM +0100, Dmitry Vyukov wrote:
> > >> >> This bug is actively happening several times per day, if such bug is
> > >> >> closed syzbot will open another bug on the next crash.
> > >> >> This bug has a reproducer, why do you think it is invalid?
> > >> >
> > >> > I tried to reproduce it on latest rdma-next and failed, so wanted to
> > >> > start from clean page and see if it is still relevant.
> > >>
> > >> Ah,  I see.
> > >> You can now see the current status on dashboard:
> > >> https://syzkaller.appspot.com/bug?id=d4ac7bfeafac8a3d6d06123e078462ac765415e7
> > >> Yes, it still happens.
> > >>
> > >> syzbot has already reported another incarnation of this bug, you can
> > >> see the link to dashboard in the email:
> > >> https://syzkaller.appspot.com/bug?extid=b8d5eb964e412cfd2678
> > >> and it contains a link to the first version with reproducer.
> > >>
> > >> > Does it still reproduce on latest rdma-next?
> > >>
> > >> syzbot does not test rdma-next.
> > >>
> > >> But can you reproduce it on upstream tree where syzbot hits it? Just
> > >> to make sure, you have ODEBUG enabled, right?
> > >
> > > Thanks for the tip, I added more debug options and returned to try the
> > > repro on clean v4.16-rc1, it looks like I still don't have all needed
> > > config options (SELinux).
> > >
> > >   mount(selinuxfs) failed (errno 2)
> >
> >
> > It seems that you have old syzkaller sources, it now explicitly does
> > not fail on ENOENT:
> >
> >     // selinux mount used to be at /selinux, but then moved to /sys/fs/selinux.
> >     const char* selinux_path = "./syz-tmp/newroot/selinux";
> >     if (mount("/selinux", selinux_path, NULL, mount_flags, NULL)) {
> >         if (errno != ENOENT)
> >             fail("mount(/selinux) failed");
> >         if (mount("/sys/fs/selinux", selinux_path, NULL, mount_flags,
> > NULL) && errno != ENOENT)
> >             fail("mount(/sys/fs/selinux) failed");
> >     }
> >
> >
> > > Can you please cancel my email that closes this bug?
> >
> > There is no such option. The new bug is already created:
> > https://syzkaller.appspot.com/bug?id=6ecd3fdba0501c8843300056375abea0880816d2
> > now if we open the old one, we now have 2 for the same root cause. It
> > will lead to mess.
>
> Still no luck, I'll leave this bug for now.

So, except this bug, everything else is fixed.

Thanks

>
> Thanks



--DEZnBEgdqIPZuRMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqzzFwACgkQ5GN7iDZy
WKeP5g//b/HiA2DIE5Gxjlp69N2tpx82adjhR6eKSyvRq+r6mTMFXOdJsb5NytB9
+R5L+8x7bDpL8AMa5abTxNzBgX+CaN1jUSVxRsawpGKcfQRLxoRwhu0WrWEISHsD
0jlzxzJvInhmpsnJzpw6UGfBxYzWaj3TsxB1uMdv9olsPLZhlgmXPBUPhG/Eoexz
JLeLPN+n8cFgOKaBU0xkhK3mHQgm5YO/pZT8rIvOYl7HhdzAOxuqQ0mn/REUA4Dz
PIeiBc6bW+nTHlA9Tt6FH7le7m7TNyjc3iN9Z5YqnP49W2cjmI4OKfEhP1+k78ww
yMfo5J2KNlI1t1mtj5I2PvUeDGyrNzrbA+yz8t2xtIPbH9vMlD/ycFdzptjtq+Z8
PKLdzHoK+uYrDU+xhwP7E1RBt9QI4YfbuRc2Q2sFLsx79JM8uvEv1PLBGTISVY6P
Dd0gcjI0Taa7dr4Yqw4wJzNbzu7KCDEEyXVsFJlwCCuJikgLYiOAgV6CnQl6Mj3N
g/p+2Se/GARhS+FnDyYCDCdJcKBqJMwuj1gDEp9ME9DXZqp0IgcT5qja4lzHNQ/N
RH96ibEBmkdWV35qHorW365mZ2Fti7itJ61ecQFflgOLcrEPxQDADWZyZQRzdKIS
jpzDu2IGV4oZP8D2mmV8fGFtAcHu487bJt+lwBfJljIXaL4mxOA=
=MoRE
-----END PGP SIGNATURE-----

--DEZnBEgdqIPZuRMC--
