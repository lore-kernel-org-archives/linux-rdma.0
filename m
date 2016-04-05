From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 18:44:23 +0300
Message-ID: <20160405154423.GK5264@leon.nu>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
 <20160404193640.GA7822@mtj.duckdns.org>
 <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
 <20160405012504.GG24661@htj.duckdns.org>
 <20160405090627.GA26425@infradead.org>
 <CAG53R5WBBUj6=B81Q-zEwL_xy3_yXUofJ6p921baqnqeVocDPQ@mail.gmail.com>
 <20160405124252.GA4348@infradead.org>
 <CAG53R5UOogG1itd8AzMOWnpnyGqKSRLY4CNrX5HWGfdF3q-F3w@mail.gmail.com>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5UOogG1itd8AzMOWnpnyGqKSRLY4CNrX5HWGfdF3q-F3w@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 05, 2016 at 05:55:26AM -0700, Parav Pandit wrote:
> Hi Christoph,
> 
> On Tue, Apr 5, 2016 at 5:42 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Apr 05, 2016 at 05:39:21AM -0700, Parav Pandit wrote:
> >> I am not really trying to address OFED issues here. I am sure you
> >> understand that if ib_core.ko kernel module is in-kernel module than,
> >> for all the fixes/enhancements that goes to it would require people to
> >> upgrade to newer kernel, instead of just modules upgrade. Such heavy
> >> weight upgrade slows down the adoption which i am trying to avoid here
> >> by placing knobs in right kernel module's hand.
> >
> > What a load of rubbish.  The Linux kernel is one program and should be
> > upgraded together.
> 
> Just because we add one more rdma resource, we need to ask someone to
> upgrade kernel?

It doesn't make sense. Kernel and modules are always coming together,
the attempts to mix kernel and modules from different versions can lead
to many interesting debug scenarios.
