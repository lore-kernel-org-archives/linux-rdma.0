From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [rdma:k.o/for-4.11 15/22] include/linux/compiler.h:518:38:
 error: call to '__compiletime_assert_126' declared with attribute error:
 BUILD_BUG_ON failed: !is_power_of_2(RXE_BUF_PER_MAP)
Date: Thu, 12 Jan 2017 17:00:19 +0000
Message-ID: <1484240405.2720.3.camel@sandisk.com>
References: <201701121638.6esoHrp2%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201701121638.6esoHrp2%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <F999A1EC867DBF44A5636685474316C0-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-01-12 at 16:50 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git=
 k.o/for-4.11
> head:   c5540a0195ec65e2ab9fcc4bde958db2cc66550c
> commit: 43553b47c3124e7f4a9f115cff9db513b35a5e0a [15/22] IB/rxe: Issue wa=
rnings once
> config: i386-randconfig-c0-01121610 (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
> reproduce:
>         git checkout 43553b47c3124e7f4a9f115cff9db513b35a5e0a
>         # save the attached .config to linux build tree
>         make ARCH=3Di386=20
>=20
> All error/warnings (new ones prefixed by >>):
>=20
>    In file included from include/uapi/linux/stddef.h:1:0,
>                     from include/linux/stddef.h:4,
>                     from include/uapi/linux/posix_types.h:4,
>                     from include/uapi/linux/types.h:13,
>                     from include/linux/types.h:5,
>                     from include/linux/list.h:4,
>                     from include/linux/module.h:9,
>                     from drivers/infiniband/sw/rxe/rxe.h:42,
>                     from drivers/infiniband/sw/rxe/rxe_mr.c:34:
>    drivers/infiniband/sw/rxe/rxe_mr.c: In function 'rxe_mem_alloc.isra.3'=
:
> > > include/linux/compiler.h:518:38: error: call to '__compiletime_assert=
_126' declared with attribute error: BUILD_BUG_ON failed: !is_power_of_2(RX=
E_BUF_PER_MAP)
>=20
>      _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>                                          ^
>    include/linux/compiler.h:501:4: note: in definition of macro '__compil=
etime_assert'
>        prefix ## suffix();    \
>        ^
>    include/linux/compiler.h:518:2: note: in expansion of macro '_compilet=
ime_assert'
>      _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>      ^
>    include/linux/bug.h:54:37: note: in expansion of macro 'compiletime_as=
sert'
>     #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                         ^
>    include/linux/bug.h:78:2: note: in expansion of macro 'BUILD_BUG_ON_MS=
G'
>      BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>      ^
> > > drivers/infiniband/sw/rxe/rxe_mr.c:126:2: note: in expansion of macro=
 'BUILD_BUG_ON'
>=20
>      BUILD_BUG_ON(!is_power_of_2(RXE_BUF_PER_MAP));
>      ^


Hello Wu,

make ARCH=3Di386 M=3Ddrivers/infiniband/sw/rxe succeeds on my development s=
ystem
with the .config that was attached to your e-mail and with gcc 6.2.1. Do yo=
u
think the above indicate a bug in the kbuild test robot infrastructure?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
