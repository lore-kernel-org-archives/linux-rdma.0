From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Thu, 8 Sep 2016 13:32:35 -0600
Message-ID: <20160908193235.GA1868@obsidianresearch.com>
References: <CAHC9VhR-u-ZXMeLkZL7y3=DJP5XaH7CxcZ=b5z67wVwhaPcUhQ@mail.gmail.com>
 <20160906200221.GE28416@obsidianresearch.com>
 <VI1PR0501MB24290102DD3246F0CA965746C4F90@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160906215548.GA27225@obsidianresearch.com>
 <20160908000134.GC4515@phlsvsds.ph.intel.com>
 <DB6PR0501MB2422EA34EED4EE35EE7B1D28C4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
 <20160908161948.GA21614@obsidianresearch.com>
 <DB6PR0501MB24227FF5BE230C826615111FC4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
 <20160908183611.GD21614@obsidianresearch.com>
 <VI1PR0501MB2429AAD28BD78334C1FE0E5AC4FB0@VI1PR0501MB2429.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB2429AAD28BD78334C1FE0E5AC4FB0@VI1PR0501MB2429.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, Liran Liss <liranl@mellanox.com>, Paul Moore <paul@paul-moore.com>, Leon Romanovsky <leon@kernel.org>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 06:59:13PM +0000, Daniel Jurgens wrote:

> >> Net has variety of means of enforcement, one of which is controlling
> >> access to ports <tcp/udp,port number>, which is the most like what
> >> I'm doing here.
> > No, the analog the tcp/udp,port number is <ib, service_id> 

> I should have been clearer here.  From the SELinux perspective this
> scheme is very similar to net ports.

It really isn't. net ports and service_ids are global things that do
not need machine-specific customizations while subnet prefix or device
name/port are both machine-local information.

> >> with this aside from it being where the policy is stored before
> >> being loaded.  What is this dynamic injector you are talking about?
> > The container projects (eg docker) somehow setup selinux on the
> > fly for each container. I'm not sure how.

> SELinux policy is modular and can be changed or updated while
> running, I'm not very familiar with docker so I'm not sure what they
> do regarding SELinux.  I'm also not sure it's relevant to the issues
> at hand.

docker and the like would seem to be the #1 user of this kind of
feature, it goes hand in hand with the ipoib namespace work that does
a similar (but less complete thing). This is a great way to create a
container and constrain it to a single pkey/vlan/ipoib device, which
would be the basic capability needed to sensibly rdma and containers
together.

This is why thinking about how to fully support the pkey/vlan concept
across all the rdma drivers seems so critical.

I'm surprised this isn't your use case. Again, I wish you'd think more
broadly before designing new uapis. selinux enabling the rdma
subsystem is a whole new uapi aspect for rdma that we have to live
with forever.

> >> called mlx5_0, the another mlx4_0 and you want to grant access to
> >> system administrators.
> > So do this in userspace? Why should the kernel do the translation?

> I'm still not clear on what translation you are talking about.

Converting the subnet prefix to a list of physical ports.

Jason
