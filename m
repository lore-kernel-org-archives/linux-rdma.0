From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Mon, 26 Mar 2018 13:35:02 -0600
Message-ID: <20180326193502.GI15530@mellanox.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <20180326121138.00005e30@huawei.com>
 <20180326164129.GF15530@mellanox.com>
 <6ead7f19-c0e5-5584-2518-1e1889a007e4@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6ead7f19-c0e5-5584-2518-1e1889a007e4-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eric Wehage <Eric.Wehage-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 26, 2018 at 11:30:38AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 26/03/18 10:41 AM, Jason Gunthorpe wrote:
> > On Mon, Mar 26, 2018 at 12:11:38PM +0100, Jonathan Cameron wrote:
> >> On Tue, 13 Mar 2018 10:43:55 -0600
> >> Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
> >>
> >>> On 12/03/18 09:28 PM, Sinan Kaya wrote:
> >>>> On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> >>>> Regarding the switch business, It is amazing how much trouble you went into
> >>>> limit this functionality into very specific hardware.
> >>>>
> >>>> I thought that we reached to an agreement that code would not impose
> >>>> any limits on what user wants.
> >>>>
> >>>> What happened to all the emails we exchanged?  
> >>>
> >>> It turns out that root ports that support P2P are far less common than 
> >>> anyone thought. So it will likely have to be a white list.
> >>
> >> This came as a bit of a surprise to our PCIe architect.
> > 
> > I don't think it is a hardware problem.
> 
> The latest and greatest Power9 CPUs still explicitly do not support
> this.

I think this is another case of the HW can do it but the SW support is
missing. IOMMU configuration and maybe firmware too, for instance.

If I recall I saw a presentation that Coral was expected to use P2P
between the network and GPU.

> And, if I recall correctly, the ARM64 device we played with did
> not either -- but I suspect that will differ depending on vendor.

Wouldn't surprise me at all to see broken implementations in
ARM64.. But even there it needs IOMMU enablement to work at all if I
recall.

Bascially, this is probably not a HW problem that needs a HW bit, but
a OS/firmware problem to do all the enablement..

Jason
