From: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: drivers/staging/rdma/hfi1/sdma.c:740: bad if test ?
Date: Sat, 12 Sep 2015 03:40:22 +0000
Message-ID: <DUB128-W16C8F40B6E4A09D9F0E64C9C5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello there,

drivers/staging/rdma/hfi1/sdma.c:740:17: warning: logical =91and=92 of =
mutually exclusive tests is always false [-Wlogical-op]

Source code is

=A0=A0=A0 if (count < 64 && count> 32768)
=A0=A0=A0=A0=A0=A0=A0 return SDMA_DESCQ_CNT;

Maybe better code

=A0=A0=A0 if (count < 64 || count> 32768)
=A0=A0=A0=A0=A0=A0=A0 return SDMA_DESCQ_CNT;


Regards

David Binderman

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
