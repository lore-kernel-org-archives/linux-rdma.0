From: Roland Dreier <roland@kernel.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Tue, 17 Feb 2015 19:01:13 -0800
Message-ID: <CAL1RGDV7VmjQ6NbrhDHYPPBJH2L-5zkMdA-x-mZFpETc9NxMiA@mail.gmail.com>
References: <20150218133221.7aa89df7@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150218133221.7aa89df7@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 17, 2015 at 6:32 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the livepatching tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> In file included from drivers/infiniband/hw/qib/qib_cq.c:41:0:
> drivers/infiniband/hw/qib/qib.h: In function 'qib_flush_wc':
> drivers/infiniband/hw/qib/qib.h:1470:1: error: expected ';' before '}' token
>  }
>  ^
>
> and it went badly down hill from there :-(


Weird, I could have sworn I fixed that before I pushed the tree out.
Anyway I'll try adding the missing ';' again and push it out again :(
