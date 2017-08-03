From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: rdma-core rpm for SuSE
Date: Thu, 3 Aug 2017 19:08:34 +0000
Message-ID: <CO2PR07MB2584296FE34623C0C1386286F8B10@CO2PR07MB2584.namprd07.prod.outlook.com>
References: <CO2PR07MB25846E91BD9DA1744AEB20BBF8B10@CO2PR07MB2584.namprd07.prod.outlook.com>
         <20170803113505.GF4333@linux-x5ow.site> <1501775351.2922.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501775351.2922.5.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, 2017-08-03 at 13:35 +0200, Johannes Thumshirn wrote:
> > On Thu, Aug 03, 2017 at 11:12:18AM +0000, Amrani, Ram wrote:
> > > Hi Jason,
> > > I see folders with rpm creating scripts for Debian and Red Hat.
> > > How is a SuSE rpm generated?
> >
> > Please have a look at:
> > https://build.opensuse.org/package/show/science:HPC/rdma-core
>=20
> Hello Johannes,
>=20
> Sorry but my opinion is that users should not have to rely on out-of-tree
> patches to build an rdma-core RPM for SuSE systems. BTW, the script that =
I
> use myself to build a SuSE rdma-core RPM is as follows:
>=20
>=20
> #!/bin/bash
>=20
> rpmtopdir=3D$PWD/rpmbuilddir
> name=3Drdma-core
> version=3D$(sed -n 's/^Version:[[:blank:]]*//p' rdma-core.spec) &&
>     rm -rf "${rpmtopdir}" &&
>     mkdir -p "${rpmtopdir}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
>     git archive --prefix "rdma-core-${version}/" --output "${rpmtopdir}/S=
OURCES/${name}-${version}.tgz" HEAD &&
>     rpmbuild --define=3D"%_topdir ${rpmtopdir}" -ba ${name}.spec
>=20
>=20
> Bart.

Thanks Johannes and Bart.
We'll try it out.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
