From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] memory: commented unused verify() function
Date: Wed, 11 Jul 2012 18:26:10 +0200
Message-ID: <1342023970.5418.5.camel@test.quest-ce.net>
References: <1342019410-10004-1-git-send-email-ydroneaud@opteya.com>
	 <4FFDA2A9.1060500@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FFDA2A9.1060500-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 11 juillet 2012 =C3=A0 18:58 +0300, Or Gerlitz a =C3=A9crit=
 :
> any reason not to remove it all together?
>=20

It might be use for debug purpose.
Perhaps someone will add such code back after seeing my patch.

If no one step up for this, the red-black tree verification function
could be removed.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
