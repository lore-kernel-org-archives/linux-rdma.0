From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: ib_write_bw hanging when using max max_inline value
Date: Fri, 22 Jan 2010 17:50:31 +0100
Message-ID: <46402909-D956-438D-B560-8EA2ECB1068F@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,


I modified ib_write_bw to support inline sizes beyond the default value=
 of 400 (not sure why the program does not allow larger values though).

When using the largest max_inline value supported by ConnectX (i.e. the=
 creation of QP goes OK), the test program hangs when exchanging 920 by=
tes.

Client command line: ib_write_bw -I 928 -s 920 <server>

I am running on CentOS 5.3, Intel E5540, OFED 1.4.1, and ConnectX w/fw =
2.6.000.


Thanks, H=E5kon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
