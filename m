From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/4] get_user_pages*() and RDMA: first steps
Date: Mon, 1 Oct 2018 09:31:01 -0600
Message-ID: <20181001153101.GA23286@ziepe.ca>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
 <20180928152958.GA3321@redhat.com>
 <4c884529-e2ff-3808-9763-eb0e71f5a616@nvidia.com>
 <20180928214934.GA3265@redhat.com>
 <dfa6aaef-b97e-ebd4-6cc8-c907a7b3f9bb@nvidia.com>
 <20180929084608.GA3188@redhat.com>
 <20181001061127.GQ31060@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181001061127.GQ31060@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jerome Glisse <jglisse@redhat.com>, John Hubbard <jhubbard@nvidia.com>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Christian Benvenuti <benve@cisco.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 01, 2018 at 04:11:27PM +1000, Dave Chinner wrote:

> This reminds me so much of Linux mmap() in the mid-2000s - mmap()
> worked for ext3 without being aware of page faults, so most mm/
> developers at the time were of the opinion that all the other
> filesystems should work just fine without being aware of page
> faults.

This is probably because RDMA was introduced around that time, before
page_mkwrite was added.. It kind of sounds like page_mkwrite() broke
all the writing get_user_pages users and it wasn't realized at the
time.

BTW, we are hosting a session on this at Plumbers during the RDMA
track, hope everyone interested will be able to attend.

Jason
