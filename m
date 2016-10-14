From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: Introduction of libqedr to the Consolidated Userspace RDMA
 Library Repo
Date: Fri, 14 Oct 2016 12:53:34 +0000
Message-ID: <SN1PR07MB220745646BCC093BCB5A4553F8DF0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22073DF8F016A275DA036F8EF8C70@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161006163427.GG1224@obsidianresearch.com>
 <SN1PR07MB2207B8BA2C9C9A1FC610DE9FF8D90@SN1PR07MB2207.namprd07.prod.outlook.com>
 <SN1PR07MB22074FE9B280DDDCE439FBA9F8DC0@SN1PR07MB2207.namprd07.prod.outlook.com>,<20161013162942.GA5468@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161013162942.GA5468-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>Yes, many of the drivers copied the same stuff that is now gone. Here



>is a sampling
>
>https://github.com/linux-rdma/rdma-core/commit/1df0888f6a736e1612ce8b054d6=
c17651ebd003f
>https://github.com/linux-rdma/rdma-core/commit/6771a2051ea5efd30e142866f72=
2d2dae6f565a7
>https://github.com/linux-rdma/rdma-core/commit/f29b3285f82815da3abdfea5be5=
c4f2d1ca92743
>https://github.com/linux-rdma/rdma-core/commit/9358a8a5484d1caa0c7ad1826e0=
7d2105f58cc4e
>https://github.com/linux-rdma/rdma-core/commit/c5c7e32796b19c3707620a3d2f6=
b32d00d2fbc3c

OK, this is more clear to me now. I'll look up the=A0git log to see if ther=
e are other relevant cleanups.

>You don't need a server, just a personal github account.
Oh, that sounds much simpler. I'll give it a try.
If I follow correctly, I create a github account, clone rdma-plumbing,=A0ad=
d our code onto that
and send you a pull request.


Thanks,
Ram



    =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
