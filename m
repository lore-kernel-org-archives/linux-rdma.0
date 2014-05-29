From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting minutes (5/28)
Date: Thu, 29 May 2014 12:53:53 -0400
Message-ID: <CEC2E6A0-AC07-4C70-B318-AA70F273ECBD@oracle.com>
References: <5387615E.20206@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5387615E.20206-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "<yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 29, 2014, at 12:33 PM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> 2. NFSoRDMA support with soft RoCE and Soft iWARP
>=20
> There were some discussions regarding whether removing RPCRDMA_REGIST=
ER support (one of Chuck's patchset) would impact any other components =
in the stack. So far soft RoCE hasn't been upstreamed yet.There was a b=
road consensus not to support out-of-tree providers unless an issue als=
o affects in-tree providers. NFSoRDMA will follow kernel development po=
licy, all work should be based upon upstream kernel. However Chuck Leve=
l will check Soft RoCE plan, Steve Wise will check soft iWARP plan to m=
ake sure nothing will be broken in both kernel and OFED release.

I=92ve confirmed OFED 3.12 does not have the soft RoCE provider, and it=
 is also not in mainline. It=92s sort of in the same limbo that the NFS=
/RDMA server-side code is.

I will pursue our technical questions with System Fabrics (authors of r=
xe).

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
