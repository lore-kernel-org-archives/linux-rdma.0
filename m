From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Mon, 15 Aug 2011 16:58:44 +0200
Message-ID: <CAO+b5-rsofKNdcjCjBdj1fH7i3DpbHhFajhk0QfNK4DE7nj_SQ@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.761358826@systemfabricworks.com> <CAO+b5-pRQXn08aVOPxeQBzrYXAV+3zD+HZdCCmPTTwBCCzY=ag@mail.gmail.com>
 <20110815144503.GA12014@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110815144503.GA12014-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 15, 2011 at 4:45 PM, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org> wrote:
> On Mon, Aug 15, 2011 at 04:33:14PM +0200, Bart Van Assche wrote:
>> On Sun, Jul 24, 2011 at 9:43 PM, =A0<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>=
 wrote:
>> > + =A0 for (i =3D 0; i < ARRAY_SIZE(rxe_dev_attributes); ++i) {
>> > + =A0 =A0 =A0 =A0 =A0 err =3D device_create_file(&dev->dev, rxe_de=
v_attributes[i]);
>> > + =A0 =A0 =A0 =A0 =A0 if (err) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_warn("device_create_file =
failed, "
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "i =3D %d, e=
rr =3D %d\n", i, err);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err2;
>> > + =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 }
>
> How about using the api functions that are already present in the ker=
nel
> to do the exact thing you are asking for here?
>
> And no one should EVER be doing a loop like the above mentioned one, =
so
> yes, it is their fault :)

Hello Greg,

Thanks for replying, but It seems like I have missed something. I have
found a function called device_add_attributes() in drivers/base/core.c
but it's declared static. Does your reply mean that there exists an
exported function that allows to add multiple device attributes at
once without defining a new device class ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
