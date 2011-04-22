From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: rdma_create_qp() and max_send_wr
Date: Fri, 22 Apr 2011 12:37:49 +0200
Message-ID: <1303468669.2243.49.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
	 <1303467645.2243.47.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303467645.2243.47.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

And I forgot to mention:

Le vendredi 22 avril 2011 =C3=A0 12:20 +0200, Yann Droneaud a =C3=A9cri=
t :
> I'm also having some difficulties with system memory allocation.

In this case of failure, strace shows the last write() syscall returnin=
g
ENOMEM.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
