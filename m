From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-rdma repository url
Date: Wed, 06 May 2015 21:41:33 +0200
Message-ID: <1430941293.25060.8.camel@opteya.com>
References: <EE7902D3F51F404C82415C4803930ACD5DC493FD@CMEXMB1.ad.emulex.com>
	 <1430848060.2407.246.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430848060.2407.246.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Le mardi 05 mai 2015 =C3=A0 13:47 -0400, Doug Ledford a =C3=A9crit :
> On Tue, 2015-05-05 at 07:01 +0000, Devesh Sharma wrote:
> >=20
> > Pardon me if it=E2=80=99s a repeated question for you, what is the =
git url to
> > clone and cut patches for posting on linux-rdma community. Roland u=
sed
> > to maintain it on kernel.org.
>=20
> I added linux-rdma to this email because this is a question I need to
> answer generally.
>=20
> I've been chatting with Linus and while he'll accept pull requests fr=
om
> github repos, because of the open nature of github and therefore the
> lower security, he does prefer kernel.org.  I've filed a ticket with
> kernel.org to get an account, so when they get around to creating it =
and
> giving me repo space there, I'll update the MAINTAINERS file to point=
 to
> that url.  For now, I'll keep using github though.
>=20
> This brings up an issue I wanted to let people know about.  Good git
> hygiene is for a maintainer to never rebase a tree.  This is all well
> and good, but as people have seen by watching Michael's cleanup patch
> set, sometimes a rebase is inevitable.  So, in order to fullfill the
> role of both a maintainer with good git hygiene and the need of
> someplace for people to see forward looking state, I will be maintain=
ing
> *both* the kernel.org and my personal github kernel repos with the
> understanding that nothing will appear in kernel.org until I am
> essentially ready to send the pull request for it (although that's an
> oversimplification, more accurate would be once it lands in kernel.or=
g,
> no further changes to the existing patches will be possible, updates
> will need to be done as incremental patches on top of whatever is the=
re,
> aka fast forward updates only to my branches on kernel.org), and thin=
gs
> will appear in my github repo sooner, but may later change or get
> rebased (although I will try to keep that to a minimum, but sometimes=
 it
> can't be avoided).
>=20
> With that in mind, I've put up a new push of the tree to the current
> github repo (git://github.com/dledford/linux.git).  It has the change=
s I
> have queued for the 4.1-rc cycle.  People can see what I have queued =
up
> by pulling either the for-linus tag, or the k.o-for-4.1-rc branch.
>=20
> I also want to take a minute and let people know that I plan on doing=
 a
> standard for-<version>-rc branch on each release.  I'll create the
> branch once the <version>-rc2 kernel tag is available.  Unless the rc=
2
> tag is unstable, in which case I'll pick another one.  That will be
> where I put any patches for problems found during rc cycles and it wi=
ll
> stay constant with only rdma related fix patches added until the end =
of
> the rc cycle.  So if people want to know when and what kernel to star=
t
> rc phase testing on, that's going to be it on each release.
>=20

And what about linux-next: you should ask for your tree to be added to
the trees Stephen merge into linux-next so that yours get some
visibility to other maintainers and build bots.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
