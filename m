From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user verbs
Date: Wed, 28 Jun 2017 10:02:45 +0000
Message-ID: <BN3PR07MB25788193EFA21CEB5C430201F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
 <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
 <20170628095422.GA1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628095422.GA1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Most user verbs pass user data to the kernel with the inclusion of the
> > ib_uverbs_cmd_hdr structure. This is problematic because the vendor has
> > no ideas if the verb was called by a legacy verb or an extended verb.
>=20
> Why vendor should know about it? It has midlayer (ib/core) between him
> and user to handle it.
>=20

Knowing the inlen can be used to determine if the library is newer than
the kernel and what features it supports or not.

Ram


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
