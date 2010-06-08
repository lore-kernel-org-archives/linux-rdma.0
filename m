From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling busy responses from the SA
Date: Tue, 8 Jun 2010 15:08:35 -0400
Message-ID: <AANLkTinDBQfcFpfU9PY_bLNyElXcyLlpQzoPLlj0jdAC@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DADA@MNEXMB1.qlogic.org>
	<AANLkTinEhSe7IjdzLPp6DLWGcgJd_iQuVeFvr0-HSCb-@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0C@MNEXMB1.qlogic.org>
	<AANLkTiknVS0abJVMLSZd0GOBeKvHukzbN7A1xZQDFPmD@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DCCA@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F578B7A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F578B7A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 8, 2010 at 12:27 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> Sean - remember that this patch will still return a BUSY status to t=
he
>> caller, if retries are exhausted and the last return code was BUSY, =
then
>> that's what the caller will get. Thus, code which sets retries to ze=
ro will
>> not be affected by this patch at all.
>
> It looks like it only returns the BUSY response if that matches with =
the last retry, otherwise, the BUSY response is dropped. =C2=A0It also =
looks like it applies to all MADs, including vendor specific ones, and =
not just those from the SA.

Per the proposed patch, it currently includes trap represses (as
determined by ib_response_mad). Shouldn't busy be ignored for that
case ? I don't think that would be used but it seems safer to me.

-- Hal

>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
