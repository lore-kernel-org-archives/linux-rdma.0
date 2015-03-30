From: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: infiniband/ulp/srpt/ib_srpt.c:1082: bug report
Date: Mon, 30 Mar 2015 08:29:04 +0000
Message-ID: <DUB128-W4954AFECD21AAABA8D7A819CF50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello there,

[linux-4.0-rc6/drivers/infiniband/ulp/srpt/ib_srpt.c:1082] -> [linux-4.=
0-rc6/drivers/infiniband/ulp/srpt/ib_srpt.c:1098]: (warning) Possible n=
ull pointer dereference: ch - otherwise it is redundant to check it aga=
inst null.

=A0=A0=A0 struct ib_device *dev =3D ch->sport->sdev->device;

=2E..

=A0=A0 BUG_ON(!ch);

Suggest move init of dev until *after* ch has been sanity checked again=
st NULL.

Regards

David Binderman

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
