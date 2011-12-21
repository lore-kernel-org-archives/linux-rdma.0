From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Wed, 21 Dec 2011 08:54:13 +0100
Message-ID: <CAFr+87vvqx=yTDBKVqdDpfEOnbewXMUaahgO=0yqdY=+RV6NsA@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4EF02E10.4070501@mellanox.com>
	<CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
	<4EF06AF6.6080901@mellanox.com>
	<CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com>
	<CAJZOPZLweaD19nS94Enh1rxXwRt+bHr=cPMxdg2zcCP_d4bzfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLweaD19nS94Enh1rxXwRt+bHr=cPMxdg2zcCP_d4bzfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2011/12/20 Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>
> horses, please, stay at home, or at least run a little bit slower,
> just for you - from 2 minutes
> ago - iser works well with 3.2.0-rc5 (its say -dirty b/c its a
> development system and the kernel has some patches, but not iser ones=
)
> and iscsi-initiator-utils of 6.2.0.872-21.el6, I will try tomorrow
> with upstream iscsi-initiator-utils and see if there's a problem
> there.
>

O.K., sorry - I just wanted to know how this is developed. Even if the
kernel code matches 100%, how do I know which is the matching tested
user-space code for that?

>
> I don't use ofed at all, work only with upstream or distro code.
> AFAIK, the upstream kernel is functional with iser at all times,
> again, I will do the validation with the iscsi =A0tools and if the
> upstream iscsi tools aren't functional with the upstream iser code bu=
t
> are functional with the upstream iscsi/tcp code, we will (the iscsi
> maintainer and myself) fix that, and thanks for this possible heads
> up.
>

Thanks for that info. In OFED I thought I would have everything needed
and matching together. Due to the new kernel we have our own
distribution extends, packet repo, build server,... So, for OFED we're
the distribution.

>
> no way, OFA isn't iscsi factory, we can't support the iscsi kernel
> modules except for iser, nor any of the iscsi user space tools - and
> its a historic bug that someone with wrong ambitions added iscsi
> modules/tools info the ofa stack. The OFA stack should be compatible
> with the kernel/distro it is running on. As you can see in the
> maintainers file, I act as the iser maintainer, and I do work closely
> with the iscsi maintainer, maybe should work closer if indeed you
> stepped on a problem with the upstream iscsi tools, as for the iscsi
> tools provided with debian, I am not sure what was the problem, send
> me tgz with the sources to my @mellanox address and I can try look on
> that.
>

Perhaps, I really stepped on a rare case where this was broken. As
I've already asked: How do I find the matching, tested open-iscsi and
OFA user-space code for a mainline kernel?

Sorry again, I didn't want provoke. I just want to understand and make
things work.

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
