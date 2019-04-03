From: Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING in cma_exit_net
Date: Wed, 3 Apr 2019 08:11:40 +0300
Message-ID: <20190403051140.GU3201@mtr-leonro.mtl.com>
References: <0000000000008096f305857b74d1@google.com>
 <20190401174554.GE6209@ziepe.ca>
 <20190401182923.GK3201@mtr-leonro.mtl.com>
 <1554248352.118779.171.camel@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Er1qpsOqk0l6oMce"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1554248352.118779.171.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, syzbot <syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com>, Matthew Wilcox <willy@infradead.org>, danielj@mellanox.com, danitg@mellanox.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org


--Er1qpsOqk0l6oMce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 02, 2019 at 04:39:12PM -0700, Bart Van Assche wrote:
> On Mon, 2019-04-01 at 21:29 +0300, Leon Romanovsky wrote:
> > On Mon, Apr 01, 2019 at 02:45:54PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Apr 01, 2019 at 10:36:05AM -0700, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    e3ecb83e Add linux-next specific files for 20190401
> > > > git tree:       linux-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13bc36cd200000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=db6c9f2bfeb91a99
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=2e3e485d5697ea610460
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > >
> > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com
> > > >
> > > > WARNING: CPU: 1 PID: 7 at drivers/infiniband/core/cma.c:4674
> > > > cma_exit_net+0x327/0x390 drivers/infiniband/core/cma.c:4674
> > > > Kernel panic - not syncing: panic_on_warn set ...
> > >
> > > Matt: This is why the WARN_ON(!xa_empty()) is so valuable. Magically
> > > syzkaller can find something in this code is buggy.
> > >
> > > Mellanox is also showing a different testing failure over the weekend
> > > (use after free or something) from your 'cma: Convert portspace IDRs
> > > to XArray'
> >
> > This is what I see in my environment.

Bart,

This patch [1] will fix it.

Thanks

[1] https://patchwork.kernel.org/patch/10881501/

--Er1qpsOqk0l6oMce
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcpECMAAoJEORje4g2clintEgP/jLdI1tyuwgfhgxvcSLD6Hmc
1ttA+22EgdcfPA6uj9hwabVFR1SAq846+3CB8HZidyeXaye1v6Dowb5CrqRcZA7u
stIe3TVL7VYYyLPow55kD83Q6JQdhu79R6vnbMBBFBJVmx8CT7D6LviSyD6pIl7n
Vgt3OwhNE6Svt79SzB5i4TbfVEhVvk6IItO1i+FNR88nsDq7nCLtErTM5NU75CUE
ojoGcW2LL1EhUAP4X7hwU9AMa+T6xaiXYIjnu/6WXzy8wf4aeaMvAmBPJVDAb1Fo
WUoAWabW50cuFkNgBiWXQy1JBMKjO/4UJnAZWLeswAAcCziXmOG8VjwAMicFu/BW
U4eV0pRgICCB4cEiScexHPdMAWZuBQeOemjEeXOlLkeCpH2ZXxPXdC4YPcDG063H
j0+87r83GheoaB4oit6ElfDiGpM0VYxT5ECDctLouWrpNq7CT9mhLxdCQ657TXZZ
9eP+RsV0hf1aB2kAgBnxU8pBiQuB0pkUR26xc7JzjhVzyreu9WXvihYjzeVivvk0
vEkPiLO9asgLnab6VBoeysSU9J+3p+4J4a5Dyfssn6PhvClI9c25VQi6th/F5bIg
L9+BzfrvP7sxgUhZFpL0e0ZTu92/ZSZ6BAdd7oVc5dDG1Nq9lkORlBTc3ac9MY+R
GJJgdK8dwmX6FROYR+7r
=mjCq
-----END PGP SIGNATURE-----

--Er1qpsOqk0l6oMce--
