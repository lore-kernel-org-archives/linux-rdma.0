From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ib_write_bw hanging when using max max_inline value
Date: Sun, 24 Jan 2010 07:26:56 +0200
Message-ID: <4B5BDA20.8070609@voltaire.com>
References: <46402909-D956-438D-B560-8EA2ECB1068F@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <46402909-D956-438D-B560-8EA2ECB1068F-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

H=E5kon Bugge wrote:
> the test program hangs when exchanging 920 bytes [...]  the creation =
of QP goes OK
>  =20
attaching a debugger is typically helpful to see where a program talkin=
g=20
directly to the hardware hangs. If it happens on the slow pass, strace=20
can be useful as well.  Did you take a look on the actual values set fo=
r=20
this qp, that it as suggested by ibv_create_qp(3) look on the init=20
attributes after the function returns.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
