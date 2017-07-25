From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 16/21] srp_daemon: Do not use LOG_PERROR
Date: Tue, 25 Jul 2017 18:09:46 +0000
Message-ID: <1501006185.8931.7.camel@wdc.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500926429-31822-17-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501001276.8931.1.camel@wdc.com>
         <20170725171735.GC3164@obsidianresearch.com>
         <1501003688.8931.6.camel@wdc.com>
         <20170725174441.GB10905@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725174441.GB10905-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <BFB65539A09D854E90DC57BFB8C93ADE-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-25 at 11:44 -0600, Jason Gunthorpe wrote:
> On Tue, Jul 25, 2017 at 05:28:10PM +0000, Bart Van Assche wrote:
> > On Tue, 2017-07-25 at 11:17 -0600, Jason Gunthorpe wrote:
> > > On Tue, Jul 25, 2017 at 04:47:59PM +0000, Bart Van Assche wrote:
> > > > LOG_PERROR is very convenient when debugging srp_daemon. How about =
using
> > > > the result of isatty(STDERR_FILENO) to decide whether or not to ena=
ble
> > > > LOG_PERROR?
> > >=20
> > > How about a --debug option that sets
> > >=20
> > >   s_log_dest =3D log_to_stderr;
> >=20
> > Sorry but I prefer that LOG_PERROR is retained when srp_daemon is start=
ed in
> > another way than by systemd. How about adding StandardError=3Dnull to t=
he
> > srp_daemon unit file?
>=20
> No, then emergency prints from libraries are lost forever eg glibc
> malloc corruption prints.
>=20
> How about a --systemd option? I think we are going to want that anyhow
> down the road.

Hello Jason,

That sounds fine to me.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
