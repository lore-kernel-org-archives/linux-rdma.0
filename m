From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/1] drivers/infiniband/core/verbs.c: fix build with
 gcc-4.4.4
Date: Wed, 14 Mar 2018 14:08:17 -0700
Message-ID: <20180314140817.8d1b8854af509981ff6562bd@linux-foundation.org>
References: <20180313215157.GL3mSm-p6%akpm@linux-foundation.org>
        <1521060060.18703.111.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1521060060.18703.111.camel@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: bart.vanassche@wdc.com, jgg@mellanox.com, linux-rdma@vger.kernel.org, sagi@grimberg.me, stable@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org

On Wed, 14 Mar 2018 16:41:00 -0400 Doug Ledford <dledford@redhat.com> wrote:

> On Tue, 2018-03-13 at 14:51 -0700, akpm@linux-foundation.org wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: drivers/infiniband/core/verbs.c: fix build with gcc-4.4.4
> > 
> > gcc-4.4.4 has issues with initialization of anonymous unions.
> 
> That compiler was released in April of 2010, almost a full 8 years ago. 
> What still uses it, and do we seriously care?

Documentation/Changes still says gcc-3.2.  A few people are using the
older versions.  There's talk going around about requiring something
more recent but nothing has happened yet.
