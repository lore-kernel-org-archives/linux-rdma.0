From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Wed, 21 Dec 2011 10:14:26 +0100
Message-ID: <CAFr+87ve6D-FxxBkqZYr96g34quE7iu7WixsnKPgMxxZ8Z1USg@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4EF02E10.4070501@mellanox.com>
	<CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
	<4EF06AF6.6080901@mellanox.com>
	<CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com>
	<4EF18C84.2040500@mellanox.com>
	<CAFr+87u5b7GX-NaA229MD5S_wOrds5yUuqjjjUBz=p-HLWiKTA@mail.gmail.com>
	<4EF1958C.3080305@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EF1958C.3080305-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> you wrote long emails, I'm asking for one concrete example for that e=
num
> crunching =A0of adding entries
> not at the end, can you, please?

I've meant e.g. the iscsi tasks in libiscsi.h between 2.6.30 and
2.6.32. But I've meant this for OFED and not the mainline kernel.

2.6.30:
enum {
         ISCSI_TASK_COMPLETED,
         ISCSI_TASK_PENDING,
         ISCSI_TASK_RUNNING,
};

2.6.32:
enum {
         ISCSI_TASK_FREE,
         ISCSI_TASK_COMPLETED,
         ISCSI_TASK_PENDING,
         ISCSI_TASK_RUNNING,
         ISCSI_TASK_ABRT_TMF,            /* aborted due to TMF */
         ISCSI_TASK_ABRT_SESS_RECOV,     /* aborted due to session reco=
very */
};

> I want to double check I'm with you - so when you said that iser didn=
't work
> e.g "TCP worked very well. I've also updated from git to latest 2.0.8=
72
> (latest change 2011-11-01) for testing. TCP always worked and iSER wa=
s
> always unusable." you actually wanted to say "iser from ofed" and not=
 iser
> from this or that upstream kernel?
>

I've tried both. The iser from OFED oopsed (because it is 2.6.30 based
- didn't match the 3.0 open-iscsi in-tree) and everything from
upstream kernel 3.0.4 was pretty unstable (mentioned connection aborts
after 5s). And I guess because of the OFED-1.4 user-space from Squeeze
the IB connection was that unstable. The OFED user-space must match
the kernel code of cause. Before I took over the kernel maintaining at
ProfitBricks only few knew about that problem in the company. So, I
thought making everything OFED-1.5.4 is the right approach of doing
that.

>
> as life, mainline isn't perfect, but it doesn't say that ofed is perf=
ect nor
> that by any bit its better then mainline, you may know and if you don=
't here
> are the news: the ofa community has to decided to stop producing ofed=
 in the
> way it was done over the years, namely from now (Jan 2012) and onward=
, ofed
> will be only backports provided from mainline, no additions, so this =
false
> betterness claim can't even be stated anymore. Now, even this "backpo=
rting
> only" new mode has to be defined - since for example, is the iscsi ca=
se...
> except for iser, ofed will not provide the iscsi modules nor tools, s=
o its
> not clear/how trivial/for someone takes (say) iser from 3.2 and backp=
ort it
> to (say) 3.6.35 in manner that it will be operable with 3.6.35 and un=
known
> version of the tools.
>

As I wrote, I like that new approach. If OFED-3.2 will match mainline
3.2 this would be great, but then you'll also have to provide the
open-iscsi user-space which you've used for testing in there.
Or/and can't you just provide a list of tools, OFA user-space etc.
which you've tested (e.g. like that BUILD_ID file in OFED)?
I really hope that this makes things better/easier for InfiniBand and
iSER users. I'm looking forward to test that.

My question was more like: "How was it tried to ensure to match kernel
and user-space code right now?" and I did not want to read the
developer's favorite "With the next release everything will be
better." ;-)

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
