From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Tue, 7 Nov 2017 08:41:33 -0700
Message-ID: <20171107154133.GB21466@ziepe.ca>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <20171104100846.GA1636@mtr-leonro.local>
 <7dba9ad9-5a71-c4fe-b2b9-ccc35c188f8c@huawei.com>
 <20171106020945.GA26011@ziepe.ca>
 <2622b4b1-5bc4-ec04-c9a4-d78d5a727f4c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2622b4b1-5bc4-ec04-c9a4-d78d5a727f4c-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 07, 2017 at 06:59:05PM +0800, oulijun wrote:
> 在 2017/11/6 10:09, Jason Gunthorpe 写道:
> > My patch fixes all the sparse problems.

>   Do I need to clean this patch and send a new patch refer to Jason's patch?

Test and ack my patch instead, it already incorporates this patch in
the correct way.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
