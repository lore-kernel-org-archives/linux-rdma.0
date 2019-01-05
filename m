From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Sun, 06 Jan 2019 09:43:46 +1100
Message-ID: <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
         <20181206064509.GM15544@mtr-leonro.mtl.com>
         <20190104034401.GA2801@umbus.fritz.box> <20190105175116.GB14238@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190105175116.GB14238@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, David Gibson <david@gibson.dropbear.id.au>
Cc: Leon Romanovsky <leon@kernel.org>, davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2019-01-05 at 10:51 -0700, Jason Gunthorpe wrote:
> 
> > Interesting.  I've investigated this further, though I don't have as
> > many new clues as I'd like.  The problem occurs reliably, at least on
> > one particular type of machine (a POWER8 "Garrison" with ConnectX-4).
> > I don't yet know if it occurs with other machines, I'm having trouble
> > getting access to other machines with a suitable card.  I didn't
> > manage to reproduce it on a different POWER8 machine with a
> > ConnectX-5, but I don't know if it's the difference in machine or
> > difference in card revision that's important.
> 
> Make sure the card has the latest firmware is always good advice..
> 
> > So possibilities that occur to me:
> >   * It's something specific about how the vfio-pci driver uses D3
> >     state - have you tried rebinding your device to vfio-pci?
> >   * It's something specific about POWER, either the kernel or the PCI
> >     bridge hardware
> >   * It's something specific about this particular type of machine
> 
> Does the EEH indicate what happend to actually trigger it?

In a very cryptic way that requires manual parsing using non-public
docs sadly but yes. From the look of it, it's a completion timeout.

Looks to me like we don't get a response to a config space access
during the change of D state. I don't know if it's the write of the D3
state itself or the read back though (it's probably detected on the
read back or a subsequent read, but that doesn't tell me which specific
one failed).

Some extra logging in OPAL might help pin that down by checking the InA
error state in the config accessor after the config write (and polling
on it for a while as from a CPU perspective I don't knw if the write is
synchronous, probably not).

Cheers,
Ben.
