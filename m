From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: WARNING: ODEBUG bug in process_one_req
Date: Thu, 22 Mar 2018 16:29:00 +0200
Message-ID: <20180322142900.GD19440@mtr-leonro.local>
References: <94eb2c0bc3aa8b2432056623c735@google.com>
 <20180322124823.GB19440@mtr-leonro.local>
 <CACT4Y+Ya8iMgV=7YGgsO2XnusF9tnGcHHPF5U5oNjQz_eJ+vMw@mail.gmail.com>
 <20180322132031.GC19440@mtr-leonro.local>
 <CACT4Y+a2KB6vvgFcqkq7cMCiCZQEFNxsCTgP+_gtgju8H2q9hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HtrkgkD3uBADSQLK"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+a2KB6vvgFcqkq7cMCiCZQEFNxsCTgP+_gtgju8H2q9hQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+3b4acab09b6463472d0a@syzkaller.appspotmail.com>, danielj@mellanox.com, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, monis@mellanox.com, Paolo Abeni <pabeni@redhat.com>, parav@mellanox.com, Roland Dreier <roland@purestorage.com>, syzkaller-bugs@googlegroups.com, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org


--HtrkgkD3uBADSQLK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2018 at 02:36:55PM +0100, Dmitry Vyukov wrote:
> On Thu, Mar 22, 2018 at 2:20 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
> > On Thu, Mar 22, 2018 at 02:10:21PM +0100, Dmitry Vyukov wrote:
> >> This bug is actively happening several times per day, if such bug is
> >> closed syzbot will open another bug on the next crash.
> >> This bug has a reproducer, why do you think it is invalid?
> >
> > I tried to reproduce it on latest rdma-next and failed, so wanted to
> > start from clean page and see if it is still relevant.
>
> Ah,  I see.
> You can now see the current status on dashboard:
> https://syzkaller.appspot.com/bug?id=d4ac7bfeafac8a3d6d06123e078462ac765415e7
> Yes, it still happens.
>
> syzbot has already reported another incarnation of this bug, you can
> see the link to dashboard in the email:
> https://syzkaller.appspot.com/bug?extid=b8d5eb964e412cfd2678
> and it contains a link to the first version with reproducer.
>
> > Does it still reproduce on latest rdma-next?
>
> syzbot does not test rdma-next.
>
> But can you reproduce it on upstream tree where syzbot hits it? Just
> to make sure, you have ODEBUG enabled, right?

Thanks for the tip, I added more debug options and returned to try the
repro on clean v4.16-rc1, it looks like I still don't have all needed
config options (SELinux).

  mount(selinuxfs) failed (errno 2)

Can you please cancel my email that closes this bug?

Thanks

--HtrkgkD3uBADSQLK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqzvawACgkQ5GN7iDZy
WKccUA/+LbBHJ0iMv/ogS7qC2Lc8Uflh7l/he/6nRHkQMoRtZzdTQyuY38tOrHtN
YKQH+TyA6wgmH7WVGMJG1qkHCo878i7RX4JyDBKzSgAabL2WGsG1f5ZBxp5u3DSE
sWws0IxRCRVde4VYhiBj+Az/WbtTXzz4vmua0q5dGNrIHGftReOu5nojw+hFCX4P
KPT7EOFSE7na7n9Qv1TJEuLFzu5fZiFXAS5aVIjJ+7axJwJ7gAArNML//lLW9d01
YJyM1eEXRWEAfKBJZEYylGEJTKG4jlzPJJdbPtTeVCERApDLUX9G0QG7vDqSHT+r
XEfS44e9XbrNjL6iyZYIU7CBukewKXxxHGLiWptOkAzOue/d5SGXRFryDea6JnZP
nYPV+xKwWD+tevax4WxjEKSe82s6hwyqou+Gs2Iv0YQUagjul7Weep/DGFryiir/
meGv/AxN5mbn2KNtKHwh7cZQkTKb7I5TnhW/bIR18RIN2gj6f6SQZsz+jMohI5Yn
pAqZtP54XjxBhBHybdOXJOP5eu7pOOP5IcHVjozENhhywliLZayGtWTv8D+N0PbJ
VQ3z9w3YfmadHyub/DLYP4b56m45Uf5xsnG4FkezMWL9ugou0wAi2DXdTWLWkRua
EzwC9RrP577dwCykxq1P/iGw3nk9GD+7wtHNeNVMAOsMP3w/728=
=sXbH
-----END PGP SIGNATURE-----

--HtrkgkD3uBADSQLK--
