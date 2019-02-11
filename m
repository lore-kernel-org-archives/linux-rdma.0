From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Mon, 11 Feb 2019 13:22:11 -0800
Message-ID: <fb507b56-7f8f-cf2c-285c-bae3b2d72c4f@nvidia.com>
References: <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard> <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 2/11/19 10:19 AM, Ira Weiny wrote:
> On Mon, Feb 11, 2019 at 11:06:54AM -0700, Jason Gunthorpe wrote:
>> On Mon, Feb 11, 2019 at 09:22:58AM -0800, Dan Williams wrote:
[...]
> John's patches will indicate to the FS that the page is gup pinned.  But they
> will not indicate longterm vs not "shorterm".  A shortterm pin could be handled
> as a "real truncate".  So, are we back to needing a longterm "bit" in struct
> page to indicate a longterm pin and allow the FS to perform this "virtual
> write" after truncate?
> 
> Or is it safe to consider all gup pinned pages this way?
> 
> Ira
> 

I mentioned this in another thread, but I'm not great at email threading. :)
Anyway, it seems better to just drop the entire "longterm" concept from the 
internal APIs, and just deal in "it's either gup-pinned *at the moment*, or 
it's not". And let the filesystem respond appropriately. So for a pinned page 
that hits clear_page_dirty_for_io or whatever else care about pinned pages:

-- fire mmu notifiers, revoke leases, generally do everything as if it were a
long term gup pin

-- if it's long term, then you've taken the right actions.

-- if the pin really is short term, everything works great anyway.


The only way that breaks is if longterm pins imply an irreversible action, such
as blocking and waiting in a way that you can't back out of or get interrupted
out of. And the design doesn't seem to be going in that direction, right?

thanks,
-- 
John Hubbard
NVIDIA
