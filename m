From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: Introduction of libqedr to the Consolidated Userspace RDMA
 Library Repo
Date: Sat, 8 Oct 2016 12:49:43 +0000
Message-ID: <SN1PR07MB2207B8BA2C9C9A1FC610DE9FF8D90@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22073DF8F016A275DA036F8EF8C70@SN1PR07MB2207.namprd07.prod.outlook.com>,<20161006163427.GG1224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161006163427.GG1224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>If you prepare a branch of rdma-core on github I can give it a quick
>look over.
>
>The technical steps are fairly simple, create a
>provider/qedr directory, add your source code, copy the CMakeLists.txt
>style from another provider, add a line to the sorted list in the top
>level CMakeLists.txt, update README.md, COPYING.md and MAINTAINERS
>
>You will want to look at the various patches I've prepared and ensure
>you cover off the basic cleanups that have already been done, and that
>your code compiles warning-free on FC24.
>
>Once you feel everything is ready then post it to the mailing list and
>send a pull request. For the mailing list you can just split the
>patches by file..
>
>Jason

Thanks, we'll start on it.


    =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
