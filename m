From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/13] NFS/RDMA patches for 3.17
Date: Tue, 24 Jun 2014 13:07:50 -0400
Message-ID: <A922572E-627F-4283-9CC9-2D4D47AF619F@oracle.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <CAJZOPZ+ix6tPDHXbVrSnVzofHSbzqOoyTBvzkEo-GJpOYOaPFA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+ix6tPDHXbVrSnVzofHSbzqOoyTBvzkEo-GJpOYOaPFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jun 24, 2014, at 10:35 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jun 24, 2014 at 1:39 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>=20
>> The main purpose of this series is to address more connection drop
>> recovery issues by fixing FRMR re-use to make it less likely the
>> client will drop the connection due to a memory operation error.
>>=20
>> Some other clean-ups and fixes are present as well.
>=20
>=20
> From quick looking, patches 1,2 and 5 of series and maybe more have
> very good match for 3.16-rc (fix kernel crashes etc), I don't think
> they need to wait for 3.17

My take:

1/13 fixes a panic that should never be hit (that used to be a BUG,
which never fired in operation).

2/13 might be a candidate for 3.16-rc. It=92s up to Trond.

5/13 doesn=92t fix a regression, it always worked that way.

I=92ve updated the =93Fixes:=94 tag in these, will appear in v2 of the =
series.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
