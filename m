From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: message size, was Re: merge struct ib_device_attr into struct
 ib_device
Date: Wed, 23 Sep 2015 10:26:38 +0200
Message-ID: <1442996798.4412.4.camel@opteya.com>
References: <1442869187-5556-1-git-send-email-hch@lst.de>
	 <1442918846.4412.0.camel@opteya.com> <20150922203217.GA10825@lst.de>
	 <013f01d0f57a$85b12a20$91137e60$@opengridcomputing.com>
	 <20150922215514.GA13252@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150922215514.GA13252-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 22 septembre 2015 =C3=A0 23:55 +0200, 'Christoph Hellwig' a =C3=
=A9crit :
> On Tue, Sep 22, 2015 at 04:06:17PM -0500, Steve Wise wrote:
> > Can you create a series of smaller patches that will fit on the
> > list?
> > That would make it easier for everyone to review/comment.=20
>=20
> I don't see how that is possible, as it's a flag day change.
>=20

Perhaps you could change ib_query_device() to use the ib_device_attr
from struct ib_device so that ulp doesn't have to be modified at the
same time the drivers. Then further patches can update the users of
ib_query_device(), one at a time. And the last patch would remove
ib_query_device().

Regards.

--=20
Yann Droneaud

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
