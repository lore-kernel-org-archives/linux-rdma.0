From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Handling busy responses from the SA
Date: Tue, 8 Jun 2010 10:34:56 -0400
Message-ID: <AANLkTiknVS0abJVMLSZd0GOBeKvHukzbN7A1xZQDFPmD@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DADA@MNEXMB1.qlogic.org>
	<AANLkTinEhSe7IjdzLPp6DLWGcgJd_iQuVeFvr0-HSCb-@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0C@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DC0C-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike,

On Mon, Jun 7, 2010 at 12:00 PM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> Hal said:
> Should a busy be retried at all at the mad layer ? Is a "special" longer) timeout policy for busy needed ?
>
> Also, should this be done for all MADs classified by ib_response_mad (e.g. trap represses) ?
>
> Hal,
>
> The idea of processing BUSY responses in the MAD layer is to BUSY responses like timeouts - which are currently handled by the MAD layer. Right now there is an issue where various apps and ULPs either treat BUSY as a cause to immediately retry or as a permanent error. This doesn't seem to affect users of the OpenSM so much because (as I understand it) the OpenSM seems to discard requests when it gets too busy - but for other SA/SMs, it can cause a major packet storm or, worse, a simple loss of connectivity where MPI jobs or kernel ULPs simply assume the SA is broken because they got a BUSY reply.
>
> By treating the BUSY reply as a timeout, we're actually simplifying matters by fitting into existing practice.

Understood. Timing these out makes sense to me but still does not
preclude the client from potentially handling this if the retries
fail.

> As for needing a longer timeout - in our old proprietary stack, QLogic did have a longer timeout for retrying busy replies than for normal timeouts

How much longer ? What are the two timeouts used ?

> - but we should try to get this in now so we can get some relief before we begin the long term discussion of the best way to handle this issue overall.

All I was getting at here was: does retrying when busy work ? If not,
why retry at all at the MAD layer (regardless of retries requested)
and perhaps use a longer timeout for this. If it does work, maybe the
timeout on the subsequent retries should be extended.

I think my two other comments on details are relevant to an updated patch.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
