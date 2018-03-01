From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/3] RDMA/core: Avoid that ib_drain_qp() triggers an
 out-of-bounds stack access
Date: Thu, 1 Mar 2018 15:46:47 -0700
Message-ID: <20180301224647.GM19007@ziepe.ca>
References: <20180301220030.27433-1-bart.vanassche@wdc.com>
 <20180301220030.27433-2-bart.vanassche@wdc.com>
 <20180301221914.GK19007@ziepe.ca>
 <002f01d3b1ab$e4926640$adb732c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <002f01d3b1ab$e4926640$adb732c0$@opengridcomputing.com>
Sender: stable-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Bart Van Assche' <bart.vanassche@wdc.com>, 'Doug Ledford' <dledford@redhat.com>, 'Laurence Oberman' <loberman@redhat.com>, linux-rdma@vger.kernel.org, 'Sagi Grimberg' <sagi@grimberg.me>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 01, 2018 at 04:23:15PM -0600, Steve Wise wrote:

> > I don't get it..
> > 
> > Since when did ib_post_send() start requiring a ib_rdma_wr?
> > 
> > IB_WR_RDMA_WRITE == 0, so even missing that is 'OK' but ugly.
> > 
> > What is the actual bug here?
> > 
> 
> The WRs are now split up, so struct ib_send_wr doesn't encompass the full
> size of all the possible WRs.  See ib_rdma_wr, for example, which includes
> ib_send_wr.  So the bug is the drain code is posting a WRITE wr, but not
> including the entire struct ib_rdma_wr. 

Oh.. yes, I forgot about that patch. Thanks, OK.

Jason
