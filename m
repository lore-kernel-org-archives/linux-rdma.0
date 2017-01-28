From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH] IB/cma: Fix reversed test
Date: Sat, 28 Jan 2017 12:47:10 +0000
Message-ID: <D2B4EC94-0480-4DA1-8945-3CA3AC7485ED@mellanox.com>
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
 <1485552696.13218.0.camel@sandisk.com> <1485561952.2432.31.camel@redhat.com>
 <20170128065927.GP4149@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170128065927.GP4149@mwanda>
Content-Language: en-US
Content-ID: <38FDCE8C1DA34C4DAA76ED29707EBE10@Mellanox365.onmicrosoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

We have message sniffer that checks for unwanted prints after each test..

Sent from my iPhone

> On Jan 28, 2017, at 8:59 AM, Dan Carpenter <dan.carpenter@oracle.com> wro=
te:
>=20
> On Fri, Jan 27, 2017 at 07:05:52PM -0500, Doug Ledford wrote:
>>> Do you think this patch needs "Fixes:" and "Cc: stable" tags?
>>=20
>> It does not.
>=20
> We always should have fixes tags.
>=20
> When I'm reviewing, I try to look up the patch which introduced the bug
> so I can figure out what the intent was.  Having a Fixes tag speeds up
> my work.
>=20
> Looking at how the bug was introduced sometimes helps to prevent bugs
> from recurring in the future.  For example, I've seen several bugs
> introduced because the right people weren't on the CC to review it.  For
> this particular bug it feels like probably this bug could have been
> detected with more testing.  I doubt it would have made it into a
> released kernel.
>=20
> Also it let's you CC the original authors and hopefully they can Ack it.
>=20
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
