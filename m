From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 02/10] IB/iser: Reuse ib_sg_to_pages
Date: Thu, 10 Dec 2015 10:28:59 +0200
Message-ID: <566937CB.80803@dev.mellanox.co.il>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-3-git-send-email-sagig@mellanox.com>
 <20151209192819.GA21477@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151209192819.GA21477-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 09/12/2015 21:28, Christoph Hellwig wrote:
> On Wed, Dec 09, 2015 at 02:12:00PM +0200, Sagi Grimberg wrote:
>> We have in iser iser_sg_to_page_vec which has exactly
>> the same role as ib_sg_to_pages. Customize the page_vec
>> to hold a fake MR so we can reuse ib_sg_to_pages.
>
> Looks good.  In the long run we should simply kill struct ib_fmr
> and make FRMs operate on struct ib_mr so that it can use
> ib_sg_to_pages directly.

We can do that. We'd need to add ib_mr a list member just for fmr
routines.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
