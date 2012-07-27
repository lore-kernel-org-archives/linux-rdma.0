From: "Paul Grun" <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: Work completion error: "transport retry counter exceeded"
Date: Fri, 27 Jul 2012 11:51:07 -0700
Message-ID: <00fe01cd6c28$c8e0cdc0$5aa26940$@com>
References: <20120725190719.475605dc169353b775cd3463@llnl.gov> <CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ@mail.gmail.com> <CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA@mail.gmail.com> <CAL1RGDVwy56YL7OLxVuvap5WZRzzZsosQmKBkhWZB73uy3ysDg@mail.gmail.com> <00e901cd6c17$f56161e0$e02425a0$@com> <CALfB72A+ghTETXqVt63YW-cWF_ygiEDkFq9SvQos=Vuv4ZcfwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72A+ghTETXqVt63YW-cWF_ygiEDkFq9SvQos=Vuv4ZcfwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Albert Strasheim' <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, 'Ira Weiny' <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The only way to get an RNR-NAK when doing an RDMA WRITE operation is if the
RDMA WRITE includes immediate data.  If Ira is not using immediate data,
then the cause of the local error cannot be due to an excessive number of
RNR-NAKs.

In any event though, Roland points out that the verbs can distinguish
between an RNR-NAK counter expiration (IBV_WC_RNR_RETRY_EXC_ERR) and a retry
counter expiration (IBV_WC_RETRY_EXC_ERR).  So my question is moot.

-Paul

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Albert Strasheim
> Sent: Friday, July 27, 2012 10:33 AM
> To: Paul Grun
> Cc: Roland Dreier; Ira Weiny; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Work completion error: "transport retry counter exceeded"
> 
> Hello
> 
> On Fri, Jul 27, 2012 at 6:50 PM, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
> wrote:
> > Ira, are you by any chance sending immediate data with your RDMA Write?
> 
> Out of curiosity, what would be the significance if the answer to this
> question was yes?
> 
> Regards
> 
> Albert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
