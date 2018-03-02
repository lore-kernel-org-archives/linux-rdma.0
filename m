From: "Kani, Toshi" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Fri, 2 Mar 2018 16:22:24 +0000
Message-ID: <1520010446.2693.19.camel@hpe.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <1519936815.4592.25.camel@au1.ibm.com> <20180301205315.GJ19007@ziepe.ca>
 <1519942012.4592.31.camel@au1.ibm.com>
 <CA+55aFy-oAiFJ3WDx4giR1enj65y-YJnZZhY6geFw0ygFyKXfQ@mail.gmail.com>
 <1519943658.4592.34.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1519943658.4592.34.camel-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Content-Language: en-US
Content-ID: <A740CC14662A0948A822E31824F31125-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org" <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "oliveroh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org" <oliveroh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2018-03-02 at 09:34 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-01 at 14:31 -0800, Linus Torvalds wrote:
> > On Thu, Mar 1, 2018 at 2:06 PM, Benjamin Herrenschmidt <benh-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org> wrote:
> > > 
> > > Could be that x86 has the smarts to do the right thing, still trying to
> > > untangle the code :-)
> > 
> > Afaik, x86 will not cache PCI unless the system is misconfigured, and
> > even then it's more likely to just raise a machine check exception
> > than cache things.
> > 
> > The last-level cache is going to do fills and spills directly to the
> > memory controller, not to the PCIe side of things.
> > 
> > (I guess you *can* do things differently, and I wouldn't be surprised
> > if some people inside Intel did try to do things differently with
> > trying nvram over PCIe, but in general I think the above is true)
> > 
> > You won't find it in the kernel code either. It's in hardware with
> > firmware configuration of what addresses are mapped to the memory
> > controllers (and _how_ they are mapped) and which are not.
> 
> Ah thanks ! Thanks explains. We can fix that on ppc64 in our linear
> mapping code by checking the address vs. memblocks to chose the right
> page table attributes.

FWIW, this thing is called MTRRs on x86, which are initialized by BIOS.
These registers effectively overwrite page table setups.  Intel SDM
defines the effect as follows.  'PAT Entry Value' is the page table
setup.

MTRR Memory Type  PAT Entry Value  Effective Memory Type
--------------------------------------------------------
UC                UC               UC
UC                WC               WC
UC                WT               UC
UC                WB               UC
UC                WP               UC 

On my system, BIOS sets MTRRs to cover the entire MMIO ranges with UC.
Other BIOSes may simply set the MTRR default type to UC, i.e. uncovered
ranges become UC.

# cat /proc/mtrr
 :
reg01: base=0xc0000000000 (12582912MB), size=2097152MB, count=1:
uncachable
 :

# cat /proc/iomem | grep 'PCI Bus'
 :
c0000000000-c3fffffffff : PCI Bus 0000:00
c4000000000-c7fffffffff : PCI Bus 0000:11
c8000000000-cbfffffffff : PCI Bus 0000:36
cc000000000-cffffffffff : PCI Bus 0000:5b
d0000000000-d3fffffffff : PCI Bus 0000:80
d4000000000-d7fffffffff : PCI Bus 0000:85
d8000000000-dbfffffffff : PCI Bus 0000:ae
dc000000000-dffffffffff : PCI Bus 0000:d7

-Toshi
