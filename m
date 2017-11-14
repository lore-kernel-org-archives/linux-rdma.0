From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Tue, 14 Nov 2017 11:27:40 +0100
Message-ID: <ab4f8a20-8b32-ff5d-cf82-97e69a660cce@suse.de>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local> <20171110211448.GF17451@ziepe.ca>
 <1eba9063-80a4-ad9d-4adf-93770b9ed7c9@suse.de>
 <20171113070856.GZ18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113070856.GZ18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 08:08, Leon Romanovsky a écrit :
> On Mon, Nov 13, 2017 at 08:01:48AM +0100, Nicolas Morey-Chaisemartin wrote: >> >> >> Le 10/11/2017 à 22:14, Jason Gunthorpe a écrit : >>> On Fri, Nov 10, 2017 at 10:24:55PM +0200, Leon Romanovsky wrote: >>>> More or less, you wrote everything that I expected, just need to post it >>>> as a patch so I can apply it to rdma-core. >>> Also please describe how to get patches into -stable, eg similar to >>> the kernel, mark with fixes and cc the stable maintainer. >>> >>> There should also be absolutely no ABI changes in the -stable branchs. >> >> Agreed. Ideally we would add something to CI so that it detects ABI breake on stable branches. >> I know SUSE has something like this for maintenance fixes. I'll look into it. > > DPDK runs ABI compliance checker. > http://ispras.linuxbase.org/index.
 php/ABI_compliance_checker > > I would love to see it running for rdma-core. > > Thanks >
Got the scripts ready for this BUT the versions available in docker of abi-dump/abi-compliance-checker are not compatible.
As both are GPLv2, could I import them into buildlib ?

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
