From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/12] iser target patches for 4.6
Date: Thu, 25 Feb 2016 21:59:07 -0800
Message-ID: <1456466347.32369.54.camel@haakon3.risingtidesystems.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
	 <56CDE7E1.8010001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56CDE7E1.8010001@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-02-24 at 19:26 +0200, Sagi Grimberg wrote:
> > Hi Nic,
> >
> > This patchset targets 4.6 merge window, it passed
> > our nightly regression tests.
> >
> > The set consists of:
> > - Several patches for error flow fixes and rework from Jenny
> 

Applied patches #1-11 to target-pending/for-next.

Since your last ib_drain_qp patch depends on external > 4.5 changes in
rdma.git, it's been dropped for the moment.

> Oh and I forgot to mention that patches 1-6 are stable material.
> 

Wrt to stable tags, looking at:

iser-target: Separate flows for np listeners and connections cma events
iser-target: Remove redundant wait in release_conn
iser-target: Remove impossible condition from isert_wait_conn

they don't appear to be fixes, or at least it's not clear from commit
log what bug they address.

So leaving the stable tags off #3, #5 and #6 for now, other please
confirm.

Thanks Sagi.
