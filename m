From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Use dsgl by default
Date: Tue, 25 Apr 2017 13:11:53 -0500
Message-ID: <6f9ea8b2-3a8a-c9d9-9993-ef5b33c3df92@opengridcomputing.com>
References: <1487833303-4779-1-git-send-email-ganeshgr@chelsio.com>
 <1493143538.3041.79.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493143538.3041.79.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/25/2017 1:05 PM, Doug Ledford wrote:
> On Thu, 2017-02-23 at 12:31 +0530, Ganesh Goudar wrote:
>> Enable the use of dsgl by default and determine whether dsgl is
>> supported from lld info.
>>
>> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> I applied this, but I did add a deprecated tag to the module option
> description.
>

Thanks.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
