From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Mon, 11 Feb 2019 14:33:53 -0800
Message-ID: <018c1a05-5fd8-886a-573b-42649949bba8@nvidia.com>
References: <bfe0fdd5400d41d223d8d30142f56a9c8efc033d.camel@redhat.com>
 <01000168c8e2de6b-9ab820ed-38ad-469c-b210-60fcff8ea81c-000000@email.amazonses.com>
 <20190208044302.GA20493@dastard> <20190208111028.GD6353@quack2.suse.cz>
 <CAPcyv4iVtBfO8zWZU3LZXLqv-dha1NSG+2+7MvgNy9TibCy4Cw@mail.gmail.com>
 <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
 <fb507b56-7f8f-cf2c-285c-bae3b2d72c4f@nvidia.com>
 <20190211221247.GI24692@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211221247.GI24692@ziepe.ca>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 2/11/19 2:12 PM, Jason Gunthorpe wrote:
> On Mon, Feb 11, 2019 at 01:22:11PM -0800, John Hubbard wrote:
> 
>> The only way that breaks is if longterm pins imply an irreversible action, such
>> as blocking and waiting in a way that you can't back out of or get interrupted
>> out of. And the design doesn't seem to be going in that direction, right?
> 
> RDMA, vfio, etc will always have 'long term' pins that are
> irreversible on demand. It is part of the HW capability.
> 

Yes, I get that about the HW. But I didn't quite phrase it accurately. What I
meant was, irreversible from the kernel code's point of view; specifically,
the filesystem while in various writeback paths.

But anyway, Jan's proposal a bit earlier today [1] is finally sinking into
my head--if we actually go that way, and prevent the caller from setting up
a problematic gup pin in the first place, then that may make this point sort
of moot.


> I think the flag is badly named, it is really more of a
> GUP_LOCK_PHYSICAL_ADDRESSES flag.
> 
> ie indicate to the FS that is should not attempt to remap physical
> memory addresses backing this VMA. If the FS can't do that it must
> fail.
> 

Yes. Duration is probably less important than the fact that the page
is specially treated.

[1] https://lore.kernel.org/r/20190211102402.GF19029@quack2.suse.cz
thanks,
-- 
John Hubbard
NVIDIA
