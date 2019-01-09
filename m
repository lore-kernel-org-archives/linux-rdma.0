From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Wed, 09 Jan 2019 16:09:02 +1100
Message-ID: <012d24d58a542ed44c8af9f517f1bd61ab912037.camel@kernel.crashing.org>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box> <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
 <20190108040129.GE5336@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190108040129.GE5336@ziepe.ca>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alexey Kardashevskiy <aik@au1.ibm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sbest@redhat.com, saeedm@mellanox.com, alex.williamson@redhat.com, paulus@samba.org, linux-pci@vger.kernel.org, bhelgaas@google.com, ogerlitz@mellanox.com, David Gibson <david@gibson.dropbear.id.au>, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-01-07 at 21:01 -0700, Jason Gunthorpe wrote:
> 
> > In a very cryptic way that requires manual parsing using non-public
> > docs sadly but yes. From the look of it, it's a completion timeout.
> > 
> > Looks to me like we don't get a response to a config space access
> > during the change of D state. I don't know if it's the write of the D3
> > state itself or the read back though (it's probably detected on the
> > read back or a subsequent read, but that doesn't tell me which specific
> > one failed).
> 
> If it is just one card doing it (again, check you have latest
> firmware) I wonder if it is a sketchy PCI-E electrical link that is
> causing a long re-training cycle? Can you tell if the PCI-E link is
> permanently gone or does it eventually return?

No, it's 100% reproducable on systems with that specific card model,
not card instance, and maybe different systems/cards as well, I'll let
David & Alexey comment further on that.

> Does the card work in Gen 3 when it starts? Is there any indication of
> PCI-E link errors?

Nope.

> Everytime or sometimes?
> 
> POWER 8 firmware is good? If the link does eventually come back, is
> the POWER8's D3 resumption timeout long enough?
> 
> If this doesn't lead to an obvious conclusion you'll probably need to
> connect to IBM's Mellanox support team to get more information from
> the card side.

We are IBM :-) So far, it seems to be that the card is doing something
not quite right, but we don't know what. We might need to engage
Mellanox themselves.

Cheers,
Ben.
