From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 25 Feb 2016 19:56:01 +0530
Message-ID: <CAG53R5WxXYZof4QzuJndakzvG1+t388pDRXL2O466eEDkYJ+bw@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<56CDAC7A.6030206@mellanox.com>
	<CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
	<56CEED81.7010507@mellanox.com>
	<CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Can we call kfree() with spin_lock held? All these years I tend to
> avoid doing so.
Also it doesn't look correct to hold the lock while freeing the memory
which is totally unrelated to the lock.
With that I think current code appears ok with exception that its
duplicated at two place for code readability around lock.
What say?
