From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Thu, 7 Jan 2016 15:06:04 -0500
Message-ID: <20160107200604.GE1898@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <20160105215623.GH5995@mtj.duckdns.org>
 <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
 <20160107150718.GC29797@mtj.duckdns.org>
 <CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello,

On Fri, Jan 08, 2016 at 01:31:06AM +0530, Parav Pandit wrote:
> >  What I was
> > trying to say was that unless the number is extremely high, it'd be
> > far simpler to hard code them in the rdma controller and let drivers
> > enable the ones which apply to them.
> 
> Instead of in rdma controller, its hard coded in IB stack.
> I see this as an advantage where resource definition ownership remains
> with IB stack maintainers, rather than rdma cgroup maintainer.
> rdma cgroup maintainer doesn't have to understand what SRQ vs QP or
> ODP type MR or multicast group is.
> IB stack maintainer is better placed to judge and define it.
> 
> I would like to hear from Jason, Doug, Liran and other RDMA experts
> about their thoughts.

That's fine.  Make it a header file in IB stack which is included from
the rdma cgroup controller.  The only things are not building a huge
dynamic framework for something which can easily be a simple static
thing and having some oversight in adding resource types.

Thanks.

-- 
tejun
