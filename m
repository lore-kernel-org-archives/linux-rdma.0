From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: RDMA Read sge errors
Date: Mon, 11 Jan 2010 09:34:01 +0100
Message-ID: <2AAC14CC-DACE-4CD8-833A-5E7406593732@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,


I modified the perftest program ib_read_bw to use sge lists. The length=
 of each sge is 1 (one) byte. I configured the QP to support up to 32 s=
ges (aligned with the capabilities of the device).

Now, everything works correct up to 30 sges. Using 31 or 32 sges, I rec=
eive 29 bytes in both cases, but completion gives local length error.

I am running on CentOS 5.3, Intel E5540, OFED 1.4.1, and ConnectX w/fw =
2.6.000.



Thanks, H=E5kon

--
H=E5kon Bugge
Haakon.bugge-U0mLk4xYmo8@public.gmane.org
+47 924 84 514



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
