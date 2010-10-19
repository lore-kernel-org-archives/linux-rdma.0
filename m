From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ib mad definitions
Date: Tue, 19 Oct 2010 11:43:22 -0400
Message-ID: <AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 19, 2010 at 11:28 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> > but is there a strong reason why ib_types.h can't be moved from
>> opensm/include/iba to libibumad/include/infiniband?
>>
>> Why does this need to be moved ?
>
> The dependency should be on libibumad, not opensm. =C2=A0libibumad is=
 pretty much useless without these definitions. =C2=A0Why wouldn't you =
move them?

Off the top of my head, OpenSM is layered on top of libibumad but
doesn't need/use libibmad. I think that was the main reason although
that could be changed if ib_types.h were to be moved. I'm not sure
what other reasons came up in the previous discussions.

>
>> There already are diags including ib_types.h (saquery for one).
>
> Yes, but we're either stuck with everything that needs ib_types.h to =
be part of the management.git tree, or the app needs to depend on opens=
m. =C2=A0Currently, ibacm duplicates definitions because they aren't av=
ailable anywhere else.

I agree ib_types.h is more generic than opensm. Moving to libibmad and
making opensm depend on this is probably better than all the
duplication. There have been viewpoints that libibumad and libibmad
shouldn't be separate (as they are small) but they were never combined
into a single library.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
