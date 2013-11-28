From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: Re: non-const pointer void * addr in rdma_reg_* and
 rdma_post_[send|write]
Date: Thu, 28 Nov 2013 10:23:10 +0100
Message-ID: <1385630590.21498.14.camel@localhost.localdomain>
References: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 27 novembre 2013 =C3=A0 19:00 +0100, Hannes Weisbach a =C3=A9=
crit :

> I just started working with librdmacm and I was wondering if there is=
 a specific reason why rdma_reg_* functions and rdma_post_send/write fu=
nctions take the local memory address as non-const pointer "void * addr=
". These functions shouldn't and don't change the memory pointed to by =
addr. I think this should be made explicit by using the type const void=
 * for addr.
> In case you agree, I would volunteer to make the necessary changes.
>=20

:)

Two days ago I started to work on a kernel patchset to address similar
concerns on the verbs/RDMA APIs

BTW, it's easier to change the kernel "internal" API than the public
userspace API of the library. But adding "const" should not break
compilation of existing userspace program.

PS: this issue could also be raised against libibverbs, so once you've
fixed librdmacm, why not fix libibverbs after ?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
