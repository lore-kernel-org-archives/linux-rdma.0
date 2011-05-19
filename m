From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 11:17:16 +0200
Message-ID: <1305796637.2359.6.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
	 <1303467645.2243.47.camel@deela.quest-ce.net>
	 <20110519060704.GA2659@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110519060704.GA2659@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 19 mai 2011 =C3=A0 09:07 +0300, Eli Cohen a =C3=A9crit :
> Hi Yan,
> it appears that you're using quite an old firmware. Could you upgrade
> the firmware to the latest version and check again the failure to
> create a QP with the max depth. FW and burning tools can be downloade=
d
> from www.mellanox.com.
>=20

Upgraded to firmware 2.8.0600, I have the same problem.

> Another possible reason for the failures you were seeing is the 4 MB
> limit on locking memory from usersapce. Could you repeat the
> experiment as root?
>=20

The '16351' limit also hit root on my testbench.
I have also raised the memory limit to 1GBytes, and it doesn't work too=
=2E

> P.S: I checked on my setup and was able to create a QP with the max
> size.
>=20

Have you some test code for me to test ?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
