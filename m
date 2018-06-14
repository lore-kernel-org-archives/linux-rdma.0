From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Thu, 14 Jun 2018 10:01:08 +0300
Message-ID: <20180614070108.GD18426@mtr-leonro.mtl.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com>
 <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2018 at 11:21:54PM -0700, Cong Wang wrote:
> On Wed, Jun 13, 2018 at 10:34 PM, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > Hi Cong,
> >
> > If the compiler optimizes the first line (mutex_lock) as you wrote,
> > it will reuse "f" for the second line (mutex_unlock) too.
>
> Nope, check the assembly if you don't trust me, at least
> my compiler always fetches ctx->file without this patch.
>
> I can show you the assembly code tomorrow (too late to
> access my dev machine now).

I trust you, so don't need to check it however wanted to emphasize
that your solution is compiler specific and not universally true.

>
>
> >
> > You need to ensure that ucma_modify_id() doesn't run in parallel to
> > anything that uses "ctx->file" directly and indirectly.
> >
>
> Talk is easy, show me the code. :) I knew there is probably
> some other race with this code even after my patch, possibly with
> ->close() for example, but for this specific unlock warning, this patch
> is sufficient. I can't solve all the races in one patch.

We do prefer complete solution once the problem is fully understood.

It looks like you are one step away from final patch. It will be conversion
of mutex to be rwlock and separating between read (almost in all places)
and write (in ucma_migrate_id) paths.

Thanks

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbIhK0AAoJEORje4g2clinx5oP/0BVRmUMfmFD+SovKh+/vvi9
fk+FWjWpKcGGgZdEXz44R3L9FEgdl8V+Uwaz6wr9RO87dJ0VDagPYEjvJD6QjfVv
alaDwWU4q+8FKHbUJ66uvKNXKyyDcD1hiaa+dU03oJ6t4oieefotHBtGnhAWfPO8
IsTClsJy3+Kfd902sn4w0ReIcqqTXo6+nhHUEjdCf+JTglIln9qeiDbI/hgZZvw4
Xmsk8aMq3p53s+YE/f2G5XHY9d2viDxN0DOIMTUPHqkWNy8rmYWVKYGKafP/Fl4p
fx71vRVkTmDMGFiyne9iNuiQWGzQBLZaChdKQpurwoIGMUUbJwno9ZA8AUEEFv1D
QIiTt9lo5ZAvirgAOXjDDiU0D1f8FId0WrA5a0UFmsi5UdIgnTv+lWv6EvZjpOn/
1Zb4QYNzTfGqne4NhSdyADYkw+AKCbwpLSwzloU0azwdKrtwavJIqiUGQAaeL7mk
16wNQl+bxBJiGXNMBtYLobc3YudBo3vHsaOB1o4fGhJSxL9jdha0a3i+M9yt7bke
7iBGE3ryzgl1ceKfjIfrA+GPWpBGKmeK2O3OUinIs2xsM3J2P6xi68BbVJm3apZj
1o4yGQkU8K0m/7XA28tLaPoxRoX/9QSTB3/AonM5zUoNhZfPAQgZCaFek9Sq/dx5
PqrswsswWqT/jd3zsTtC
=jfYX
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
