From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] cxgb4: fix abort_req_rss6 struct
Date: Tue, 11 Sep 2018 09:19:17 -0600
Message-ID: <20180911151917.GA29370@ziepe.ca>
References: <1e9f55943699dcc2bc921000ee7ee5353cbf7480.1535742195.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e9f55943699dcc2bc921000ee7ee5353cbf7480.1535742195.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 31, 2018 at 11:52:00AM -0700, Steve Wise wrote:
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

Applied to for-rc, thanks

Jason
