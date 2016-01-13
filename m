From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Wed, 13 Jan 2016 10:26:34 +0100
Message-ID: <1452677194.9500.27.camel@opteya.com>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
	 <1452609431.9500.24.camel@opteya.com> <56960E5C.5000607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56960E5C.5000607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mercredi 13 janvier 2016 =C3=A0 10:44 +0200, Sagi Grimberg a =C3=A9c=
rit=C2=A0:
> > Anyway, I'm not sure about the alignment of the memory returned by
> > kcalloc(), I should have known by the time but don't find time to
> > figure how it's handled on various SL*B allocator implementation.
>=20
> Can you explain why should I worry about the alignment of kcalloc
> here?

Say it returns memory aligned on 16 bytes, then accessing some items in
the array is going to touch 2 cachelines, defeating the purpose of the
padding or the alignment attribute added to the item structure.

Regards.

--=C2=A0
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
