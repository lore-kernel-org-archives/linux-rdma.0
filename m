From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling busy responses from the SA
Date: Thu, 17 Jun 2010 09:29:45 -0400
Message-ID: <AANLkTinfaefusFzjn6k6Ly2ti3EiEz5Qfczps7EscRCc@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DADA@MNEXMB1.qlogic.org>
	<AANLkTinEhSe7IjdzLPp6DLWGcgJd_iQuVeFvr0-HSCb-@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0C@MNEXMB1.qlogic.org>
	<AANLkTiknVS0abJVMLSZd0GOBeKvHukzbN7A1xZQDFPmD@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DCCA@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F578B7A@orsmsx501.amr.corp.intel.com>
	<AANLkTinDBQfcFpfU9PY_bLNyElXcyLlpQzoPLlj0jdAC@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DD33@MNEXMB1.qlogic.org>
	<AANLkTilzAlDlx7NYuHALLSntR6Q7-Kpn9I3x-fvqmded@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49D09E7ACD@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7ACD-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike,

On Wed, Jun 16, 2010 at 3:57 PM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> Hal,
>
> But if the original trap had retries > 0, wouldn't resending the trap be what the issuer intended?

I suppose as there's nothing in the IBA spec that precludes using busy
on TrapRepresses although I'd be hard pressed to rationalize using
that particularly for SMP traps.

-- Hal

> I guess I'm confused why treating BUSY as similar to simply never getting a response at all is a bad thing. In my mind, receiving a BUSY response is like getting a busy signal when you call someone on the phone - a sign you need to wait a bit then try again. Similarly, if I call someone and never get an answer my strategy is going to be to wait, then try again.

> -----Original Message-----
> From: Hal Rosenstock [mailto:hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, June 08, 2010 8:16 PM
> To: Mike Heinz
> Cc: Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Handling busy responses from the SA
>
> Mike,
>
> I'm referring to the receipt of the TrapRepress with busy status.
> Wouldn't your patch cause the original Trap to be resent when retries
>> 0 ? TrapRepress is essentially a response to Trap and classified as
> such by ib_response_mad. Your proposed patch treats a busy as a
> timeout and can cause retry of the original sent Trap.
>
> -- Hal
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
