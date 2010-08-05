From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2] IB/srp: use multiple CPU cores more effectively
Date: Thu, 5 Aug 2010 12:55:17 +0200
Message-ID: <AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ@mail.gmail.com>
References: <201008031602.37294.bvanassche@acm.org>
	<4C59C34F.2000400@vlnb.net>
	<adak4o66rir.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4o66rir.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 4, 2010 at 10:40 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> I believe this is a wrong approach for this problem. You are
> =A0> workarounding it, not solving, and introducing a bad side effect=
 of
> =A0> additional context switch per command, so increasing its process=
ing
> =A0> latency. It doesn't matter that it can be switched off. Linux al=
ready
> =A0> has too many magic knobs where average user for long ago get los=
t.
>
> agree ... how do we expect users to know what value to set for the
> thread parameter?
>
> =A0> If you want to spread requests post processing among several CPU=
s, you
> =A0> should consider real approaches for that:
>
> And furthermore, as far as I can see, the subject line of this patch =
is
> quite misleading. =A0It does not use multiple CPUs at all for the num=
bers
> posted, since it creates a single kthread and moves completion
> processing there (although maybe this would help with multiple target=
s).
>
> It seems the real improvement comes exactly from the increased latenc=
y:
> by waiting a little while (overhead of going from completion interrup=
t
> to kthread scheduling) before processing completions, we take fewer
> interrupts because we process completions in bigger batches.
>
> So maybe a better solution would be something NAPI-like -- ie when a
> completion occurs, schedule a tasklet that polls the CQ some number o=
f
> times, and if the CQ is not empty at the end, reschedule to tasklet t=
o
> poll the CQ again without reenabling the CQ notification... ie
> adaptively go into a polling mode when the interrupt load goes up.
>
> But maybe this should be done higher in the block stack?

How about adding blk-iopoll support in ib_srp ? blk-iopoll is the NAPI
equivalent for block devices. More information about blk-iopoll can be
found here: http://lkml.org/lkml/2009/8/6/395.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
