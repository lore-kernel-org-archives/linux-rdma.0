From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS/RDMA device removal support
Date: Thu, 14 Jul 2016 12:55:18 -0400
Message-ID: <643B9EC8-3277-471C-9262-A5FE098956B4@oracle.com>
References: <DB921E2E-A0DD-4BF8-B7CC-D6061C6F16BF@oracle.com> <20160713193025.GB26851@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160713193025.GB26851-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jul 13, 2016, at 3:30 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> On Wed, Jul 13, 2016 at 02:31:10PM -0400, Chuck Lever wrote:
>> I believe ULPs will have to map these buffers again once a
>> new device is available. But as part of DEVICE_REMOVAL, does
>> the ULP have to explicitly unmap this memory?
> 
> Yes.
> 
> The desire is for 'struct ib_device' to become freeable after the
> DEVICE_REMOVAL notifications complete. This means no ULP should retain a
> kref on it.
> 
> Since you need a struct ib_device to call the ib_dma_* functions you
> must do that before completing removal. The ulp must call the various
> unmap functions, this is not done for you during unregister.

Jason, thanks for confirming.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
