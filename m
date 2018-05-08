From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all
 devices behind switches
Date: Tue, 8 May 2018 14:13:31 -0600
Message-ID: <20180508141331.7cd737cb@w520.home>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <5fc9b1c1-9208-06cc-0ec5-1f54c2520494-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christian =?UTF-8?B?S8O2bmln?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 8 May 2018 13:45:50 -0600
Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:

> On 08/05/18 01:34 PM, Alex Williamson wrote:
> > They are not so unrelated, see the ACS Direct Translated P2P
> > capability, which in fact must be implemented by switch downstream
> > ports implementing ACS and works specifically with ATS.  This appears to
> > be the way the PCI SIG would intend for P2P to occur within an IOMMU
> > managed topology, routing pre-translated DMA directly between peer
> > devices while requiring non-translated requests to bounce through the
> > IOMMU.  Really, what's the value of having an I/O virtual address space
> > provided by an IOMMU if we're going to allow physical DMA between
> > downstream devices, couldn't we just turn off the IOMMU altogether?  Of
> > course ATS is not without holes itself, basically that we trust the
> > endpoint's implementation of ATS implicitly.  Thanks,  
> 
> I agree that this is what the SIG intends, but I don't think hardware
> fully supports this methodology yet. The Direct Translated capability
> just requires switches to forward packets that have the AT request type
> set. It does not require them to do the translation or to support ATS
> such that P2P requests can be translated by the IOMMU. I expect this is
> so that an downstream device can implement ATS and not get messed up by
> an upstream switch that doesn't support it.

Well, I'm a bit confused, this patch series is specifically disabling
ACS on switches, but per the spec downstream switch ports implementing
ACS MUST implement direct translated P2P.  So it seems the only
potential gap here is the endpoint, which must support ATS or else
there's nothing for direct translated P2P to do.  The switch port plays
no part in the actual translation of the request, ATS on the endpoint
has already cached the translation and is now attempting to use it.
For the switch port, this only becomes a routing decision, the request
is already translated, therefore ACS RR and EC can be ignored to
perform "normal" (direct) routing, as if ACS were not present.  It would
be a shame to go to all the trouble of creating this no-ACS mode to find
out the target hardware supports ATS and should have simply used it, or
we should have disabled the IOMMU altogether, which leaves ACS disabled.
Thanks,

Alex
