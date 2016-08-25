From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv11 3/3] rdmacg: Added documentation for rdmacg
Date: Thu, 25 Aug 2016 13:28:44 +0530
Message-ID: <CAG53R5XxO8aj6FvaMQgOe4C4eJjcOW6KfmtfK9UK5H3=4ruT7A@mail.gmail.com>
References: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
 <1471869231-15576-4-git-send-email-pandit.parav@gmail.com> <CAKoUArnZvsost5pgysC9DL1_msBta0nmkXTjnk+0KxgwJAoR=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKoUArnZvsost5pgysC9DL1_msBta0nmkXTjnk+0KxgwJAoR=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rami Rosen <roszenrami@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Rami Rosen,

On Thu, Aug 25, 2016 at 4:25 AM, Rami Rosen <roszenrami@gmail.com> wrote:
> Hi,
>
>> +Whenever RDMA resource charing occurs, owner rdma cgroup is returned to
> Should be: charging instead of charing
>
>> +(b) Query resource limit:
>> +cat /sys/fs/cgroup/rdma/2/rdma.max
>> +#Output:
>> +mlx4_0 uctx=max pd=max ah=2 mr=100 mw=max cq=max srq=max qp=10 flow=max
>> +ocrdma1 uctx=1 pd=5 ah=1 mr=10 cq=10 srq=max qp=20 flow=max flow=max
>
> Is this really so: double"flow=max" at the end of the ocrdma1 line?
> (flow=max flow=max)
>
>> +5-4. RDMA
>> +
>> +The "rdma" controller regulates the distribution and accounting of
>> +of RDMA resources.
> "of of" should be only a single "of"
>

>
>> +         mlx4_1 uctx=1 ah=0 pd=1 cq=4 qp=4 mr=100 srq=0 flow=10
>> +         ocrdma1 uctx=2 pd=2 ah=2 mr=20 mw=max cq=1 srq=1 qp=10 flow=10
>
> Seems to be inconsistency here: in the first line you have qp=4
> *before* srq=0, but in the second line you have qp=10 *after* srq=1.
>

I will fix above 4 typo errors.
Christoph has done quick review, I will wait for him to complete the
review before spinning v12 for these fixes.

> Keep on the good work!
Thank you for the motivation.

>
> Regards,
> Rami Rosen
