From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Tue, 8 Jan 2019 08:07:34 +0200
Message-ID: <20190108060734.GH3632@mtr-leonro.mtl.com>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box>
 <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
 <20190108040129.GE5336@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QNDPHrPUIc00TOLW"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190108040129.GE5336@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, David Gibson <david@gibson.dropbear.id.au>, davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org
List-Id: linux-rdma@vger.kernel.org


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 07, 2019 at 09:01:29PM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 06, 2019 at 09:43:46AM +1100, Benjamin Herrenschmidt wrote:
> > On Sat, 2019-01-05 at 10:51 -0700, Jason Gunthorpe wrote:
> > >
> > > > Interesting.  I've investigated this further, though I don't have as
> > > > many new clues as I'd like.  The problem occurs reliably, at least on
> > > > one particular type of machine (a POWER8 "Garrison" with ConnectX-4).
> > > > I don't yet know if it occurs with other machines, I'm having trouble
> > > > getting access to other machines with a suitable card.  I didn't
> > > > manage to reproduce it on a different POWER8 machine with a
> > > > ConnectX-5, but I don't know if it's the difference in machine or
> > > > difference in card revision that's important.
> > >
> > > Make sure the card has the latest firmware is always good advice..
> > >
> > > > So possibilities that occur to me:
> > > >   * It's something specific about how the vfio-pci driver uses D3
> > > >     state - have you tried rebinding your device to vfio-pci?
> > > >   * It's something specific about POWER, either the kernel or the PCI
> > > >     bridge hardware
> > > >   * It's something specific about this particular type of machine
> > >
> > > Does the EEH indicate what happend to actually trigger it?
> >
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
>
> Does the card work in Gen 3 when it starts? Is there any indication of
> PCI-E link errors?
>
> Everytime or sometimes?
>
> POWER 8 firmware is good? If the link does eventually come back, is
> the POWER8's D3 resumption timeout long enough?
>
> If this doesn't lead to an obvious conclusion you'll probably need to
> connect to IBM's Mellanox support team to get more information from
> the card side.

+1, I tried to find any Mellanox-internal bugs related to your issue
and didn't find anything concrete.

Thanks

>
> Jason

--QNDPHrPUIc00TOLW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcND4mAAoJEORje4g2clinWmYQALc1t9Jj1WUm7zYVTd84U3pI
gnGibiWBO2l7MI+MYk14ZBFGEYJlskNRHIigRcOFEkzha5dy6p2JOnQyS3yBvHjO
Bl3JfvqJLZ6gq4EFqtQlvuH8TaJrkB2L3rxTmWXhbNVcxIw5SIyylhpVDgSncpde
MtP+XC7viTd15bBrYBTqVJsjr0LnIUfyPzBpDcn6vHht6iPln3pUv90T7w49/Vkm
EgDUN3bNYjyXbX07sj78Z5t8UuKv0UcQ2oGAWmA/YLGo04XZRQFcUlu4BnWT2YOf
9z4yHBx/KdBMpxtRue74mqHitFjSu9u+Na5Leq6j3davuFg000q+f3AfE8nCWqLp
DraqvSZKIhAiCFpQAcBAzEvVM0QzaKS8xqftPpnZ+509cnAwzRzlKDAO3xzyaXNN
KM56HOXCPSJPvf0uCsTr3zTLpsAnzm1QOSt3J6SW4DxvBPTsdrvro08UQErbUAVL
VieGklltiu+OeNY2DsCE6JSlxFIMOxMql3zVf5vD9GR7zzhtYA+sgVJssOzBMEY5
4yHnrg42lQ3OvjBF686S5xFHJ13hNHvd4CvdUiNvlncJS14zlEiFoGzmnk4+44bu
LSXy8AVLNDtmqk2WG+DlrCZPnm6zp1wC8mvvkvywSpbrWVEkBn2DIlfK788i1BoR
UMzhWxopBvsJGk41pwm3
=BVjQ
-----END PGP SIGNATURE-----

--QNDPHrPUIc00TOLW--
