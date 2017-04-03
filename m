From: Talat mellanox <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] debian: Update Copyright file
Date: Mon, 3 Apr 2017 15:28:27 +0300
Message-ID: <CAB1oGZf_GaN-kiLOizmU_Pk-BhX8jyW0AO2NvFbqaNb0AU5KGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 3, 2017 at 2:35 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Apr 03, 2017 at 01:13:30PM +0300, Talat Batheesh wrote:
>> Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  debian/copyright | 42 ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 38 insertions(+), 4 deletions(-)
>
> Hi Talat,
>
> Thank you for sending this patch, but can you please send a script which
> generates this file? It is not scalable to update this file manually.
>
> Thanks

This file is one of the most important files in Debian packaging , and
it carefully made, so i prefer to modify it manually.
There is a several tools [1] that assist with building it like
licensecheck, cme and decopy and i used them for the rdma-core
package.

[1]
https://wiki.debian.org/CopyrightReviewTools


Thanks,
Talat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
