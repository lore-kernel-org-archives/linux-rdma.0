From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] =?UTF-8?Q?read=5Fconfig=3A=20skip=20file/director?=
 =?UTF-8?Q?y=20with=20unsecure=20permissions?=
Date: Mon, 12 Aug 2013 22:24:55 +0200
Message-ID: <8d276f12593ddc79233fa41abdaf0d41@meuh.org>
References: <cover.1369085762.git.ydroneaud@opteya.com>
 <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
 <20130521205713.GB11318@obsidianresearch.com>
 <1375989856.27609.10.camel@localhost.localdomain>
 <20130812190545.GA7968@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130812190545.GA7968-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 12.08.2013 21:05, Jason Gunthorpe a =C3=A9crit=C2=A0:
> On Thu, Aug 08, 2013 at 09:24:16PM +0200, Yann Droneaud wrote:
>>=20
>> Loading shared object as part of a setuid binary should be handled
>> with extra care.  Adding checks to the configuration loader is
>> required so that only trusted shared object get loaded.
>=20
> Well, still, I'm not sure this is required. IBV_CONFIG_DIR is
> hardwired and not overriable (via environment, etc), so it is a simpl=
e
> installation error to have the wrong permissions for your environment
> on these files.
>=20

It's an installation error that can allow an attackant to tamper
the configuration files. Once the configuration files are modified
to load a payload, the attackant can either trick root to execute
a verbs/RDMA program or use a verbs/RDMA setuid program to gain root
access.

libibverbs should protect its users from loading arbitrary shared=20
object/library.


I fixed the code regarding Roland remarks on user's own libibverbs,
so I think there's no more use case were my proposed check would harm.
But I cannot imagine all of them alone, so I need your help to find
some valid use case broken by my proposed checks.

> But lots of files need to have the correct permissions for setuid to
> be secure (the binary, the library itself, the libraries it dlopens,
> the directories that contain all of these things, etc) - not sure it
> makes any sense at all to single out the config files for special
> checking.
>=20

It took a lot of time to fixes those setuid programs and the libraries
used by them. And it still an on-going work.

We don't have to wait for exploit to secure the loading mechanism of=20
libibverbs.

> In any event, if these checks really are necessary they should be onl=
y
> done if running in a setuid context, and they almost certainly need t=
o
> extend to the dlopen paths as well..
>=20

They need to be done when the configuration files are owned by a=20
different user
that the one using the library (eg. running a program tied to the=20
library).

I put the emphasis on setuid use case, but a program run as root using=20
configuration file
owned by another user is more likely to happen (for devel, test=20
purpose).

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
