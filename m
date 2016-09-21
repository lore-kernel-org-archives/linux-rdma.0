From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Wed, 21 Sep 2016 12:16:27 -0400
Message-ID: <20160921161626.GA27837@phlsvsds.ph.intel.com>
References: <20160906200221.GE28416@obsidianresearch.com> <VI1PR0501MB24290102DD3246F0CA965746C4F90@VI1PR0501MB2429.eurprd05.prod.outlook.com> <20160906215548.GA27225@obsidianresearch.com> <20160908000134.GC4515@phlsvsds.ph.intel.com> <DB6PR0501MB2422EA34EED4EE35EE7B1D28C4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com> <20160908161948.GA21614@obsidianresearch.com> <DB6PR0501MB24227FF5BE230C826615111FC4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com> <20160908183611.GD21614@obsidianresearch.com> <VI1PR0501MB2429AAD28BD78334C1FE0E5AC4FB0@VI1PR0501MB2429.eurprd05.prod.outlook.com> <20160908193235.GA1868@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160908193235.GA1868@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Daniel Jurgens <danielj@mellanox.com>, Liran Liss <liranl@mellanox.com>, Paul Moore <paul@paul-moore.com>, Leon Romanovsky <leon@kernel.org>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 01:32:35PM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 08, 2016 at 06:59:13PM +0000, Daniel Jurgens wrote:
> 
> > >> Net has variety of means of enforcement, one of which is controlling
> > >> access to ports <tcp/udp,port number>, which is the most like what
> > >> I'm doing here.
> > > No, the analog the tcp/udp,port number is <ib, service_id> 
> 
> > I should have been clearer here.  From the SELinux perspective this
> > scheme is very similar to net ports.
> 
> It really isn't. net ports and service_ids are global things that do
> not need machine-specific customizations while subnet prefix or device
> name/port are both machine-local information.

I agree that service_ids are more analogous to net ports.

However, subnet prefixes are _not_ machine-local.  They are controlled by the
Admin of the fabric by a central entity (the SM).  This is more helpful than in
ethernet where if you configure the wrong port with the wrong subnet things
just don't work.  In IB I can physically plug my network into any IB port I
want and the system is _told_ which "subnet" that port belongs to.  (OPA is the
same way.)

So for IB/OPA a subnet prefix is a really good way to ID which network (subnet)
you want to use.  Unfortunately, I'm not sure how to translate that to
iwarp/roce seamlessly except to have some concept of "domain" as I mentioned in
my other email.

Ira

