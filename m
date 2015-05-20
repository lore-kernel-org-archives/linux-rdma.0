From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 01/10] IB/core: Change provider's API of
 create_cq to be extendible
Date: Wed, 20 May 2015 17:14:08 +0200
Message-ID: <1432134848.5304.24.camel@opteya.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
	 <1431869786-6308-2-git-send-email-ogerlitz@mellanox.com>
	 <20150519184535.GJ18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519184535.GJ18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mardi 19 mai 2015 =C3=A0 12:45 -0600, Jason Gunthorpe a =C3=A9crit :
> > +     struct ib_cq *             (*create_cq)(struct ib_device *dev=
ice,
> > +                                             struct ib_cq_init_att=
r *attr,
>=20
> const struct ib_cq_init_attr *attr,
>=20
> And related changes that will cause.

I was going to ask for the same change.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
