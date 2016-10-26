From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Date: Wed, 26 Oct 2016 11:24:51 +0300
Message-ID: <a5418089-2615-8c04-aca8-50ceb43978f1@mellanox.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sbates-Rgftl6RXld5BDgjK7y7TUQ@public.gmane.org, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jim.macdonald-FgSLVYC75IpWk0Htik3J/w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/19/2016 6:51 AM, Dan Williams wrote:
> On Tue, Oct 18, 2016 at 2:42 PM, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:
>> 1. Address Translation. Suggestions have been made that in certain
>> architectures and topologies the dma_addr_t passed to the DMA master
>> in a peer-2-peer transfer will not correctly route to the IO memory
>> intended. However in our testing to date we have not seen this to be
>> an issue, even in systems with IOMMUs and PCIe switches. It is our
>> understanding that an IOMMU only maps system memory and would not
>> interfere with device memory regions.
I'm not sure that's the case. I think it works because with ZONE_DEVICE,
the iommu driver will simply treat a dma_map_page call as any other PFN,
and create a mapping as it does for any memory page.

>> (It certainly has no opportunity
>> to do so if the transfer gets routed through a switch).
It can still go through the IOMMU if you enable ACS upstream forwarding.

> There may still be platforms where peer-to-peer cycles are routed up
> through the root bridge and then back down to target device, but we
> can address that when / if it happens.
I agree.

> I wonder if we could (ab)use a
> software-defined 'pasid' as the requester id for a peer-to-peer
> mapping that needs address translation.
Why would you need that? Isn't it enough to map the peer-to-peer
addresses correctly in the iommu driver?

Haggai
