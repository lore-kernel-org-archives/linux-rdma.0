From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Mon, 10 Oct 2016 06:34:43 +0000
Message-ID: <SN1PR07MB22070099EE40A67B81D14C75F8DB0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161006133357.GP9282-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +/* * CQE requester status enumeration */ enum
> > +rdma_cqe_requester_status_enum {
> > +	RDMA_CQE_REQ_STS_OK,
> > +	RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR,
> > +	RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR,
> > +	RDMA_CQE_REQ_STS_LOCAL_QP_OPERATION_ERR,
> > +	RDMA_CQE_REQ_STS_LOCAL_PROTECTION_ERR,
> > +	RDMA_CQE_REQ_STS_MEMORY_MGT_OPERATION_ERR,
> > +	RDMA_CQE_REQ_STS_REMOTE_INVALID_REQUEST_ERR,
> > +	RDMA_CQE_REQ_STS_REMOTE_ACCESS_ERR,
> > +	RDMA_CQE_REQ_STS_REMOTE_OPERATION_ERR,
> > +	RDMA_CQE_REQ_STS_RNR_NAK_RETRY_CNT_ERR,
> > +	RDMA_CQE_REQ_STS_TRANSPORT_RETRY_CNT_ERR,
> > +	RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR,
> > +	MAX_RDMA_CQE_REQUESTER_STATUS_ENUM
>=20
> Please add "," at the last line of enums, it will allow future changes to=
 these
> enums with minimal churn.

This is a good idea and I've applied it to several enums in the patch.
However, I think that this specific enum should left be as is since the las=
t element should always remain last as it is a MAX_*
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
