From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/2] infiniband: trivial header search path fixups
Date: Fri, 25 Jan 2019 15:51:49 -0700
Message-ID: <20190125225149.GA5556@ziepe.ca>
References: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sagi Grimberg <sagi@grimberg.me>, Nelson Escobar <neescoba@cisco.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Parvi Kaustubhi <pkaustub@cisco.com>, linux-kernel@vger.kernel.org, Lijun Ou <oulijun@huawei.com>, Steve Wise <swise@chelsio.com>, target-devel@vger.kernel.org, Christian Benvenuti <benve@cisco.com>, Faisal Latif <faisal.latif@intel.com>, Bart Van Assche <bvanassche@acm.org>, Shiraz Saleem <shiraz.saleem@intel.com>, Selvin Xavier <selvin.xavier@broadcom.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Devesh Sharma <devesh.sharma@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 25, 2019 at 01:39:29PM +0900, Masahiro Yamada wrote:
> My main motivation is to get rid of crappy header search path manipulation
> from Kbuild core.
> 
> Before that, I want to do as many treewide cleanups as possible.
> 
> If you are interested in the big picture of this work,
> the full patch set is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test
> 
> 
> 
> Masahiro Yamada (2):
>   infiniband: remove unneeded header search paths
>   infiniband: prefix header search paths with $(srctree)/

Still compiles for me too, applied to rdam for-next

Thanks,
Jason
