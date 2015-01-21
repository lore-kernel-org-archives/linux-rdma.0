From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/17] IB/core: Add support for extended query device
 caps
Date: Wed, 21 Jan 2015 11:32:33 +0100
Message-ID: <1421836353.13543.7.camel@opteya.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
	 <1418310266-9584-7-git-send-email-haggaie@mellanox.com>
	 <1418733236.2779.26.camel@opteya.com>
	 <CAG4TOxP9OhPigPseCzhUacHADoH2pEdj672V0SVfZuBTjKLHVg@mail.gmail.com>
	 <CAJ3xEMi+SCakMD=PYamYjqYWb0oCmccLzyR-4+K-fhF1bGfykQ@mail.gmail.com>
	 <1418760888.3245.29.camel@dworkin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418760888.3245.29.camel@dworkin>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 16 d=C3=A9cembre 2014 =C3=A0 21:14 +0100, Yann Droneaud a =C3=A9=
crit :
> Le mardi 16 d=C3=A9cembre 2014 =C3=A0 22:07 +0200, Or Gerlitz a =C3=A9=
crit :
> > On Tue, Dec 16, 2014 at 7:41 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =
wrote:
> > > On Tue, Dec 16, 2014 at 4:33 AM, Yann Droneaud <ydroneaud@opteya.=
com> wrote:
> > >>
> > >> With the suggested change here, buffer overflow won't happen,
> > >> but the error is silently ignored, allowing uverb to return a
> > >> partial result, which is likely not expected by userspace as
> > >> it's a bit difficult to handle it gracefully.
> > >>
> > >> So this has to be removed, and a check on userspace response
> > >> buffer must be added to ib_uverbs_ex_query_device() instead.
> > >
> > > I'm not sure of the specifics of the change you're suggesting her=
e.
> > > Would it be OK to go forward with the patch set we have, and then=
 fix
> > > this issue before 3.19-rc2?
> >=20
> > Roland,
> >=20
> > Haggai will address the change in an incremental patch against your
> > for-next (3.19-rc1) so the fix will be ready on time for 3.19-rc2
> >=20

AFAICT, no fix has been posted on the list so far.
Do you have a patch to address the issue ready ?

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
