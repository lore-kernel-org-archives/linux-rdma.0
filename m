From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 1/2] RDMA/qedr: Notify user application if DPM is
 supported
Date: Thu, 22 Jun 2017 11:27:33 +0000
Message-ID: <BN3PR07MB25780DFABFD322D3B252CA95F8DB0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
 <1497790871-23945-2-git-send-email-Ram.Amrani@cavium.com>
 <20170619155553.GB10188@obsidianresearch.com>
 <BN3PR07MB2578EC6DD9C3DF920388418AF8C50@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170620104104.GS17846@mtr-leonro.local>
 <20170620153928.GB29283@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170620153928.GB29283-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=20
> so you need to to whatever mlx4/5 do, and if we have some code
> duplication then maybe a new ib_copy_to_udate_ex function is sensible.
>=20

OK

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
