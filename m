From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Wed, 14 Sep 2016 21:52:57 -0400
Message-ID: <20160915015250.GA13038@phlsvsds.ph.intel.com>
References: <20160901163418.GA6479@obsidianresearch.com> <CAHC9VhR-u-ZXMeLkZL7y3=DJP5XaH7CxcZ=b5z67wVwhaPcUhQ@mail.gmail.com> <20160906200221.GE28416@obsidianresearch.com> <VI1PR0501MB24290102DD3246F0CA965746C4F90@VI1PR0501MB2429.eurprd05.prod.outlook.com> <20160906215548.GA27225@obsidianresearch.com> <20160908000134.GC4515@phlsvsds.ph.intel.com> <DB6PR0501MB2422EA34EED4EE35EE7B1D28C4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com> <20160908161948.GA21614@obsidianresearch.com> <20160908191457.GB26402@phlsvsds.ph.intel.com> <20160908193512.GB1868@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160908193512.GB1868@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Daniel Jurgens <danielj@mellanox.com>, Liran Liss <liranl@mellanox.com>, Paul Moore <paul@paul-moore.com>, Leon Romanovsky <leon@kernel.org>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 01:35:12PM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 08, 2016 at 03:14:57PM -0400, ira.weiny wrote:
> > On Thu, Sep 08, 2016 at 10:19:48AM -0600, Jason Gunthorpe wrote:
> > > On Thu, Sep 08, 2016 at 02:12:48PM +0000, Daniel Jurgens wrote:
> > > 
> > > > It would have to include the port, but idea of using a device name
> > > > for this is pretty ugly.  <subnet_prefix,pkey> makes it very easy to
> > > > write a policy that can be deployed widely.  <device,port,pkey/vlan>
> > > > could require many different policies depending on the configuration
> > > > of each machine.
> > > 
> > > What does net do? Should we have a way to unformly label the rdma ports?
> > 
> > Uniformly label them on the local node or across a cluster?
> 
> However we want. If the argument comes down to 'we stupidly choose to
> call our devices mlx5_0', then lets allow the admin rename that to
> 'rdma0' and a cluster wide config file will apply uniformly. This
> approach applies to all configuration related to rdma, not just
> SELinux.

I'm not sure I like the idea of trying to use "rdmaX".  It seems like this has
been a confusion point for things like drives and NICs in the past.  (Where the
order of device discovery is an issue.)

But I guess with more network types coming online we may have to have something
generic.

That said in the netdev world not all things are called eth0.  Some are called
wlanX, etc...

Does anyone know why do they have names based on network type?

So I could see where having a global "name" for a subnet would be nice...  But
isn't something like that called a domain name?  Does SELinux work in
conjunction with domain names in the netdev stack?

This may be a bit off topic but has anyone thought about adding GID specific
DNS record types?

I have experimented with just putting a GID in an IPv6 record and things I
tried work quite well.  Should we have a method to map a domain name to a
subnet prefix?

If the domain name mapped to a subnet prefix it would imply a set of port GIDs
on IB/OPA devices and if it mapped to an IPv4/v6 subnet it would be
iwarp/roce/usnic.

For this series and others the kernel could continue to use the correct
"subnet" information and user space could translate as appropriate?

Would this series work looking at a "subnet prefix" of an IPv6 address in RoCE?

Ira

