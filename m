From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/hfi1: Don't attempt to free resources if
 initialization failed
Date: Thu, 21 Apr 2016 12:40:35 +0300
Message-ID: <20160421094035.GC26951@leon.nu>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
 <20160420130535.28231.36344.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420130535.28231.36344.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 06:05:36AM -0700, Dennis Dalessandro wrote:
> From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Attempting to free resources which have not been allocated and
> initialized properly led to the following kernel backtrace:
>=20
>     BUG: unable to handle kernel NULL pointer dereference at           (n=
ull)
>     IP: [<ffffffffa09658fe>] unlock_exp_tids.isra.8+0x2e/0x120 [hfi1]
>     PGD 852a43067 PUD 85d4a6067 PMD 0
>     Oops: 0000 [#1] SMP
>     CPU: 0 PID: 2831 Comm: osu_bw Tainted: G          IO 3.12.18-wfr+ #1
>     task: ffff88085b15b540 ti: ffff8808588fe000 task.ti: ffff8808588fe000
>     RIP: 0010:[<ffffffffa09658fe>]  [<ffffffffa09658fe>] unlock_exp_tids.=
isra.8+0x2e/0x120 [hfi1]
>     RSP: 0018:ffff8808588ffde0  EFLAGS: 00010282
>     RAX: 0000000000000000 RBX: ffff880858a31800 RCX: 0000000000000000
>     RDX: ffff88085d971bc0 RSI: ffff880858a318f8 RDI: ffff880858a318c0
>     RBP: ffff8808588ffe20 R08: 0000000000000000 R09: 0000000000000000
>     R10: ffff88087ffd6f40 R11: 0000000001100348 R12: ffff880852900000
>     R13: ffff880858a318c0 R14: 0000000000000000 R15: ffff88085d971be8
>     FS:  00007f4674e83740(0000) GS:ffff88087f400000(0000) knlGS:000000000=
0000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 0000000000000000 CR3: 000000085c377000 CR4: 00000000001407f0
>     Stack:
>      ffffffffa0941a71 ffff880858a318f8 ffff88085d971bc0 ffff880858a31800
>      ffff880852900000 ffff880858a31800 00000000003ffff7 ffff88085d971bc0
>      ffff8808588ffe60 ffffffffa09663fc ffff8808588ffe60 ffff880858a31800
>     Call Trace:
>      [<ffffffffa0941a71>] ? find_mmu_handler+0x51/0x70 [hfi1]
>      [<ffffffffa09663fc>] hfi1_user_exp_rcv_free+0x6c/0x120 [hfi1]
>      [<ffffffffa0932809>] hfi1_file_close+0x1a9/0x340 [hfi1]
>      [<ffffffff8116c189>] __fput+0xe9/0x270
>      [<ffffffff8116c35e>] ____fput+0xe/0x10
>      [<ffffffff81065707>] task_work_run+0xa7/0xe0
>      [<ffffffff81002969>] do_notify_resume+0x59/0x80
>      [<ffffffff814ffc1a>] int_signal+0x12/0x17
>=20
> This commit re-arranges the context initialization code in a way that
> would allow for context event flags to be used to determine whether
> the context has been successfully initialized.
>=20
> In turn, this can be used to skip the resource de-allocation if they
> were never allocated in the first place.
>=20
> Fixes: 3abb33ac6521 ("staging/hfi1: Add TID cache receive init and free f=
uncs")
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzUU04JRNCRQjg@public.gmane.org

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGKATAAoJEORje4g2clin4RgQAKbx8SltzRmRBKQpR9tsprNl
VrtSBBGu2+7oj4KUDOT25tKyv1XmLAzzdueP1AVLooEIf8bFEYhWdFp192Q6x8R+
H7hu1XLs4mBNMo5hhYT/DXVDF9OyGnDsJxx+DvBSyUFmz+ptGTrVQegLSlAagZyW
P9Zc7AUNqyVABiVtvBC3WT4Bg5nwNG3ge8iDjB7fJIOu//8kGnTsaxwQC44lU7N/
/VBTIPA4cBrnp53ZiCks2TOpOBIDzX8H2NsRr1IzHnEYKIpit2tCNiQ9Myknh1ES
bKb4NwKuIwe+3LGXhqKWck9klh4xXwGRXfUTCl8HegwnDfHt6MmxouZ8VDDoZQIk
uF8cltQhOsQA8245SIiTJQJppPauSqPZo45WvJwijXxpIzD+4+0unr3O03Ykf7Ga
fBgT7OdYrepIgxqNkRmsGIvVBt48USEt9wws0gnpDg158k6omcAoGN8cpFZLitvZ
XbVr0yUguGzJ+zcUMu6+5R9+47ZPrZo2NSTal72vecYh38uMI5gIK9jJca63lKwP
k+yyYu25zRkaqrznuGBinu/VzFcZWz+JW/28wyhwbDBuek1aIJarE/Kn4MrT86ON
9D+x4XRLTFOLPn5aO5ls6fCzJ6rEiwL7orxjr9+FJf2TzENyyZI4fek7WNbjyy6r
riZkwSa2O2EZRrSZZ0lZ
=pbHk
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
