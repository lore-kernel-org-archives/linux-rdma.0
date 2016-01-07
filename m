From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Fri, 8 Jan 2016 02:31:26 +0530
Message-ID: <CAG53R5WVJoO1Dd9vJ+zeiskQsttSbOpW+uyfay-oJFELd-FK2Q@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<20160105215623.GH5995@mtj.duckdns.org>
	<CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
	<20160107150718.GC29797@mtj.duckdns.org>
	<CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
	<20160107200604.GE1898@mtj.duckdns.org>
	<CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
	<20160107203425.GG1898@mtj.duckdns.org>
	<CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
	<20160107204921.GI1898@mtj.duckdns.org>
	<20160107205042.GJ1898@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160107205042.GJ1898@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 8, 2016 at 2:20 AM, Tejun Heo <tj@kernel.org> wrote:
> Ooh, btw, please don't bother to create separate interfaces for v1 and
> v2 hierarchies.  Just creating one following v2 conventions and using
> the same thing for v1 should do and is a lot easier for everybody.
>
Sure. I have already made that change to remove list.
and changed rdma.resource.verb.limit to rdma.verb.max etc.

I will keep rdma.hw.max around until we get some consensus.

Alternatively I was thinking to merge that as another attribute in
rdma.max file, like

mlx4_0 verb ah=max pd=10 qp=10
mlx4_0 hw ah=10 pd=100
ocrdma hw ah=10 pd=100

This remove hw specific extra file for rare feature.

Parav



> Thanks.
>
> --
> tejun
