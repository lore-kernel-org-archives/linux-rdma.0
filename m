From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Work completions generated after a queue pair has made the
 transition to an error state
Date: Wed, 13 Oct 2010 18:55:30 +0200
Message-ID: <AANLkTinTj=RqWHXx=XO7K5_SOj+O7Zjz7pwWAL717fSU@mail.gmail.com>
References: <AANLkTimcxsymqmzoki=quCH+a2sq_fPb4YOmf3gqrzqh@mail.gmail.com>
 <1286909435.27343.93.camel@chromite.mv.qlogic.com> <AANLkTi=72Y+coH1Ke4U-Xk7Eaqpw5pipWRqXEQr7dOau@mail.gmail.com>
 <20101012202221.GD1617@mtldesk30> <adapqveyskb.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqveyskb.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 13, 2010 at 6:18 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> I'm not clear on the problem observed here. =A0A few notes:
>
> =A0- If a QP transitions to error state, then *all* work requests, wh=
ether
> =A0 or not they were signaled, generate a completion with status "flu=
sh".
>
> =A0- If a work request completes with an error status, then the opcod=
e
> =A0 field is not defined.
>
> With that understood, can you explain what part of the IB spec is not
> being implemented correctly?

I was posting my question to the this mailing list because the spec is
somewhat cryptic with regard to which fields are defined and which
ones not if the error status is set. Thanks for taking the time to
clarify the specs.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
