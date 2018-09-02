From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cxgb4: fix abort_req_rss6 struct
Date: Sat, 01 Sep 2018 22:28:52 -0700 (PDT)
Message-ID: <20180901.222852.177010178160927206.davem@davemloft.net>
References: <1e9f55943699dcc2bc921000ee7ee5353cbf7480.1535742195.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1e9f55943699dcc2bc921000ee7ee5353cbf7480.1535742195.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: swise@opengridcomputing.com
Cc: netdev@vger.kernel.org, jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>
Date: Fri, 31 Aug 2018 11:52:00 -0700

> Remove the incorrect WR_HDR field which can cause a misinterpretation
> of this CPL by ULDs.
> 
> Fixes: a3cdaa69e4ae ("cxgb4: Adds CPL support for Shared Receive Queues")
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
> 
> Dave, Doug, and Jason,
> 
> I request this merge through the rdma repo since the only user of this
> structure is iw_cxgb4.

No objections from me.
