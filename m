From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Size of Infiniband packets
Date: Thu, 5 Dec 2013 18:22:57 -0500
Message-ID: <CADPSxAgSdWTkNBF=XEptKU0oVmqiXRVtd-m-c+ntnQyxMzDFNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I'm trying to do a back-of-the-hand calculation of the number of
packets per second that can be transmitted over 40Gbps Infiniband. I
need some information about the packet size to do this calculation.

Suppose I do an 8 byte RDMA write over RC transport. What is the
packet size that is  transmitted on the wire? This should include
Infiniband headers and the work request.

I read that 256 bytes is the minimum packet size that can be
transferred. Quote from
http://www.info-ab.uclm.es/personal/FcoAlfaro/publi/ccece02.pdf:

"As already mentioned, packets with 256 and 4096 bytes have been
considered. These sizes correspond to minimum and maximum packet size
allowable in In=EF=AC=81niBand."

Is this correct?

Thanks for your help!

--Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
