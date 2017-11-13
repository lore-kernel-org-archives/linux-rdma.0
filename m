From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 12:44:51 +0100
Message-ID: <7569c13e-915f-a266-0d66-0a776079223d@suse.de>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
 <20171113081455.GD18825@mtr-leonro.local>
 <cb56c548-4962-58be-d293-5b4169c24b2e@suse.de>
 <20171113104146.GG18825@mtr-leonro.local>
 <838fb26a-363e-9874-728c-76e614943e56@suse.de>
 <20171113114300.GJ18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113114300.GJ18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 12:43, Leon Romanovsky a écrit :
> On Mon, Nov 13, 2017 at 11:56:19AM +0100, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 13/11/2017 à 11:41, Leon Romanovsky a écrit :
>>
>>>> I'm OK with keeping just the ML for the moment. If it becomes too much of a mess, I'll come back with my github request (or something else).
>>>> How do you suggest flagging me for those patches ? Should we follow the kernel stable process ?
>>> I think so, the kernel process works, we just need to adapt it to rdma-core.
>>> Regarding the flagging procedure, we can do like Greg and Sasha do.
>>>
>>> Open email account (e.g. stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org), connect it to /dev/null,
>>> so people won't get bounce emails while they sent patches to it, and
>>> once a week or two run script [1], which will check master branch and
>>> cherry-pick patches with Cc: stable@ in their commit messages.
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/sashal/stable-tools.git/tree/
>> Sounds fine to me.
> Need to document that.
> BTW: I opened stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org email, if you want I can forward all
> emails from that account to you, right now, everything goes to /dev/null.
>
> Thanks
>
>

Yes you can forward them to me.
I need to prepare a patch with Arlin proposal and this stuff too.

Thanks

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
