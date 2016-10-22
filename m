From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: Introduction of libqedr to the Consolidated Userspace RDMA
 Library Repo
Date: Sat, 22 Oct 2016 13:26:51 +0000
Message-ID: <SN1PR07MB2207E025DDE2F38643270AA0F8D70@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22073DF8F016A275DA036F8EF8C70@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161006163427.GG1224@obsidianresearch.com>
 <SN1PR07MB2207B8BA2C9C9A1FC610DE9FF8D90@SN1PR07MB2207.namprd07.prod.outlook.com>
 <SN1PR07MB22074FE9B280DDDCE439FBA9F8DC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161013162942.GA5468@obsidianresearch.com>
 <SN1PR07MB220745646BCC093BCB5A4553F8DF0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161014164229.GB6258@obsidianresearch.com>
 <SN1PR07MB220719CE0C668A321520311DF8D20@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161019172410.GB29879@obsidianresearch.com>
 <SN1PR07MB22076159E666B8836BBB3455F8D50@SN1PR07MB2207.namprd07.prod.outlook.com>,<30ac13b7-f9e7-e08f-5f12-e6517117f2ba@redhat.com>,<SN1PR07MB2207608EF9B6869E265C85EAF8D70@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB2207608EF9B6869E265C85EAF8D70-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>The only outstanding "real" issue I'm aware of is compilation in 32-bit
>as reported by Travis CI. I have a patch ready for it but I cannot send it=
=20
>right now (it's Holiday and I'm away). I guess I will be able to pull it o=
ff
>tonight (in 12 hours) or tomorrow morning.

I just created a pull request, earlier than I expected.
The commit was verified on a 32-bit RH6.8. Travis seems happy too.
(Is it creating reports only on pull requests?)

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
