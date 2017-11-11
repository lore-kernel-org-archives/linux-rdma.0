From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] Cleanp SUSE Tumbleweed build
Date: Sat, 11 Nov 2017 09:18:43 -0700
Message-ID: <20171111161843.GK17451@ziepe.ca>
References: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 08, 2017 at 03:30:38PM +0100, Nicolas Morey-Chaisemartin wrote:
> This series is to fix the issue reported by Alaa here: https://www.spinics.net/lists/linux-rdma/msg56580.html
> 
> #1 adds details on the existing situation and an option in the spec file to allow rpmbuild to work
> #2 adds support for env specific rpmbuild options
> #3 Add the option from #1 to the tumbleweed env
> #4 switches the default SUSE env to tumbleweed for validation

Seems fine to me..

Reviewed-by: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
