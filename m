From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ib mad definitions
Date: Tue, 19 Oct 2010 13:00:01 -0400
Message-ID: <AANLkTim5fGA2ph7dPnJADBHs_-7qCBpXKakiTHTH9g1W@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
	<AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3E34@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3E34-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 19, 2010 at 12:48 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> I agree ib_types.h is more generic than opensm. Moving to libibmad a=
nd
>> making opensm depend on this is probably better than all the
>> duplication. There have been viewpoints that libibumad and libibmad
>> shouldn't be separate (as they are small) but they were never combin=
ed
>> into a single library.

The other thing I just recalled was the OpenSM portability issue.
ib_types.h is needed here and libibmad/libibumad is not in all those
environments. As you''re all too well aware, this was even the case in
Windows until very recently. There may still be others we care about
where moving ib_types.h might be problematic.

-- Hal

> My motivation with these changes is for ibacm to receive and use noti=
fication of CM timeouts to update its path record cache. =C2=A0ibacm al=
ready defines the basic mad structure, multicast record, and path recor=
d. =C2=A0It would also need the CM mad format. =C2=A0I'd happily remove=
 these definitions if they were already available.
>
> Porting madeye to user space is a side benefit to the proposed kernel=
 changes.
>
> ibacm only depends on libibumad. =C2=A0The madeye port also only depe=
nds on libibumad. =C2=A0Honestly, I find the libibmad APIs confusing. =C2=
=A0I'd much rather libibumad provide mad definitions.
>
> Sasha/Ira, do either of you have opinions on this?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
