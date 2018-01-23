From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Tue, 23 Jan 2018 08:04:21 -0700
Message-ID: <20180123150421.GA30670@ziepe.ca>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
 <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
 <20180118043717.GC8414@ziepe.ca>
 <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
 <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
 <20180119200029.GD3437@ziepe.ca>
 <68e02f2a-0474-bc73-a784-fd52dbbde552@huawei.com>
 <20180120164625.GA14372@ziepe.ca>
 <124fa0b2-ac35-a103-205b-252fddea2665@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <124fa0b2-ac35-a103-205b-252fddea2665-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 08:51:09PM +0800, Liuyixian (Eason) wrote:
> Could you please give me further comments on that email?  If you don't
> agree with what I said in that email, can you give some suggestions
> to resolve compatibility issue?

You can't have a not compatible in your table.

You need to add some kind of mechanism for userspace to enable the new
features conditionally.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
