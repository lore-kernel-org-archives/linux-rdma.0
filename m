From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: New providers in rdma-core
Date: Thu, 20 Oct 2016 09:24:30 +0000
Message-ID: <SN1PR07MB2207D6CF5ADA67FCFCAA3A2EF8D50@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <20161019163913.GA30843@infradead.org>
 <6b57d79c-dbd3-cd9b-061e-27a3d3968845@vmware.com>
 <20161019175926.GD29879@obsidianresearch.com>
 <12243e3b-87cf-2bd4-d097-1dd0a7907f41@vmware.com>
 <20161019200911.GA2666@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161019200911.GA2666-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Perhaps aided by a macro so we get high uniformity:
>=20
> #define DECLARE_DRIVER_UDATA(struct_driver, struct_common)
>   struct user # struct_driver {
>      struct struct_common ibv_resp;
>      struct struct_driver udata;
>   };
>=20
> Where mlx4_alloc_ucontext_resp_v3 comes from the uapi header, and is not
> inlined, so each driver gets an 'abi wrapper' header that just builds all=
 these
> structs.

The idea looks good to me.
But still, I'm missing something - in order for libraries and the kernel to=
 use the=20
same headers they should reside in the same repository.
Is that the long-term goal? And wouldn't that be mixing user/kernel spaces?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
