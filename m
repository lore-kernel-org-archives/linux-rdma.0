From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ib_write_bw hanging when using max max_inline value
Date: Mon, 25 Jan 2010 13:57:41 +0200
Message-ID: <4B5D8735.8010503@voltaire.com>
References: <46402909-D956-438D-B560-8EA2ECB1068F@Sun.COM>	<4B5BDA20.8070609@voltaire.com> <45B7D3D4-811E-4645-8C18-6E32BE411650@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <45B7D3D4-811E-4645-8C18-6E32BE411650-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

H=E5kon Bugge wrote:
> The capabilities in qp_init_attr used as input to ibv_create_qp() are=
:
> max_send_sge =3D 1, max_recv_sge =3D 1, max_inline_data =3D 928
> Upon return the capabilities are modified to the following=20
> max_send_sge =3D 32, max_recv_sge =3D 1, max_inline_data =3D 928
> Note decreasing the size of the RDMA to 912 bytes, the program works
Jack, sounds like this use case hits the bug/s you were attempting to=20
solve with the patch set we were discussing @=20
http://marc.info/?l=3Dlinux-rdma&m=3D126330119309593 which that never m=
ade=20
it upstream, correct?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
