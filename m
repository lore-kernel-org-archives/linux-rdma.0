From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Thu, 08 Aug 2013 12:12:38 +0200
Message-ID: <1375956758.27609.5.camel@localhost.localdomain>
References: <cover.1369085762.git.ydroneaud@opteya.com>
	<0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
	<CAL1RGDX+XTMmwDQicztdJoq0oE0VfXvg5dhW8k-YEk38-vg6fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDX+XTMmwDQicztdJoq0oE0VfXvg5dhW8k-YEk38-vg6fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 22 mai 2013 =C3=A0 14:32 -0700, Roland Dreier a =C3=A9crit =
:
> On Mon, May 20, 2013 at 2:43 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
 wrote:
> > libibverbs must refuse to load arbitrary shared objects.
> >
> > This patch check the configuration directory and files for
> > - being owned by root;
> > - not being writable by others.
>=20
> uverbs is an unprivileged interface.  Right now I can develop and tes=
t
> libibverbs and driver code as an unprivileged user.  If I'm
> understanding correctly, this patch would break that -- I'd have to
> install to a root-owned directory to test.
>=20

I've missed this use case.
Indeed user should be able to use his own version of libibverbs and
configuration files.

> What's the exploit this protects against?

The configuration mechanism allow loading arbitrary shared object: this
should be done with care when running setuid binaries / running program
as root.

Adding some basic sanity check is welcome to protect from someone
tampering the configuration files.

I'm going to post an updated patchset which will secure (in-depth)
access to configuration files while allowing user to use their own
files.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
