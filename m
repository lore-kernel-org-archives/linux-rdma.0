From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core rpm for SuSE
Date: Thu, 3 Aug 2017 17:59:31 +0200
Message-ID: <66a7dd28-f752-b8d9-e8c2-00128245ce2c@suse.de>
References: <CO2PR07MB25846E91BD9DA1744AEB20BBF8B10@CO2PR07MB2584.namprd07.prod.outlook.com>
 <20170803113505.GF4333@linux-x5ow.site> <1501775351.2922.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501775351.2922.5.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 03/08/2017 à 17:49, Bart Van Assche a écrit :
> On Thu, 2017-08-03 at 13:35 +0200, Johannes Thumshirn wrote:
>> On Thu, Aug 03, 2017 at 11:12:18AM +0000, Amrani, Ram wrote:
>>> Hi Jason,
>>> I see folders with rpm creating scripts for Debian and Red Hat.
>>> How is a SuSE rpm generated?
>> Please have a look at:
>> https://build.opensuse.org/package/show/science:HPC/rdma-core
> Hello Johannes,
>
> Sorry but my opinion is that users should not have to rely on out-of-tree
> patches to build an rdma-core RPM for SuSE systems. BTW, the script that I
> use myself to build a SuSE rdma-core RPM is as follows:
>
>
> #!/bin/bash
>
> rpmtopdir=$PWD/rpmbuilddir
> name=rdma-core
> version=$(sed -n 's/^Version:[[:blank:]]*//p' rdma-core.spec) &&
>     rm -rf "${rpmtopdir}" &&
>     mkdir -p "${rpmtopdir}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
>     git archive --prefix "rdma-core-${version}/" --output "${rpmtopdir}/SOURCES/${name}-${version}.tgz" HEAD &&
>     rpmbuild --define="%_topdir ${rpmtopdir}" -ba ${name}.spec
>
>
> Bart.

Agreed.
We have a different spec file due to SUSE packaging policies, and some path differences but the default one works.
As this is new, I wanted to make sure it works well before submitting it.
With v15 coming out and the associated systemd/udev changes, I'll have to update the spec and validate it but once this is done I'll send a patch to this ML and get it upstreamed.

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
