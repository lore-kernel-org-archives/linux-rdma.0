From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 09:35:04 -0800
Message-ID: <20190207173504.GD29531@iweiny-DESK2.sc.intel.com>
References: <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 04:55:37PM +0000, Christopher Lameter wrote:
> One approach that may be a clean way to solve this:
> 
> 1. Long term GUP usage requires the virtual mapping to the pages be fixed
>    for the duration of the GUP Map. There never has been a way to break
>    the pinnning and thus this needs to be preserved.

How does this fit in with the changes John is making?

> 
> 2. Page Cache Long term pins are not allowed since regular filesystems
>    depend on COW and other tricks which are incompatible with a long term
>    pin.

Unless the hardware supports ODP or equivalent functionality.  Right?

> 
> 3. Filesystems that allow bypass of the page cache (like XFS / DAX) will
>    provide the virtual mapping when the PIN is done and DO NO OPERATIONS
>    on the longterm pinned range until the long term pin is removed.
>    Hardware may do its job (like for persistent memory) but no data
>    consistency on the NVDIMM medium is guaranteed until the long term pin
>    is removed  and the filesystems regains control over the area.

I believe Dan attempted something like this and it became pretty difficult.

> 
> 4. Long term pin means that the mapped sections are an actively used part
>    of the file (like a filesystem write) and it cannot be truncated for
>    the duration of the pin. It can be thought of as if the truncate is
>    immediate followed by a write extending the file again. The mapping
>    by RDMA implies after all that remote writes can occur at anytime
>    within the area pinned long term.
>

This is a very interesting idea.  I've never quite thought of it that way.

That would be essentially like failing the truncate but without actually
failing it...  sneaky.  ;-)

What if user space then writes to the end of the file?  Does that write end
up at the point they truncated to or off the end of the mmaped area (old
length)?

I can see the behavior being defined either way.  But one interferes with the
RDMA data and the other does not.  Not sure which is easier for the FS to
handle either.

Ira
