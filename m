From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 09:07:04 +0300
Message-ID: <20110519060704.GA2659@mtldesk30>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
 <1303467645.2243.47.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1303467645.2243.47.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yan,
it appears that you're using quite an old firmware. Could you upgrade
the firmware to the latest version and check again the failure to
create a QP with the max depth. FW and burning tools can be downloaded
from www.mellanox.com.

Another possible reason for the failures you were seeing is the 4 MB
limit on locking memory from usersapce. Could you repeat the
experiment as root?

P.S: I checked on my setup and was able to create a QP with the max
size.

On Fri, Apr 22, 2011 at 12:20:45PM +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le jeudi 21 avril 2011 =E0 11:53 -0700, cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org a =E9crit :
> > An ENOMEM return does not mean that the subsystem *just* failed to
> > allocate system memory.
>=20
> > The memory that could not be allocated could be device memory.
> >        =20
>=20
> I'm also having some difficulties with system memory allocation.
>=20
> In my test, a user is allowed to lock 4MBytes of memory, but not all
> this memory is available to ibv_reg_mr() since ibv_create_cq() and
> ibv_create_qp()/rdma_create_qp() lock memory respectively for CQ and =
QP.
> The question is how much memory is needed for the CQ and QP queues ?
>=20
> In my case, the maximum message of size is 4MBytes - 20KBytes, for a =
CQ
> and QP (half duplex) queues length of 1.
>=20
> Using message size of 128 bytes and less hit the QP WR limit of 16351
> length.
>=20
> When using messages of size 256 bytes, I'm only able to register 2609=
152
> bytes, then CQ and QP (half duplex) queues are 10192 entries length. =
So
> they seems to requires about 1585152 bytes. Taking in account a fixed
> amount of reserved memory of 20KBytes, this give about 154 bytes per =
(CQ
> + QP (half duplex)) entry.
>=20
> When doing the same math with size 512 and 1024, the size of (CQ + QP
> (half duplex)) is going down.
>=20
> msg  512 memory 3395584 length 6632
> msg 1024 memory 3788800 length 3700
> msg 2048 memory 3985408 length 1946
>=20
> Note that the memory used for the message is allocated as an aligned =
big
> chunk and registered as whole, and then sliced to be posted in WR.=20
>=20
> But the memory required for the CQ and QP elements (and other) is als=
o
> subject to alignment to a page size.
>=20
> At least, I known that CQ / QP "overhead" is not going to hurt users,=
 if
> they are allocated "modern" memory limits, let's say 1GBytes ;)
>=20
> Regards.
>=20
> --=20
> Yann Droneaud
> OPTEYA
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
