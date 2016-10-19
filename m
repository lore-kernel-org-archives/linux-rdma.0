From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] memremap.c : Add support for ZONE_DEVICE IO memory
 with struct pages.
Date: Wed, 19 Oct 2016 13:01:06 -0700
Message-ID: <CAPcyv4iTFpZ1b74Wf+qWe9=Annp+-OCy+pFMS7Fo7quUFwhM4g@mail.gmail.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <1476826937-20665-2-git-send-email-sbates@raithlin.com>
 <CAPcyv4gmiqMNb+Q88Mf-9fFb4z4uAfWbbEWrv42OBH8838SSPQ@mail.gmail.com>
 <20161019184028.GB16550@cgy1-donard.priv.deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20161019184028.GB16550-Fu/sLxIRQ7hz7qcAzjI/l7KmtST0zaCzZeezCHUQhQ4@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, sbates-Rgftl6RXld5BDgjK7y7TUQ@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jim.macdonald-FgSLVYC75IpWk0Htik3J/w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 11:40 AM, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:
> On Wed, Oct 19, 2016 at 10:50:25AM -0700, Dan Williams wrote:
>> On Tue, Oct 18, 2016 at 2:42 PM, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:
>> > From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
>> >
>> > We build on recent work that adds memory regions owned by a device
>> > driver (ZONE_DEVICE) [1] and to add struct page support for these new
>> > regions of memory [2].
>> >
>> > 1. Add an extra flags argument into dev_memremap_pages to take in a
>> > MEMREMAP_XX argument. We update the existing calls to this function to
>> > reflect the change.
>> >
>> > 2. For completeness, we add MEMREMAP_WT support to the memremap;
>> > however we have no actual need for this functionality.
>> >
>> > 3. We add the static functions, add_zone_device_pages and
>> > remove_zone_device pages. These are similar to arch_add_memory except
>> > they don't create the memory mapping. We don't believe these need to be
>> > made arch specific, but are open to other opinions.
>> >
>> > 4. dev_memremap_pages and devm_memremap_pages_release are updated to
>> > treat IO memory slightly differently. For IO memory we use a combination
>> > of the appropriate io_remap function and the zone_device pages functions
>> > created above. A flags variable and kaddr pointer are added to struct
>> > page_mem to facilitate this for the release function. We also set up
>> > the page attribute tables for the mapped region correctly based on the
>> > desired mapping.
>> >
>>
>> This description says "what" is being done, but not "why".
>
> Hi Dan
>
> We discuss the motivation in the cover letter.
>
>>
>> In the cover letter, "[PATCH 0/3] iopmem : A block device for PCIe
>> memory",  it mentions that the lack of I/O coherency is a known issue
>> and users of this functionality need to be cognizant of the pitfalls.
>> If that is the case why do we need support for different cpu mapping
>> types than the default write-back cache setting?  It's up to the
>> application to handle cache cpu flushing similar to what we require of
>> device-dax users in the persistent memory case.
>
> Some of the iopmem hardware we have tested has certain alignment
> restrictions on BAR accesses. At the very least we require write
> combine mappings for these. We then felt it appropriate to add the
> other mappings for the sake of completeness.

If the device can support write-combine then it can support bursts, so
I wonder why it couldn't support read bursts for cache fills...
