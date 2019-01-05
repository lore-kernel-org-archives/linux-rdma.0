From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Sat, 5 Jan 2019 10:51:16 -0700
Message-ID: <20190105175116.GB14238@ziepe.ca>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190104034401.GA2801@umbus.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Leon Romanovsky <leon@kernel.org>, davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, benh@kernel.crashing.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 04, 2019 at 02:44:01PM +1100, David Gibson wrote:
> On Thu, Dec 06, 2018 at 08:45:09AM +0200, Leon Romanovsky wrote:
> > On Thu, Dec 06, 2018 at 03:19:51PM +1100, David Gibson wrote:
> > > Mellanox ConnectX-5 IB cards (MT27800) seem to cause a call trace when
> > > unbound from their regular driver and attached to vfio-pci in order to pass
> > > them through to a guest.
> > >
> > > This goes away if the disable_idle_d3 option is used, so it looks like a
> > > problem with the hardware handling D3 state.  To fix that more permanently,
> > > use a device quirk to disable D3 state for these devices.
> > >
> > > We do this by renaming the existing quirk_no_ata_d3() more generally and
> > > attaching it to the ConnectX-[45] devices (0x15b3:0x1013).
> > >
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > >  drivers/pci/quirks.c | 17 +++++++++++------
> > >  1 file changed, 11 insertions(+), 6 deletions(-)
> > >
> > 
> > Hi David,
> > 
> > Thank for your patch,
> > 
> > I would like to reproduce the calltrace before moving forward,
> > but have trouble to reproduce the original issue.
> > 
> > I'm working with vfio-pci and CX-4/5 cards on daily basis,
> > tried manually enter into D3 state now, and it worked for me.
> 
> Interesting.  I've investigated this further, though I don't have as
> many new clues as I'd like.  The problem occurs reliably, at least on
> one particular type of machine (a POWER8 "Garrison" with ConnectX-4).
> I don't yet know if it occurs with other machines, I'm having trouble
> getting access to other machines with a suitable card.  I didn't
> manage to reproduce it on a different POWER8 machine with a
> ConnectX-5, but I don't know if it's the difference in machine or
> difference in card revision that's important.

Make sure the card has the latest firmware is always good advice..

> So possibilities that occur to me:
>   * It's something specific about how the vfio-pci driver uses D3
>     state - have you tried rebinding your device to vfio-pci?
>   * It's something specific about POWER, either the kernel or the PCI
>     bridge hardware
>   * It's something specific about this particular type of machine

Does the EEH indicate what happend to actually trigger it?

Jason
