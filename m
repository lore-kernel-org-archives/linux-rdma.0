From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Tue, 25 Oct 2011 08:07:03 +0200
Message-ID: <CAO+b5-qzPwb7E=CCvGTSbTiqn0mmSZCKK=kp8DiwFqNbduOnQw@mail.gmail.com>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-rch-mPgXKjs4=t4ubfb9SFhDiR26EoeJgyZjWfhRJ9DA@mail.gmail.com>
 <1319481232.17450.11.camel@haakon2.linux-iscsi.org> <CAG4TOxMmB13exCOx_QC6+302sS4GjhggNrTwdLi4n14=as2PWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxMmB13exCOx_QC6+302sS4GjhggNrTwdLi4n14=as2PWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Nicholas A. Bellinger\"" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 11:01 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> On Mon, Oct 24, 2011 at 11:33 AM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>>> - Handle IB completion timeouts. Although the InfiniBand Architectu=
re
>>> Manual specifies that a HCA must generate an error completion for e=
ach
>>> pending work item when a queue pair reset is issued, an important
>>> class of HCAs doesn't do this (that includes the HCA in your test
>>> setup). In the SCST version of this driver such timeouts are handle=
d
>>> by the function srpt_pending_cmd_timeout().
>
> Hold on... not sure what you mean by a "queue pair reset" but the IB
> spec does not say that a flush error should be generated when a QP is
> transitioned to the "reset" state. =A0The flush error completions are
> required when a QP is transitioned to the "error" state, and in fact
> completion entries may be lost when a QP transitions to "reset".

I was referring to transitioning a QP to the error state -- see also
srpt_ch_qp_err().

> As far as I know every HCA supported by Linux does implement this
> correctly. =A0Which class did you have in mind as not doing that?

At least QDR ConnectX 2 HCAs with fairly recent firmware. This
behavior can be reproduced easily with the SCST version of ib_srpt as
follows:
- Log in from an SRP initiator to ib_srpt.
- Start a direct I/O read test, e.g. with fio.
- Issue the command "rmmod ib_srpt" on the target during I/O.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
