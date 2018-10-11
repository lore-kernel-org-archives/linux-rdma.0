From: Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING: ODEBUG bug in free_task
Date: Thu, 11 Oct 2018 21:05:41 +0300
Message-ID: <20181011180541.GF3742@mtr-leonro.mtl.com>
References: <00000000000053a2ca0577ceddac@google.com>
 <CACT4Y+adu4sL96Dp7_m4=Q7bP0eL1w8zVce-2-+FZMAut+E9SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+adu4sL96Dp7_m4=Q7bP0eL1w8zVce-2-+FZMAut+E9SA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+71aff6ea121ffefc280f@syzkaller.appspotmail.com>, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, swise@opengridcomputing.com, markb@mellanox.com, linux-rdma@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, guro@fb.com, Kees Cook <keescook@chromium.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Marcos Souza <marcos.souza.org@gmail.com>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Will Drewry <wad@chromium.org>
List-Id: linux-rdma@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 10, 2018 at 02:59:38PM +0200, Dmitry Vyukov wrote:
> On Tue, Oct 9, 2018 at 7:14 PM, syzbot
> <syzbot+71aff6ea121ffefc280f@syzkaller.appspotmail.com> wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    ae16eea39a86 Add linux-next specific files for 20181008
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16a493b9400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=42525ce985d1a955
> > dashboard link: https://syzkaller.appspot.com/bug?extid=71aff6ea121ffefc280f
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14567ae6400000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14baa25e400000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+71aff6ea121ffefc280f@syzkaller.appspotmail.com
>
> This looks the same as:
>
> #syz dup: WARNING in __put_task_struct (2)
>
> The reproducer is all RDMA and also some task refcounting bug.
>
> +RDMA maintainers

Thanks, amazing reproducer, I'm looking on it now.

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbv5D1AAoJEORje4g2clinXSwP/3Zd/LWbjl2qpGicCpInFJJm
/qOpJDdBS7br18078JB52ODnHfE8DoHew6tUKIabIYbUsjlU3QSzCMDTLm1GMTyw
CTp9dZURJv/DGlmsRbRrIKtwpgX/KPbBPXtz+D1Y/dIAIXkxjrTIgoRFz0VjbEpO
FRC4RVGVqYfEDXEYkH3JKtyLXud3DLFzJNpyen4Y9zEPvY/vC5+TteMW397VYb+u
NkARS5L9AJ4UB09mJySvZqsS/DFEM6rwvLfi9xxRnpgA7/IGxq1ztzyqTrTp+J0K
3PmGspA9cI4hQESFc/iASyiD6ccqcgY0nEeyNICZuOAa3XqdSEhHo+DR86E6Cmm2
iKf++F11y2aWLKBsOUxTAGrZ21g9V/FxD36wRXfDatlIsJtbNsRsFf3L67zsJO1C
wNxKeKTIg/tCqcBXPGIAVzl9/kg0Pm5Je+mPBKQiqhUEU1cqASyiSf+spGP0IRry
H0R3hhVlBYiC0cdjuVAmOVpUjbnifxVfkjxDkHT17/Dvl0HqzPEsjLBcMAocMPL1
O9GfRo8ivzHQEQ0qx07F13dCyqc0ZsvTdWvOqmNgEaSx2pWjVLmjS2U8X6Dmg+Qi
ADzh0YPH6BcBG1qqzOyNSGYvNweaS0HaJrBdliCkXtPrv/PSFbCz+mnujTPU6cuw
f4REEYRO1gqTQGAf00Ai
=ml4y
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
