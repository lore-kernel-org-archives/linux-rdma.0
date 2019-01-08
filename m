From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Mon, 7 Jan 2019 21:01:29 -0700
Message-ID: <20190108040129.GE5336@ziepe.ca>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box>
 <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>, Leon Romanovsky <leon@kernel.org>, davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 06, 2019 at 09:43:46AM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2019-01-05 at 10:51 -0700, Jason Gunthorpe wrote:
> > 
> > > Interesting.  I've investigated this further, though I don't have as
> > > many new clues as I'd like.  The problem occurs reliably, at least on
> > > one particular type of machine (a POWER8 "Garrison" with ConnectX-4).
> > > I don't yet know if it occurs with other machines, I'm having trouble
> > > getting access to other machines with a suitable card.  I didn't
> > > manage to reproduce it on a different POWER8 machine with a
> > > ConnectX-5, but I don't know if it's the difference in machine or
> > > difference in card revision that's important.
> > 
> > Make sure the card has the latest firmware is always good advice..
> > 
> > > So possibilities that occur to me:
> > >   * It's something specific about how the vfio-pci driver uses D3
> > >     state - have you tried rebinding your device to vfio-pci?
> > >   * It's something specific about POWER, either the kernel or the PCI
> > >     bridge hardware
> > >   * It's something specific about this particular type of machine
> > 
> > Does the EEH indicate what happend to actually trigger it?
> 
> In a very cryptic way that requires manual parsing using non-public
> docs sadly but yes. From the look of it, it's a completion timeout.
> 
> Looks to me like we don't get a response to a config space access
> during the change of D state. I don't know if it's the write of the D3
> state itself or the read back though (it's probably detected on the
> read back or a subsequent read, but that doesn't tell me which specific
> one failed).

If it is just one card doing it (again, check you have latest
firmware) I wonder if it is a sketchy PCI-E electrical link that is
causing a long re-training cycle? Can you tell if the PCI-E link is
permanently gone or does it eventually return?

Does the card work in Gen 3 when it starts? Is there any indication of
PCI-E link errors?

Everytime or sometimes?

POWER 8 firmware is good? If the link does eventually come back, is
the POWER8's D3 resumption timeout long enough?

If this doesn't lead to an obvious conclusion you'll probably need to
connect to IBM's Mellanox support team to get more information from
the card side.

Jason
