From: Bhavin <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: HA mode bonding for IB over SDP
Date: Fri, 1 Apr 2011 05:11:12 +0000 (UTC)
Message-ID: <loom.20110401T070836-761@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am a student pursuing masters. I have chosen to work on infiniband fo=
r my
final year project. As part of my project I am trying to implement infi=
niband
over SDP. I have also setup two systems for this purpose having Mallano=
x IB
cards. I found that OFED doesn=E2=80=99t have support for HA mode failo=
ver for IB over
SDP when searching for limitations of this configuration. So I have dec=
ided to
work on this issue.

Right now I am going through the OFED source code to understand how dif=
ferent
functionalities are implemented. I also found there is something called
APM(Automatic Path Migration) is present in OFED.

Is it possible to use APM for failover with IB over SDP? If yes, please=
 guide me
on how can I use APM for IB over SDP.

Please Help.

Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
