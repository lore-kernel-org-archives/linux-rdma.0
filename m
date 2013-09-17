From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for =?UTF-8?Q?rdma=5Fucm?=
Date: Tue, 17 Sep 2013 12:25:59 +0200
Message-ID: <bcec9d3a9a72ed1d612a4dd49b670800@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com>
 <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com>
 <97104d76028c356b458509ce95b08c92@meuh.org> <5238289D.40608@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5238289D.40608-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 17.09.2013 12:02, Matan Barak a =C3=A9crit=C2=A0:
>=20
> That's right - we're not checking anything here.
> struct ib_uverbs_qp_attr_ex contains 2 user pointers:
> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
> +       void __user *ah_attr_ex;
> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
> +       void __user *alt_ah_attr_ex;
>=20
> Those pointers should be given to rdma_init_qp_attr in order to=20
> initialize them.
>=20
> We are using pointers here in order to maintain future extendability
> of the address handle structures.
>=20

=46irst: you can't put pointer asis in public data structure. Look to a=
ll=20
others "command" structures
declared in include/uapi/rdma/ib_user_verbs.h

Second: if you're duplicating struct ib_uverbs_qp_attr, why not include=
=20
it in struct ib_uverbs_qp_attr_ex
it will reduce maintenance burden, clutter, etc.
Or drop the unused fields in the _ex version while taking care of being=
=20
at least equal size than
the original version.

Same apply to struct ib_uverbs_modify_qp_ex, but struct=20
ib_uverbs_modify_qp_ex has the comp_mask as first field (introducing a=20
hole).

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
