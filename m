From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Thu, 7 Jan 2016 15:49:21 -0500
Message-ID: <20160107204921.GI1898@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <20160105215623.GH5995@mtj.duckdns.org>
 <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
 <20160107150718.GC29797@mtj.duckdns.org>
 <CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
 <20160107200604.GE1898@mtj.duckdns.org>
 <CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
 <20160107203425.GG1898@mtj.duckdns.org>
 <CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello, Parav.

On Fri, Jan 08, 2016 at 02:16:59AM +0530, Parav Pandit wrote:
> Let me think through it. Its been late night for me currently. So dont
> want to conclude in hurry.

Sure thing.

> At high level it looks doable by maintaining hash table head on per
> device basis, that further reduces hash contention by one level.
> I will get back on this tomorrow.

Hmmm... why would it need a hash table?  Let's say there's a struct
rdma_device for each rdma_device and then that stuct can simply have
rdma_device->res_table[] or whatever to track limits and consumptions
and rdma_device->res_enabled mask to tell which resources are enabled
on the device.

Thanks.

-- 
tejun
