From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: Avoid crash on pkey enforcement failed in
 received MADs
Date: Fri, 3 Nov 2017 22:21:36 +0200
Message-ID: <20171103202136.GJ16127@mtr-leonro.local>
References: <1509463998-49670-1-git-send-email-parav@mellanox.com>
 <VI1PR0502MB3008E61E5EBFA422FAF52674D15D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gPVs24VLDFKgHP1I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB3008E61E5EBFA422FAF52674D15D0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gPVs24VLDFKgHP1I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 03, 2017 at 03:46:40PM +0000, Parav Pandit wrote:
> Hi Leon/Doug,
>
> > -----Original Message-----
> > From: Parav Pandit [mailto:parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> > Sent: Tuesday, October 31, 2017 10:33 AM
> > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Daniel Jurgens
> > <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Subject: [PATCH] IB/core: Avoid crash on pkey enforcement failed in received
> > MADs
> >
> > Below kernel crash is observed when Pkey security enforcement fails on
> > received MADs. This issue is reported in [1].
> >
> > ib_free_recv_mad() accesses the rmpp_list, whose initialization is needed before
> > accessing it.
> > When security enformcent fails on received MADs, MAD processing avoided due
> > to security checks failed.
> >
> > OpenSM[3770]: SM port is down
> > kernel: BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000008
> > kernel: IP: ib_free_recv_mad+0x44/0xa0 [ib_core]
> > kernel: PGD 0
> > kernel: P4D 0
> > kernel:
> > kernel: Oops: 0002 [#1] SMP
> > kernel: CPU: 0 PID: 2833 Comm: kworker/0:1H Tainted: P          IO    4.13.4-1-pve
> > #1
> > kernel: Hardware name: Dell       XS23-TY3        /9CMP63, BIOS 1.71 09/17/2013
> > kernel: Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > kernel: task: ffffa069c6541600 task.stack: ffffb9a729054000
> > kernel: RIP: 0010:ib_free_recv_mad+0x44/0xa0 [ib_core]
> > kernel: RSP: 0018:ffffb9a729057d38 EFLAGS: 00010286
> > kernel: RAX: ffffa069cb138a48 RBX: ffffa069cb138a10 RCX: 0000000000000000
> > kernel: RDX: ffffb9a729057d38 RSI: 0000000000000000 RDI: ffffa069cb138a20
> > kernel: RBP: ffffb9a729057d60 R08: ffffa072d2d49800 R09: ffffa069cb138ae0
> > kernel: R10: ffffa069cb138ae0 R11: ffffa072b3994e00 R12: ffffb9a729057d38
> > kernel: R13: ffffa069d1c90000 R14: 0000000000000000 R15: ffffa069d1c90880
> > kernel: FS:  0000000000000000(0000) GS:ffffa069dba00000(0000)
> > knlGS:0000000000000000
> > kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > kernel: CR2: 0000000000000008 CR3: 00000011f51f2000 CR4:
> > 00000000000006f0
> > kernel: Call Trace:
> > kernel:  ib_mad_recv_done+0x5cc/0xb50 [ib_core]
> > kernel:  __ib_process_cq+0x5c/0xb0 [ib_core]
> > kernel:  ib_cq_poll_work+0x20/0x60 [ib_core]
> > kernel:  process_one_work+0x1e9/0x410
> > kernel:  worker_thread+0x4b/0x410
> > kernel:  kthread+0x109/0x140
> > kernel:  ? process_one_work+0x410/0x410
> > kernel:  ? kthread_create_on_node+0x70/0x70
> > kernel:  ? SyS_exit_group+0x14/0x20
> > kernel:  ret_from_fork+0x25/0x30
> > kernel: RIP: ib_free_recv_mad+0x44/0xa0 [ib_core] RSP: ffffb9a729057d38
> > kernel: CR2: 0000000000000008
> >
> > [1] : https://www.spinics.net/lists/linux-rdma/msg56190.html
> >
> > Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reported-by: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
>
> I think this is needed for 4.13+. I missed to CC stable in this patch.
> Shall I resend with Cc: or?

I believe that Doug will add it.

By the way, did you find the root cause of why security check failed and
we entered into that path?

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gPVs24VLDFKgHP1I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln8z88ACgkQ5GN7iDZy
WKdkqw//acaMIlqVT38p5ihSZrj6y1ntBVrNxmnEIHpjkLwFyIYtCI0lYwqrh4gw
u6v4dysYus9rKpgd/5NfYHJ4z/t/1PGfT4rXFxBDsU9Uxf6VEx1/jX5JsrFOMH55
q1/x5KMZ5dYEaBFPByObYIPCNt43fmG+uBcZF4AekekpJueHgl4VmEUtN+dJ+FeN
PWg1YRotRrP82yVz5SWP6QHcnjjqI3TgH0z2jG2i1q7fAFvZRYeckzJ/xrUCJUpt
wQVEo9gZEn+mZO+Zfi3ZYwwrZy+3pYiGOT8iAg4/o8fq21cq8KG7MIZpKdNoBTbP
n67w6gUnmuEAnipfNmvd69qu5xNJ9iMMURcxa2CNHFJjoIkQ8lMZHTXfbusrr9Rb
zbq/5p5SmVo1g/ZEcxIG8lkXmpx69HyUC1EL/g86/eEH4Mp9Pokk00V/1OP1Oory
fzMTr/jmOr5Ns3QPechuz7bfb6lgvexAB2E9pBLei0FvIBb+RGOQbZZtVVDUgy+c
tZCdtivFnEYfRT95ocONv2+XTfzCLFKAvbLu3L9qosmMbRnEQbjtdE34I7tgm/7H
Uk67oBCmvIfMJ1rfn6iQ6GKnmJzdC/gkuqGoSQGIsRbzYq7osHmVYUkqD15tmzWc
lLHi9tfMweW1/LQsenorJ5Kmi9U0L4k03arr/+XwooYqh1JyTcE=
=dahW
-----END PGP SIGNATURE-----

--gPVs24VLDFKgHP1I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
