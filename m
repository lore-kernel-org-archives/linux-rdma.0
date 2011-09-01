From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Thu, 1 Sep 2011 12:33:38 +0200
Message-ID: <CAO+b5-p6C3RBHee2ozE=-v4nkgFNgCzZ4yv-5CZnAxqGrOp40A@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.761358826@systemfabricworks.com> <CAO+b5-r3UtgnyfhyaodHQTj_xB5d2MQkZ8kRbrpZ1hF_0W1ONw@mail.gmail.com>
 <039b01cc6866$d909e900$8b1dbb00$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <039b01cc6866$d909e900$8b1dbb00$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 1, 2011 at 7:20 AM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> From: bvanassche-HInyCGIudOg@public.gmane.org
>> On Sun, Jul 24, 2011 at 9:43 PM, =A0<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>=
 wrote:
>> > +static int rxe_query_port(struct ib_device *dev,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 port_num, struct ib_p=
ort_attr *attr)
>> > +{
>> > + =A0 struct rxe_dev *rxe =3D to_rdev(dev);
>> > + =A0 struct rxe_port *port;
>> > +
>> > + =A0 if (unlikely(port_num < 1 || port_num > rxe->num_ports)) {
>> > + =A0 =A0 =A0 =A0 =A0 pr_warn("invalid port_number %d\n", port_num=
);
>> > + =A0 =A0 =A0 =A0 =A0 goto err1;
>> > + =A0 }
>> > +
>> > + =A0 port =3D &rxe->port[port_num - 1];
>> > +
>> > + =A0 *attr =3D port->attr;
>> > + =A0 return 0;
>> > +
>> > +err1:
>> > + =A0 return -EINVAL;
>> > +}
>>
>> The pr_warn() statement in the above function looks to me like an
>> example of how pr_warn() should not be used: the message it generate=
s
>> won't allow a user to find out which subsystem generated that messag=
e.
>> I suggest either to leave out that pr_warn() statement entirely or t=
o
>> convert it into a pr_debug() statement and to use an appropriate
>> prefix, e.g. via pr_fmt().
>
> I am not familiar with pr_fmt but looked at some examples. It looks l=
ike the
> conventional usage is to define pr_fmt(fmt) as KBUILD_MODNAME ": " fm=
t which
> I suppose will output ib_rxe: or some variant. Ideally I would want r=
xe0: or
> rxe1: which is the ib device name.
>
> Do you have an opinion about best use of pr_debug, pr_warn and pr_err=
 and
> also about use of something like CONFIG_RXE_DEBUG vs just plain DEBUG=
 vs
> always on?

I should have recommended dev_warn()/dev_dbg() instead of pr_fmt()
here. These are defined in <linux/device.h>.

And if you would like to make enabling debug statements configurable,
please use the dynamic_debug infrastructure instead of introducing a
configure option like CONFIG_RXE_DEBUG. See also
http://lwn.net/Articles/434833/ for more information.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
