From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Thu, 1 Mar 2018 16:25:42 -0500
Message-ID: <20180301212541.GD6742@redhat.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
 <1519936195.4592.18.camel@au1.ibm.com>
 <20180301205548.GA6742@redhat.com>
 <a512edf9-2d96-9229-fe60-e0ea60b3922b@deltatee.com>
 <20180301211036.GB6742@redhat.com>
 <8ed955f8-55c9-a2bd-1d58-90bf1dcfa055@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8ed955f8-55c9-a2bd-1d58-90bf1dcfa055-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver OHalloran <oliveroh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, Benjamin Herrenschmidt <benh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 01, 2018 at 02:15:01PM -0700, Logan Gunthorpe wrote:
> =

> =

> On 01/03/18 02:10 PM, Jerome Glisse wrote:
> > It seems people miss-understand HMM :( you do not have to use all of
> > its features. If all you care about is having struct page then just
> > use that for instance in your case only use those following 3 functions:
> > =

> > hmm_devmem_add() or hmm_devmem_add_resource() and hmm_devmem_remove()
> > for cleanup.
> =

> To what benefit over just using devm_memremap_pages()? If I'm using the h=
mm
> interface and disabling all the features, I don't see the point. We've al=
so
> cleaned up the devm_memremap_pages() interface to be more usefully generic
> in such a way that I'd hope HMM starts using it too and gets rid of the c=
ode
> duplication.
> =


The first HMM variant find a hole and do not require a resource as input
parameter. Beside that internaly for PCIE device memory devm_memremap_pages=
()
does not do the right thing last time i check it always create a linear
mapping of the range ie HMM call add_pages() while devm_memremap_pages()
call arch_add_memory()

When i upstreamed HMM, Dan didn't want me to touch devm_memremap_pages()
to match my need. I am more than happy to modify devm_memremap_pages() to
also handle HMM needs.

Note that the intention of HMM is to be a middle layer between low level
infrastructure and device driver. Idea is that such impedance layer should
make it easier down the road to change how thing are handled down below
without having to touch many device driver.

Cheers,
J=E9r=F4me
