From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Thu, 8 Sep 2016 14:34:20 -0400
Message-ID: <20160908183419.GA26402@phlsvsds.ph.intel.com>
References: <VI1PR0501MB2429992B1165DFADC6A6C35AC4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com> <20160830185548.GA9768@obsidianresearch.com> <VI1PR0501MB242974DEE5E0BF2FFE3A5DA0C4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com> <20160901163418.GA6479@obsidianresearch.com> <CAHC9VhR-u-ZXMeLkZL7y3=DJP5XaH7CxcZ=b5z67wVwhaPcUhQ@mail.gmail.com> <20160906200221.GE28416@obsidianresearch.com> <VI1PR0501MB24290102DD3246F0CA965746C4F90@VI1PR0501MB2429.eurprd05.prod.outlook.com> <20160906215548.GA27225@obsidianresearch.com> <20160908000134.GC4515@phlsvsds.ph.intel.com> <DB6PR0501MB2422EA34EED4EE35EE7B1D28C4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DB6PR0501MB2422EA34EED4EE35EE7B1D28C4FB0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Liran Liss <liranl@mellanox.com>, Paul Moore <paul@paul-moore.com>, Leon Romanovsky <leon@kernel.org>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 02:12:48PM +0000, Daniel Jurgens wrote:
> On 9/7/2016 7:01 PM, ira.weiny wrote:
> > On Tue, Sep 06, 2016 at 03:55:48PM -0600, Jason Gunthorpe wrote:
> >> On Tue, Sep 06, 2016 at 08:35:56PM +0000, Daniel Jurgens wrote:
> >>
> >>> I think to control access to a VLAN for RoCE there would have to
> >>> labels for GIDs, since that's how you select which VLAN to use.
> >> Since people are talking about using GIDs for containers adding a GID
> >> constraint for all technologies makes sense to me..
> >>
> >> But rocev1 (at least mlx4) does not use vlan ids from the GID, the
> >> vlan id is set directly in the id, so it still seems to need direct
> >> containment. I also see vlan related stuff in the iwarp providers, so
> >> they probably have a similar requirement.
> >>
> >>> required.  RDMA device handle labeling isn't granular enough for
> >>> what I'm trying to accomplish.  We want users with different levels
> >>> of permission to be able to use the same device, but restrict who
> >>> they can communicate with by isolating them to separate partitions.
> >> Sure, but maybe you should use the (device handle:pkey/vlan_id) as your
> >> labeling tuple not (Subnet Prefix, pkey)
> > Would "device handle" here specify the port?
> >
> > Ira
> 
> It would have to include the port, but idea of using a device name for this is pretty ugly.  <subnet_prefix,pkey> makes it very easy to write a policy that can be deployed widely.  <device,port,pkey/vlan> could require many different policies depending on the configuration of each machine.
> 

I agree that this seems weird.  Using the Subnet prefix seems much safer in an
IB/OPA environment.  That would be my vote.  Unfortunately I don't have enough
knowledge of the net stat to know how this would work with RoCE or iWarp.

> I've added Liran Liss, he devised the approach that's implemented.  This would be a pretty big change, with worse usability so I'd like to get his feedback. 
> 

Sounds good,
Ira

