From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: rdma-core stable releases
Date: Mon, 6 Nov 2017 18:21:47 +0000
Message-ID: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,=20

Following EWG weekly meeting, I'd like to open a discussion regarding the n=
ecessity of maintaining a
stable rdma-core branch similar to the linux kernel stable branches. I unde=
rstood there were some
offline discussions on the topic and would like to raise it on the list and=
 try to push forward.=20

We found a critical qedr bug during OFA debug event testing. We provided a =
patch which
was applied (e768239 libqedr: fix inline data copy). However, we remain wit=
h rdma-core-15 broken
for qedr.
=20
We feel for this case, and perhaps other similar issues in the future, it w=
ill be useful and critical for distros,
OFED, and independent package-installation to have a stable release for eac=
h rdma-core release.

I'd like to here if anyone has any objects / concerns on the matter in gene=
ral, and if there is a
consensus about the need and whether this is something the rdma-core mainta=
iners would be willing
to provide.=20

Thanks,
Michal=20


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
