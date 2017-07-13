From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 22:45:14 +0000
Message-ID: <1499985913.2740.26.camel@wdc.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
         <1499968101.2740.10.camel@wdc.com>
         <20170713182018.GE11069@obsidianresearch.com>
         <1499970786.2740.17.camel@wdc.com>
         <20170713221520.GA10088@obsidianresearch.com>
         <1499985409.2740.24.camel@wdc.com>
         <20170713224137.GA24689@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713224137.GA24689-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <A964177829CEB8499C0409376C723357-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 16:41 -0600, Jason Gunthorpe wrote:
> On Thu, Jul 13, 2017 at 10:36:49PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-07-13 at 16:15 -0600, Jason Gunthorpe wrote:
> > > The one nit that I don't have an easy solution for is starting module=
s
> > > depending on the device technology, eg not starting srp or ipoib on
> > > !IB devices. The issue is that I can't think of an easy way to detect
> > > the device technology from the udev rule, at least not without a
> > > helper script or additional kernel sysfs..
> >=20
> > Are users expected to modify the kernel-boot/modules/*.conf files? I
> > expect that only a minority of the RDMA users will want to load the ib_=
srpt
> > and ib_isert kernel modules.=20
>=20
> I'd say in the same way they would be expected to modify the RedHat
> /etc/rdma/rdma.conf file. I copied the defaults from that file, which
> was to autoload target drivers.
>=20
> I agree with you, they probably don't make sense to be defaulted on.
> Ideally their respective supporting packages or kernel would ensure
> the modules autoload if someone is working with RDMA... I know nothing
> about the target infrastructure - can you see a way to do that?

Hello Jason,

Users who want to enable RDMA target functionality probably will know the
names of the kernel modules that provide such functionality. On Debian
systems the names of these kernel modules can e.g. be added to /etc/modules=
.
However, I'm not sure all distro's have an equivalent of the /etc/modules
file.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
