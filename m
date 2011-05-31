From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] read_config: don't try to open file beginning with
 '.'
Date: Tue, 31 May 2011 23:23:12 +0200
Message-ID: <1306876992.4475.11.camel@dworkin.quest-ce.net>
References: <cover.1301562707.git.ydroneaud@opteya.com>
	 <aa79e6cff5121994d60fb10315ce54e5a2dc63af.1301562707.git.ydroneaud@opteya.com>
	 <BANLkTimPvmNzOHn8JRkmu=iBU88nNEq9_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimPvmNzOHn8JRkmu=iBU88nNEq9_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 31 mai 2011 =C3=A0 11:42 -0700, Roland Dreier a =C3=A9crit :
> On Thu, Mar 31, 2011 at 2:29 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
 wrote:
> > Files beginning with a dot are mostly current and parent directorie=
s or,
> > by convention, hidden files.
> >
> > Those path are skipped in find_sysfs_dev().
>=20
> Not sure we want to do this. We already skip non-regular files, and
> I'm not sure we want to exclude certain file names.

=46or example, while testing libibverbs config parsing, I've used emacs=
 to
edit drivers file. And, when emacs open a buffer, it create a lock file
with a leading dot.

So running a libibverbs program prints
libibverbs: Warning: couldn't stat config file
'/tmp/ib/etc/libibverbs.d/.#test'.

Here's a strace output:

open("/tmp/ib/etc/libibverbs.d", O_RDONLY|O_NONBLOCK|O_DIRECTORY|
O_CLOEXEC) =3D 3
getdents(3, /* 3 entries */, 32768)     =3D 80
stat("/tmp/ib/etc/libibverbs.d/.#test", 0x7fffe11e8c60) =3D -1 ENOENT (=
No
such file or directory)
write(2, "libibverbs: Warning: couldn't st"..., 82) =3D 82
stat("/tmp/ib/etc/libibverbs.d/.", {st_mode=3DS_IFDIR|0775,
st_size=3D4096, ...}) =3D 0
stat("/tmp/ib/etc/libibverbs.d/..", {st_mode=3DS_IFDIR|0775,
st_size=3D4096, ...}) =3D 0
getdents(3, /* 0 entries */, 32768)     =3D 0
close(3)                                =3D 0


Skipping that "normally" hidden file seems a good behavior. Same thing
for those backup files with ~ suffix.

It's mostly harmless, but code which load dynamic modules makes me a
little angry :)

=46or example, directory libibverbs.d should be owned by root with writ=
e
limited write permission, likewise for the driver files.

Regards.

--=20
Yann Droneaud


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
