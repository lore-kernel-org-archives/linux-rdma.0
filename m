From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 07:14:49 -0700
Message-ID: <CAG53R5XyPZ9SM_8aZHkaTMcrz1oDbu=C2yh3+cwJD676JapaPg@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
	<CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
	<20160405012504.GG24661@htj.duckdns.org>
	<CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
	<20160405140107.GB7822@mtj.duckdns.org>
	<20160405140704.GC7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160405140704.GC7822@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 5, 2016 at 7:07 AM, Tejun Heo <tj@kernel.org> wrote:
> Just one more thing.
>
> On Tue, Apr 05, 2016 at 10:01:07AM -0400, Tejun Heo wrote:
> ...
>> > pool_info in spin lock context, made me allocate memory to get all
>> > values upfront through allocation.
>> > Now that the lock is going away, I can do what you have described above.
>
> So, this might be okay depending on the use case but it often becomes
> painful to require sleeping context for freeing resources.  If you're
> certain that requiring sleeping context is okay for all paths, using a
> single mutex is fine but *usually* it isn't a great idea.
>
At present charge and uncharge are from sleeping context.

>
> --
> tejun
