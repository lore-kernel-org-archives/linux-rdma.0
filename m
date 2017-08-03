From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: rdma-core rpm for SuSE
Date: Thu, 3 Aug 2017 15:49:13 +0000
Message-ID: <1501775351.2922.5.camel@wdc.com>
References: <CO2PR07MB25846E91BD9DA1744AEB20BBF8B10@CO2PR07MB2584.namprd07.prod.outlook.com>
         <20170803113505.GF4333@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803113505.GF4333-qw2SdCWA0PpjqqEj2zc+bA@public.gmane.org>
Content-Language: en-US
Content-ID: <100A82DDD3012B4C894E7897826593A5-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-03 at 13:35 +0200, Johannes Thumshirn wrote:
> On Thu, Aug 03, 2017 at 11:12:18AM +0000, Amrani, Ram wrote:
> > Hi Jason,
> > I see folders with rpm creating scripts for Debian and Red Hat.
> > How is a SuSE rpm generated?
>=20
> Please have a look at:
> https://build.opensuse.org/package/show/science:HPC/rdma-core

Hello Johannes,

Sorry but my opinion is that users should not have to rely on out-of-tree
patches to build an rdma-core RPM for SuSE systems. BTW, the script that I
use myself to build a SuSE rdma-core RPM is as follows:


#!/bin/bash

rpmtopdir=3D$PWD/rpmbuilddir
name=3Drdma-core
version=3D$(sed -n 's/^Version:[[:blank:]]*//p' rdma-core.spec) &&
    rm -rf "${rpmtopdir}" &&
    mkdir -p "${rpmtopdir}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
    git archive --prefix "rdma-core-${version}/" --output "${rpmtopdir}/SOU=
RCES/${name}-${version}.tgz" HEAD &&
    rpmbuild --define=3D"%_topdir ${rpmtopdir}" -ba ${name}.spec


Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
