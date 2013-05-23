From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000070a78
 IPoIB
Date: Thu, 23 May 2013 20:53:41 +0200
Message-ID: <519E65B5.1090909@profitbricks.com>
References: <51963BC6.1050901@profitbricks.com> <519B6DD6.4090502@profitbricks.com> <519B909A.8010004@profitbricks.com> <519E37DE.1080504@profitbricks.com> <519E54D9.1050506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519E54D9.1050506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2013=E5=B9=B405=E6=9C=8823=E6=97=A5 19:41, Doug Ledford wrote:
> On 05/23/2013 11:38 AM, Jack Wang wrote:
>> Tainted: G           O 3.4.23-pserver-hotfix+ #109 System manufactur=
er
>                          ^^^^^^^
>=20
> I would try a newer kernel.  There are a couple known issues fixed si=
nce
> this kernel (including a memory corrupter that was involved with
> neighbor list handling, and some of your traces look vaguely familiar=
 to
> that old failuer).
>=20
>=20
>=20

Thanks Doug for reply, I tried branch rdma-for-linus, It panic in other
places.

Could you point me which commit do you mean exactly?

Regards,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
