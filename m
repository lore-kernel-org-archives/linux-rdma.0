From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 08:47:38 +0530
Message-ID: <CANjDDBiaw1VsJXbhNS2VJtpWE7XAx2diP7zXKr-CVViDZyMPGA@mail.gmail.com>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca> <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com> <20171111075704.GS18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171111075704.GS18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Everyone,

Can someone guide me how to initiate a pull of my recent submission to
the stable branch. This is quite urgent.

-Regards
Devesh

On Sat, Nov 11, 2017 at 1:27 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Nov 10, 2017 at 06:36:28PM +0000, Davis, Arlin R wrote:
>> > I agree there is a big need for that. Currently reviewing all the patc=
hes I haven't
>> > read (only 1000 mails to go...) to see if they need to be backported o=
n top on
>> > rdma-core 15 for the next SLES.
>> > I'd gladly help maintaining this as I'm spending time on it anyway.
>> > I'll leave wiser people debate and ready a doc on how this should be d=
one
>> > though :)
>> >
>> > Nicolas
>>
>> Thanks Nicolas.
>>
>> Ok, I am not sure what details the rdma-core maintainers are looking for=
 in a document. Let me start the discussion with the following:
>>
>> Stable Branch Release
>>
>> Current Maintainer: Nicolas Morey-Chaisemartin <NMoreyChaisemartin@suse.=
de>
>>
>> Upstream rdma-core is considered stable after each mainline release. Bra=
nched stable releases, off a mainline release, are on as-needed basis and l=
imited to bug fixes. All bug fixes are to be backported from mainline and a=
pplied by stable branch maintainer. Branched stable releases will append an=
 additional release number (e.g. 15.1) and will ensure that Travis CI repor=
ts a successful build.  Mention the frequency of stable releases or keep it=
 "as is" cadence?
>>
>> See versioning.md for setting package version on a stable branch.
>
>
> Nicolas,
>
> I created new branch "stable-v15" in rdma-core repo [1]. Versioning and
> releasing should be done by tags, see release document [2]. You should
> check in advance that release script [3] creates proper files, and
> double check our CI scripts to ensure they don't filter out that stable
> branch.
>
> Thanks
>
> [1] https://github.com/linux-rdma/rdma-core/tree/stable-v15
> [2] https://github.com/linux-rdma/rdma-core/blob/master/Documentation/rel=
ease.md
> [3] https://github.com/linux-rdma/rdma-core/blob/master/buildlib/github-r=
elease
>
>>
>> Arlin
>>
>>
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
