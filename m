From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: rdma-core out-of-tree user library
Date: Wed, 7 Jun 2017 07:30:43 +0000
Message-ID: <BN3PR07MB25781E538767514E0585E7C4F8C80@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <BN3PR07MB25781554943206E577DFC714F8CB0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170606162400.GB8671@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606162400.GB8671-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Two options,
>=20
> 1) The 'ofed' approach: just use the latest rdma-core. We want
>    rdma-core to run on any kernel version and any distro release, so
>    this should not be a major problem

My major concern was that when it comes to distros we don't have their
exact code base and/or can't release it. They take rdma-core X and
apply patches on it so it becomes rdma-core X.Y.
Hence if I take rdma-core X and apply my changes I will be actually
missing several patches.
Assuming backward-and-forward support, I might as well take rdma-core X+1
and base upon it my newer patches.

> 2) For each targetted distro release back port the changes you want
>    into the exact distro rdma-core source and distribute your driver
>    binary from that build. This keeps everything very much the same
>    but upgrades that driver.
> > How are other providers handling this?

As I've indicated above we don't have their exact code base and/or can't re=
lease it.

> Most things I've seen have followed an OFED like approach because they
> also want to ship an updated kernel component. Historically we have
> not seen that much churn in the user space provider that is not linked
> to kernel changes.
>=20
> Jason

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
