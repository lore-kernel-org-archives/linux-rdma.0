From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling busy responses from the SA
Date: Tue, 8 Jun 2010 20:16:04 -0400
Message-ID: <AANLkTilzAlDlx7NYuHALLSntR6Q7-Kpn9I3x-fvqmded@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DADA@MNEXMB1.qlogic.org>
	<AANLkTinEhSe7IjdzLPp6DLWGcgJd_iQuVeFvr0-HSCb-@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0C@MNEXMB1.qlogic.org>
	<AANLkTiknVS0abJVMLSZd0GOBeKvHukzbN7A1xZQDFPmD@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DCCA@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F578B7A@orsmsx501.amr.corp.intel.com>
	<AANLkTinDBQfcFpfU9PY_bLNyElXcyLlpQzoPLlj0jdAC@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DD33@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DD33-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike,

On Tue, Jun 8, 2010 at 3:59 PM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> w=
rote:
> Hal,
>
> I may be confused - but I thought the spec said there was no valid re=
sponse to a trap repress. I interpreted
>
> "o14-3.a4: The SMA shall not send any message in response to a valid =
SubnTrapRepress() message"
>
> to mean that the SMA isn't allowed to respond with a BUSY status for =
a trap repress.

I'm referring to the receipt of the TrapRepress with busy status.
Wouldn't your patch cause the original Trap to be resent when retries
> 0 ? TrapRepress is essentially a response to Trap and classified as
such by ib_response_mad. Your proposed patch treats a busy as a
timeout and can cause retry of the original sent Trap.

-- Hal

>
> -----Original Message-----
> From: Hal Rosenstock [mailto:hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, June 08, 2010 3:09 PM
> To: Hefty, Sean
> Cc: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Handling busy responses from the SA
>
> On Tue, Jun 8, 2010 at 12:27 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> w=
rote:
>>> Sean - remember that this patch will still return a BUSY status to =
the
>>> caller, if retries are exhausted and the last return code was BUSY,=
 then
>>> that's what the caller will get. Thus, code which sets retries to z=
ero will
>>> not be affected by this patch at all.
>>
>> It looks like it only returns the BUSY response if that matches with=
 the last retry, otherwise, the BUSY response is dropped. =C2=A0It also=
 looks like it applies to all MADs, including vendor specific ones, and=
 not just those from the SA.
>
> Per the proposed patch, it currently includes trap represses (as
> determined by ib_response_mad). Shouldn't busy be ignored for that
> case ? I don't think that would be used but it seems safer to me.
>
> -- Hal
>
>>
>> - Sean
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
