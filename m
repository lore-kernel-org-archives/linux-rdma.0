From: Lukas Razik <linux@razik.name>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Fri, 18 Nov 2011 13:07:53 +0000 (GMT)
Message-ID: <1321621673.76348.YahooMailNeo@web24705.mail.ird.yahoo.com>
References: <20111117.212847.1778246801048496855.davem@davemloft.net> <1321592577.354.YahooMailNeo@web24712.mail.ird.yahoo.com> <20111118.011708.677233058349078554.davem@davemloft.net> <20111118.015519.1069441245022002863.davem@davemloft.net>
Reply-To: Lukas Razik <linux@razik.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20111118.015519.1069441245022002863.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: "roland@purestorage.com" <roland@purestorage.com>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Vladimir Sokolovsky <vlad@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>>  That explains everything.=A0 The problem is that we don't do the sp=
arc64
>>  PTE handling code patching in modules.=A0 So it's left at the defau=
lt 4U
>>  versions.
> ...
>>  I'll work on a fix for this.
>=20
> Ok, please test this out, thanks!
>=20
> --------------------
> [PATCH] sparc64: Patch sun4v code sequences properly on module load.
>=20
> Some of the sun4v code patching occurs in inline functions visible
> to, and usable by, modules.
>=20
> Therefore we have to patch them up during module load.
>=20
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> arch/sparc/kernel/entry.h=A0 =A0 |=A0 =A0 7 ++++++
> arch/sparc/kernel/module.c=A0  |=A0  27 +++++++++++++++++++++++
> arch/sparc/kernel/setup_64.c |=A0  48 +++++++++++++++++++++++++------=
----------
> 3 files changed, 63 insertions(+), 19 deletions(-)
>=20

Hi David,

sorry that it took so long but I had to sleep to avoid mistakes - it wa=
s 6am here.
Thanks again for this fast patch!!!

Your first patch I could apply against linux-2.6.39.4. Your second patc=
h I can't.
I've tried to apply it manually but I've seen too many differences and =
gave up.

Therefore I applied _both_ patches against linux-3.1.1.
Then I've tested ibv_devinfo with the builtin mlx drivers from linux-3.=
1.1 and it seems that the BUG message is away.

But I can't do further testing because I would need the mlx modules fro=
m OFED-1.5.4-rc4 (newest version) which doesn't compile with linux-3.1.=
1:
http://thread.gmane.org/gmane.linux.drivers.rdma/10192

Hence I would need your patch against 2.6.39.4 to say for sure if it wo=
rks now. :-/
Please don't feel forced by me! It would be nice to have a patch but I =
see that you work on many areas needing improvement. Then I must wait f=
or an OFED version that is compatible with linux-3.1.1 ...

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
