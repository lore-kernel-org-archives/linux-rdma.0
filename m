From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 16:24:00 +0000
Message-ID: <1493828639.3901.11.camel@sandisk.com>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
         <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
         <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu>
         <20170503155316.GA14334@obsidianresearch.com>
         <1493827096.3901.4.camel@sandisk.com>
         <92010426-c898-0a56-e615-bbf6eb1c5e7e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <92010426-c898-0a56-e615-bbf6eb1c5e7e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <96A36D1A40FA7F439BE310F3DACAA55E-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-03 at 12:17 -0400, Doug Ledford wrote:
> On 5/3/2017 11:58 AM, Bart Van Assche wrote:
> > On Wed, 2017-05-03 at 09:53 -0600, Jason Gunthorpe wrote:
> > > On Wed, May 03, 2017 at 05:19:27PM +0200, Marta Rybczynska wrote:
> > >=20
> > > > > where
> > > > > 	queue->sig_limit =3D max(queue->queue_size / 2, 1);
> > > >=20
> > > > I tried to avoid that because this adds a division in the fast path=
 Bart
> > > > was unhappy about in v2.
> > >=20
> > > The compiler switches divide/multiply by powers of two into fast bit =
shifts.
> >=20
> > Hello Jason,
> >=20
> > As far as I know the compiler only does that for compile-time constants=
. In
> > this case the divisor (max(queue_size / 2, 1)) is not a compile-time co=
nstant.
>=20
> Sure it is.  The only thing that needs to be constant for the compiler
> to do the right thing is the '/ 2' part.  queue_size need not be
> constant, and the max is performed after the division.  I would fully
> expect the compiler to get this right and convert it internally to the
> equivalent bit shift, but if it didn't you could always just write it
> that way in the first place:
>=20
> queue->sig_limit =3D max(queue->queue_size >> 1, 1);

Hello Doug,

In my comment I was referring to "% max(queue_size / 2, 1)" and not to
"queue_size / 2".

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
