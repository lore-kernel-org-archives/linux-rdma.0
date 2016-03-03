From: 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [PATCH 6/8] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 21:09:36 +0100
Message-ID: <20160303200936.GA30993@lst.de>
References: <1457028192-24965-1-git-send-email-hch@lst.de> <1457028192-24965-7-git-send-email-hch@lst.de> <019d01d17587$a7a7ecd0$f6f7c670$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <019d01d17587$a7a7ecd0$f6f7c670$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 02:02:46PM -0600, Steve Wise wrote:
> Should the above be squashed into the mr_pool patch?

Yes.

> Also, in your isert WIP patch from your git repo:
> 
> patch 46debb67 ("IB/core: add a MR pool for signature MRs")
> 
> You accidentally undid the above change:

Meh.  Third attempt at properly squashing it in, and I still haven't
got it right.  Time for a vacation :)
