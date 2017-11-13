From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 08:53:19 +0100
Message-ID: <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171110202455.GP18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 10/11/2017 à 21:24, Leon Romanovsky a écrit :
> On Fri, Nov 10, 2017 at 06:36:28PM +0000, Davis, Arlin R wrote:
>>> I agree there is a big need for that. Currently reviewing all the patches I haven't
>>> read (only 1000 mails to go...) to see if they need to be backported on top on
>>> rdma-core 15 for the next SLES.
>>> I'd gladly help maintaining this as I'm spending time on it anyway.
>>> I'll leave wiser people debate and ready a doc on how this should be done
>>> though :)
>>>
>>> Nicolas
>> Thanks Nicolas.
>>
>> Ok, I am not sure what details the rdma-core maintainers are looking for in a document. Let me start the discussion with the following:
> More or less, you wrote everything that I expected, just need to post it
> as a patch so I can apply it to rdma-core.
>
> The thing which is important to me is how long that stable will be maintained and how often they will be opened,
> I don't want to see 12 stable branches after 3 years of running rdma-core. It releases every 2-3 months, so theoretically
> we can find ourselves creating stable branches after every release (4 per year).
>
> Thanks
>
>> Stable Branch Release
>>
>> Current Maintainer: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
>>
>> Upstream rdma-core is considered stable after each mainline release. Branched stable releases, off a mainline release, are on as-needed basis and limited to bug fixes. All bug fixes are to be backported from mainline and applied by stable branch maintainer. Branched stable releases will append an additional release number (e.g. 15.1) and will ensure that Travis CI reports a successful build.  Mention the frequency of stable releases or keep it "as is" cadence?
>>
>> See versioning.md for setting package version on a stable branch.
>>
>> Arlin
>>
>>
>>


Resent because Thunderbird screwed up my content.


What would make sense IMHO would be to have people submit their patches to stable branches through a github issues.
Each issue should be tagged in all the main/stable release it is in and contains a SHA1 to a patch from master that contains a fix.

- Allows to have a clear picture of what's broken/what's fixed for each release
- Creating a stable branch becomes easier  (If any distro asks for a stable branch from a couple release ago, just take the bug list apply all the patches and you should be good to go)
- Avoid multiple PR/patches for a patch that needs to be included into multiple stable branches

Concerning how long stable branch will be maintained, it will probably make sense to have some LTS branches and other shorter ones.
Distros branches will probably need to have LTS support (RHEL and SLE have several years of support without ABI breakage that it make sense to do upstream).
Other branches should only last until release N+1 (or N+2) .

This reduces the number of branch to maintain to the "few" distro use and provide fixed version of the latest for every day user that do not want the bleeding edge master.

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
