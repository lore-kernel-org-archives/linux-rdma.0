From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Thu, 08 Aug 2013 21:24:16 +0200
Message-ID: <1375989856.27609.10.camel@localhost.localdomain>
References: <cover.1369085762.git.ydroneaud@opteya.com>
	<0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
	<20130521205713.GB11318@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130521205713.GB11318-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 21 mai 2013 =C3=A0 14:57 -0600, Jason Gunthorpe a =C3=A9crit :
> On Mon, May 20, 2013 at 11:43:05PM +0200, Yann Droneaud wrote:
> > libibverbs must refuse to load arbitrary shared objects.
> >=20
> > This patch check the configuration directory and files for
> > - being owned by root;
> > - not being writable by others.
>=20
> I really don't like this. Is there some exploit against /etc/ now tha=
t
> requires this sort of checking?
>=20

Loading shared object as part of a setuid binary should be handled with
extra care.
Adding checks to the configuration loader is required so that only
trusted shared object get loaded.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
