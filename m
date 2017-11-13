From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 11:56:19 +0100
Message-ID: <838fb26a-363e-9874-728c-76e614943e56@suse.de>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
 <20171113081455.GD18825@mtr-leonro.local>
 <cb56c548-4962-58be-d293-5b4169c24b2e@suse.de>
 <20171113104146.GG18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113104146.GG18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 11:41, Leon Romanovsky a écrit :
> On Mon, Nov 13, 2017 at 10:16:32AM +0100, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 13/11/2017 à 09:14, Leon Romanovsky a écrit :
>>> On Mon, Nov 13, 2017 at 08:53:19AM +0100, Nicolas Morey-Chaisemartin wrote:
>>>> What would make sense IMHO would be to have people submit their patches to stable branches through a github issues.
>>>> Each issue should be tagged in all the main/stable release it is in and contains a SHA1 to a patch from master that contains a fix.
>>>>
>>> I personally against such close integration with github and creating two
>>> different places for communication (ML and github), but as Jason said,
>>> the core team has no plans to manage it and it will be your decision on
>>> how you will manage it.
>>>
>>> Right now, the gihtub issues are disabled in rdma-core, because we
>>> didn't want people open bug reports there instead of posting to the ML.
>>>
>>> Thanks
>>
>> I just saw that on Github. And yes people will open bug for master there.
>> I don't want to intrude in  your workflow..
> Feel free "to intrude", I'm not alone here.

Well from my review of v15, the amount of work at the moment seems very reasonable.
So I dont think there is a need to intrude ... yet !
>
>> I'm OK with keeping just the ML for the moment. If it becomes too much of a mess, I'll come back with my github request (or something else).
>> How do you suggest flagging me for those patches ? Should we follow the kernel stable process ?
> I think so, the kernel process works, we just need to adapt it to rdma-core.
> Regarding the flagging procedure, we can do like Greg and Sasha do.
>
> Open email account (e.g. stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org), connect it to /dev/null,
> so people won't get bounce emails while they sent patches to it, and
> once a week or two run script [1], which will check master branch and
> cherry-pick patches with Cc: stable@ in their commit messages.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/sashal/stable-tools.git/tree/

Sounds fine to me.

>> Meaning either:
>> - CC me with version information on a submission to master
>> - Send a mail to ML + me after patch has been accepted in master with a tag like [PATCH rdma-core stable], a list of patch-id from master, the version they apply to and why they should be picked
>>
>> Do you have any request/idea/suggestion about the release rate of the stable branch ?
> I don't have.

Apart from distros, are there people interested in stable branches ?
If not, we could release simply release around the same time a new main release comes out (N.1 comes out at the same time as N+1.0), and on-demand when a distro requires it.

Nicolas


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
