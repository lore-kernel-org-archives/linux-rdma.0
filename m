From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V2 6/8] RDMA/core: Add initialize and cleanup of common
 types
Date: Thu, 21 Jul 2016 14:40:05 +0300
Message-ID: <f45d0495-12fd-4ef0-7ba8-ede3dc046900@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-7-git-send-email-matanb@mellanox.com>
 <20160720174052.GI21460@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720174052.GI21460-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/07/2016 20:40, Jason Gunthorpe wrote:
> On Tue, Jul 19, 2016 at 06:23:30PM +0300, Matan Barak wrote:
>> @@ -210,103 +211,9 @@ static void ib_uverbs_detach_umcast(struct ib_qp *qp,
>>  static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
>>  				      struct ib_ucontext *context)
>>  {
>> +	ib_uverbs_uobject_type_initialize_ucontext(context, &file->device->ib_dev->type_list);
>
> There is a certain dissonance to having an initialize function called
> inside a cleanup function - is that right (it doesn't look that
> right)? If it is right, find a better name...
>

That's a bug, thanks.

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
