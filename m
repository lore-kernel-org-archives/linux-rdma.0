From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 9/13/2016 at 11:00PDT
Date: Wed, 14 Sep 2016 11:17:25 +0000
Message-ID: <VI1PR0501MB2189509626B9CC0AB3397D34B1F10@VI1PR0501MB2189.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Liran Liss
> Sent: Monday, September 12, 2016 6:05 PM

> Agenda items:
> - Repositories
> - Code submission and mailing lists
> - Release process
> - Schedules
> - Other?
>=20

Meeting notes:
- There is a general agreement to consolidate rdma user-space components in=
to a single repo.
- In addition to shared libraries and provides, it seems that tools like sr=
p-tools should also be included. Ibdiagnet may also be considered, but Open=
SM does not seem to be suitable.
- Source should include all providers and libraries and all components are =
built
- Security patches should be applied immediately on master branch. No need =
to release with specific tag. Distros may cherry-pick such patches.
- Code submission options for co-maintainers:
-- Ack patches on mailing list, and core maintainer team would apply direct=
ly
-- Apply patches on local clone, send pull request
-- Direct right access
* Selected option depends on patch volume and maintainer preference.
- Releases will be synchronized with kernel schedules
-- Latest tree will be released with no delays
- Future work will include:
-- Travis CI integration
-- Open build systems
-- Distro backporting as a community effort
- Project will be hosted on github.com/linux-rdma organization
-- Doug Ledford was accepted to be the main project maintainer
-- Core services will be supported by maintainer teams to ensure continuous=
 progress and availability
--- Doug/Yishai will be responsible for libibverbs
--- Sean/TBD will be responsible for librdmacm
--- Jason/TBD will be responsible for the build system
- The intention is to conduct the first release with Linux-4.9
-- We need to target starting the process towards the beginning of the near=
est merge window (2-3 weeks)
-- Doug to advertise when the project git it ready
-- Jason to synchronize initial repo and complete integration gaps
-- Doug/Leon/Jason to workout component repos
-- Afterwards, all patches should go into the project main/component git re=
pos


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
