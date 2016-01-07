From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Fri, 8 Jan 2016 02:16:59 +0530
Message-ID: <CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<20160105215623.GH5995@mtj.duckdns.org>
	<CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
	<20160107150718.GC29797@mtj.duckdns.org>
	<CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
	<20160107200604.GE1898@mtj.duckdns.org>
	<CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
	<20160107203425.GG1898@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160107203425.GG1898@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 8, 2016 at 2:04 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Jan 08, 2016 at 02:02:20AM +0530, Parav Pandit wrote:
>> o.k. That doable. I want to make sure that we are on same page on below design.
>> rpool (which will contain static array based on header file ) would be
>> still there, because resource limits are on per device basis. Number
>> of devices are variable and dynamically appear. Therefore rdma_cg will
>> have the list of rpool attached to it. Do you agree?
>
> Yeap.  Would it make more sense to hang them off of whatever struct
> which presents a rdma device tho?  And then just walk them from cgroup
> controller?
>

Let me think through it. Its been late night for me currently. So dont
want to conclude in hurry.
At high level it looks doable by maintaining hash table head on per
device basis, that further reduces hash contention by one level.
I will get back on this tomorrow.

> Thanks.
>
> --
> tejun
