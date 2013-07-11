From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Fix configure regression that disallowed
 building on older systems
Date: Thu, 11 Jul 2013 13:03:50 +0200
Message-ID: <b582a3bf3c6471398d45322cc7f11d34@meuh.org>
References: <1373538859-32636-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373538859-32636-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 11.07.2013 12:34, Or Gerlitz a =C3=A9crit=C2=A0:
> From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Commit 9bbd803 "configure: Apply updates proposed by autoupdate" forc=
ed
> the autoconf package on the builder node to be of version 2.67 or=20
> higher.
>=20
> This doesn't allow to build the library e.g on RHEL 6.x systems
> who install this set of tools
>=20
> 	autofs-5.0.5-39.el6.x86_64
> 	automake-1.11.1-1.2.el6.noarch
> 	autoconf-2.63-5.1.el6.noarch
>=20
> Be a bit more conservative and require 2.63 or higher.
>=20

If the "release" tarball is used, the library should build regardless
of the installed autoconf/automake.

I warned about that when the patch was submitted :)

- http://article.gmane.org/gmane.linux.drivers.rdma/15724

"
It works on Debian 6.0 (Squeeze) and Fedora 17 (Beefy Miracle),
but you might want to test on older systems ... I'm looking at you
Red Hat Enterprise Linux ... But ultimately it depends on the
release manager's host environment which is probably up to date :)
"

> CC: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-By: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>


Regards

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
