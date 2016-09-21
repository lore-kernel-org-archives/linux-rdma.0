From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 21 Sep 2016 10:26:45 -0400
Message-ID: <20160921142645.GB10734@htj.duckdns.org>
References: <20160910170151.GA5230@obsidianresearch.com>
 <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu>
 <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu>
 <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello, Parav.

On Wed, Sep 21, 2016 at 10:13:38AM +0530, Parav Pandit wrote:
> We have completed review from Tejun, Christoph.
> HFI driver folks also provided feedback for Intel drivers.
> Matan's also doesn't have any more comments.
> 
> If possible, if you can also review, it will be helpful.
> 
> I have some more changes unrelated to cgroup in same files in both the git tree.
> Pushing them now either results into merge conflict later on for
> Doug/Tejun, or requires rebase and resending patch.
> If you can review, we can avoid such rework.

My impression of the thread was that there doesn't seem to be enough
of consensus around how rdma resources should be defined.  Is that
part agreed upon now?

Thanks.

-- 
tejun
