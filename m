From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: ibv_asyncwatch and buffering
Date: Thu, 21 Jan 2010 11:30:38 +0100
Message-ID: <41C706F4-CB54-4F03-86BD-03F27302B128@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,


It seems like ibv_asyncwatch defaults to standard libc behavior wrt. to=
 buffering. That is, if you pipe the output of ibv_asyncwatch, no outpu=
t happens, as the stdout is redirected to a pipe and block buffering is=
 used by default.

One could a) use sprintf() and write() or b) force libc buffering to li=
ne-mode by means of setlinebuf(stdout).

That would make ibv_asyncwatch more useful in scripted environments.



Thanks,=20
H=E5kon



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
