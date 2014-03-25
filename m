From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for v3.14 0/5] Coccicheck / coccinelle catched errors on
 ib/hw
Date: Tue, 25 Mar 2014 14:15:55 +0100
Message-ID: <1395753355.2895.12.camel@localhost.localdomain>
References: <cover.1394485254.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1394485254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Le lundi 10 mars 2014 =C3=A0 23:06 +0100, Yann Droneaud a =C3=A9crit :

> Please find small but important fixes on InfiniBand/iWARP RDMA driver=
s for
> problems found while using coccinelle (spatch) or coccicheck.
>=20

Thanks for applying those patches in your for-next branch.

You haven't made any comment on the patches but I've found you have
redacted a bit my commit messages. In particular, it seems that somes
"Cc:" were removed. I'm primary concerned about removal of Cc:
stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on one patch.

3 patches were cleared from some Cc:

- [PATCH for v3.14 1/5] IB/ehca: returns an error on ib_copy_to_udata()
failure

The patch as I proposed it:

http://marc.info/?i=3Da74f09417f54a40f12475b65b29094173424ff8d.13944852=
54.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

The patch in your tree:

https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/comm=
it/?h=3Dfor-next&id=3Ddea2494d6901d376b8d10d297de23021fbfc3be7

=46ollowing Cc: were removed:

Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Cc: cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org

- [PATCH for v3.14 2/5] IB/mthca: returns an error on ib_copy_to_udata(=
)
failure

http://marc.info/?i=3D014a0e999228bcbefd32667b341a0fc91a8cd3c9.13944852=
54.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/comm=
it/?h=3Dfor-next&id=3D13ef5c07e649b49519e7dec5896c8772a6eb5a76

=46ollowing CC: were removed

Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Cc: cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Here removing stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org doesn't sound right.

- [PATCH for v3.14 3/5] IB/nes: returns an error on ib_copy_from_udata(=
)
failure instead of NULL

http://marc.info/?i=3D69b8f22f0d52b1c1f97b0af2b5bcecbe14cb1da2.13944852=
54.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/comm=
it/?h=3Dfor-next&id=3D9d194d1025f463392feafa26ff8c2d8247f71be1

=46ollowing Cc: were removed:

Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tatyana E. Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Cc: cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org

Could you help me to understand the reason why your selectively remove
some 'Cc:' on some patches while leaving them on other patches.

BTW, I would like to be able to help you by providing 'correct' patches
you could apply without requiring too much work from you.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
