From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Wed, 21 Dec 2011 12:34:36 +0100
Message-ID: <CAFr+87tzRffgTsM=M8YKJQLSkFaOX7+=czf5L5L7K0-UiJJFxg@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4EF02E10.4070501@mellanox.com>
	<CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
	<4EF06AF6.6080901@mellanox.com>
	<CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com>
	<CAJZOPZLweaD19nS94Enh1rxXwRt+bHr=cPMxdg2zcCP_d4bzfw@mail.gmail.com>
	<CAFr+87vvqx=yTDBKVqdDpfEOnbewXMUaahgO=0yqdY=+RV6NsA@mail.gmail.com>
	<4EF1C15B.1000907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EF1C15B.1000907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2011/12/21 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> I tested the upstream kernel iser against the upstream iscsi tools =A0=
from
> git://github.com/mikechristie/open-iscsi
> (commit 4323e342d2c9fb8ed7233ce855001c189ec55b23), it works
>

To bring this to an end: I believe you. Most likely I had that much
trouble because of the OFED-1.4 user-space which did not match the
kernel code.

As you don't answer my question how I can find out what's the matching
user-space for a given upstream kernel - I will just use what I have
now (should work like on RedHat) and will be looking forward to the
new OFED release approach.

Thanks for taking the time to make things clear to me.

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
