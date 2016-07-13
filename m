From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 2/8] RDMA/core: Move uobject code to separate files
Date: Wed, 13 Jul 2016 17:34:33 +0300
Message-ID: <1d3cd8ca-4e13-b679-44d6-023ba5d823d5@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-3-git-send-email-matanb@mellanox.com>
 <20160712191507.GB8206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160712191507.GB8206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/07/2016 22:15, Jason Gunthorpe wrote:
> On Thu, Jun 30, 2016 at 04:39:25PM +0300, Matan Barak wrote:
>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> The new proposed infrastructure allows driver's to declare new object
>> types. Furthermore, uobject management code will be used from both
>> the old legacy code and the new ioctl infrastructure.
>
> Seems reasonable.
>
>> +static inline void put_pd_read(struct ib_pd *pd)
>> +{
>> +	put_uobj_read(pd->uobject);
>> +}
>
> Ultimately I think we should get rid of these sorts of wrappers and
> just open code it - especailly as we are talking about growing the
> number of uboject types.
>

I agree. The new infrastructure fetches and manages use count 
automatically for you, so ultimately all these functions will be deleted.

> Jason
>

Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
