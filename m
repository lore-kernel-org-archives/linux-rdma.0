From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Wed, 1 Nov 2017 22:40:35 -0600
Message-ID: <20171102044035.GB18874@ziepe.ca>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <774e90ab-cab5-2798-42ae-3488623f4b92@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <774e90ab-cab5-2798-42ae-3488623f4b92-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 11:31:29AM +0800, oulijun wrote:
> > the tool and then doing:
> > 
> >  mkdr build-sparse
> >  cd build-sparse
> >  CC=cgcc cmake -GNinja ..
> >  ninja
> > 
> >  # See only the warnings from hns:
> >  rm ./providers/hns/CMakeFiles/hns-rdmav16.dir/*.o
> >  ninja
> > 
> Also, I have tried to run sparse, the step as follows:
> 1. sudo apt-get install sparse
> 2. mkdir build-sparse
> 3. cd build-sparse
> 4. CC = armgcc cmake -GNinja ..
> 
> Then, the running is fail
> we need to use cgcc?

Yes, you must use cgcc, sparse will not produce a useful resulting
compile except for the warning messages.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
