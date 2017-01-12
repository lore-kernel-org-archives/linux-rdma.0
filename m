From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Thu, 12 Jan 2017 12:32:37 +0000
Message-ID: <SN1PR07MB220756D06EA23CE46DEC11A2F8790@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
 <0e01bfc8-333d-99dd-f7d1-024422923021@redhat.com>
 <20170110161031.GB15493@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110161031.GB15493-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> RDMA hardware doesn't work in ARM so that is OK. Cross compiling is fine,
> ideal would be to test RXE on an arbitary ARM system, but I wouldn't call
> that critical.
>=20
> I just don't want to setup a cross compiler for this :\
>=20
> Jason
> --

Hi Jason, Doug, All,

I wanted to bring to your attention that our RDMA solution *is* working in =
an ARM based environment:
the Cavium ThunderX platform. This is a 64bit ARMv8 *with* cache coherency.=
 Please keep that in mind
when considering RDMA-relevant platforms.

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
