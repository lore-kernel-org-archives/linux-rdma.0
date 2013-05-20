From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 21:38:18 +0200
Message-ID: <519A7BAA.1080008@profitbricks.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com> <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com> <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com> <519A01DD.6080906@mellanox.com> <CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g@mail.gmail.com> <519A1C60.4060005@mellanox.com> <CAD+HZHUKU3qq_WbaoW8NfwkoMQWQKeVS1GTGXxBRUEJOridEyg@mail.gmail.com> <519A275B.9070400@mellanox.com> <519A34F9.3080700@profitbricks.com> <CAJZOPZKQF-qWLKAtuh8tJvPeMmWJTsXqG5P_0ELBs3EKYDh4sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKQF-qWLKAtuh8tJvPeMmWJTsXqG5P_0ELBs3EKYDh4sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2013=E5=B9=B405=E6=9C=8820=E6=97=A5 21:00, Or Gerlitz wrote:
> On Mon, May 20, 2013 at 5:36 PM, Jack Wang <jinpu.wang@profitbricks.c=
om> wrote:
>> Sorry for confusion. Current list corruption is gone in my prelimina=
ry test, after I changed
>> list_del to list_del_init as Or suggested.
>> As Or asked for the original bug, so I just want to show him the who=
le story.
>=20
> I am still not clear if  the bug you saw in your production
> environment is gone with the list_del_init patch applied, please
> clarify.
>=20
> Or.
>=20
The bug in our production environment is introduced in our backport
about ipoib fixes from mainline, and when we hit that bug we reverted
back to old kernel without the backport patch, and the bug didn't happe=
n
for now.

This list_del_init patch do fix list corruption warning, but it's not
the one we hit in production, the list corruption is reproduced in our
test setup with bug injection patch && iperf -P 50 && mode switch.

Is this clear for you now?

Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
