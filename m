From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Wed, 21 Dec 2011 08:19:18 +0100
Message-ID: <CAFr+87tttQN0WJv5g5yHf96H6rhmeLz5dSU2uEUxwGzJ5N=j4A@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4EF02E10.4070501@mellanox.com>
	<CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
	<4EF06AF6.6080901@mellanox.com>
	<CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com>
	<4EF0F378.4080709@scalableinformatics.com>
	<CAFr+87u_J9zwO+Tq+B8DinBWcNz1wsm-kST5nKbc3Z+imKdmug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87u_J9zwO+Tq+B8DinBWcNz1wsm-kST5nKbc3Z+imKdmug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>
>> Would it help, if we provide our patches for open-iscsi and IB/iSER>
>> 2.6.32 to bring that into mainline OFED?
>
> As Or notes, OFED is providing the kernel modules more than the iscsi=
 code drop. =A0Would be better for all (cough cough) to push changes ba=
ck to the iscsi initiator maintainer (Mike Christie I think).

No, I don't think so. Mike's open-iscsi works for many kernels and he
provides libiscsi. OFA decided to make open-iscsi and ib_iser 2.6.30
based in OFED-1.5.4, but they say that they also support 3.0 in OFED.
Now, they could provide two more open-iscsi and ib_iser versions
(>=3D2.6.33, >=3D2.6.37) or just patch the version they already have. A=
PI
changes are no magic and everyone can see what they do in the mainline
if the API changes.

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
