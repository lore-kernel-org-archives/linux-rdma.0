From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] [Bug 14235] New: SRP initiator lockup
Date: Sun, 6 Dec 2009 12:02:47 +0100
Message-ID: <e2e108260912060302l5b604983kcb5ee0d06b5a5f72@mail.gmail.com>
References: <bug-14235-11804@http.bugzilla.kernel.org/>
	 <ada63b3xcdt.fsf@cisco.com>
	 <e2e108260912050944k1228e964ta7a70dde493ba010@mail.gmail.com>
	 <adatyw5t7jt.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyw5t7jt.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 5, 2009 at 10:49 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> I'm not sure that the non-error path for ordinary SCSI commands =
is
> =A0> that trivial. If my interpretation of the SRP initiator source c=
ode is
> =A0> correct, the statements complete(&target->done) and
> =A0> init_completion(&target->done) can be executed concurrently. Alt=
hough
> =A0> I do not know what the exact consequences are, and although I do=
 not
> =A0> know whether this is related to the issue I reported, this is a =
race
> =A0> condition. I'm not sure that allowing such races is good kernel
> =A0> programming practice.
>
> target->done is only used in connection setup I think, so not related=
 to
> hangs during IO processing. =A0However I would like to know more deta=
ils
> of where you see this race, since yes we would want to fix that.

What I wrote above was found via source reading, so I'm not sure yet
that concurrent calls of complete(&target->done) and
init_completion(&target->done) really happen. Is it possible that e.g.
one CPU calls complete(&target->done) as a result of processing the
IB_CM_TIMEWAIT_EXIT event while another CPU is calling
init_completion(&target->done) from inside srp_disconnect_target() ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
