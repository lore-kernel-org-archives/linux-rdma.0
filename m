From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] cxgb4: fix abort_req_rss6 struct
Date: Mon, 10 Sep 2018 10:16:35 -0500
Message-ID: <be1123c6-bcb5-b7e8-788c-cf03209b4317@opengridcomputing.com>
References: <1e9f55943699dcc2bc921000ee7ee5353cbf7480.1535742195.git.swise@opengridcomputing.com>
 <20180905225555.GA3775@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180905225555.GA3775@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: netdev@vger.kernel.org, dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


(sorry for the late reply, I was out all last week)


On 9/5/2018 5:55 PM, Jason Gunthorpe wrote:
> On Fri, Aug 31, 2018 at 11:52:00AM -0700, Steve Wise wrote:
>> Remove the incorrect WR_HDR field which can cause a misinterpretation
>> of this CPL by ULDs.
> 
> What does that mean?
> 

It means iw_cxgb4 doesn't correctly handle incoming ABORT CPL messages
due to this incorrect struct.


> Is this an -rc patch?
> 

Yes. Since it fixes a3cdaa69e4ae ("cxgb4: Adds CPL support for Shared
Receive Queues") which went into 4.19.

Steve.
