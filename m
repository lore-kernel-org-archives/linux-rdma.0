From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp warning
Date: Thu, 13 Jan 2011 08:06:41 +0100
Message-ID: <AANLkTi=k9avJrsX6yisggRxPoLbDnnXr9DzQ5KGazBpv@mail.gmail.com>
References: <adalj2q587i.fsf@cisco.com> <1294854748.15826.26.camel@lap75545.ornl.gov>
 <ada8vyq57bq.fsf@cisco.com> <1294861341.15826.38.camel@lap75545.ornl.gov>
 <adaoc7l52hy.fsf@cisco.com> <adak4i952bk.fsf@cisco.com> <1294866460.15826.41.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294866460.15826.41.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 12, 2011 at 10:07 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
>
> On Wed, 2011-01-12 at 14:50 -0500, Roland Dreier wrote:
> > > Attached -- I'm using kind of a minimal config for build testing,=
 so
> > =A0> maybe I have some strange optimization enabled (CONFIG_CC_OPTI=
MIZE_FOR_SIZE=3Dy?)
> >
> > Indeed... unsetting CONFIG_CC_OPTIMIZE_FOR_SIZE seems to get rid of=
 the warning.
>
> Pushed the uninitialized_var change to
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git s=
rp-lock-scaling-warning

Please post patches inline - that makes reviewing easier.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
