From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/bnxt_re: Fix return value check for ib_get_eth_speed()
Date: Thu, 17 Aug 2017 19:50:05 +0530
Message-ID: <CA+sbYW2xJDOh+g2H74QL+92_C1kWnD2-uGOGjagPSy16fR+oDQ@mail.gmail.com>
References: <1502970504-30010-1-git-send-email-selvin.xavier@broadcom.com> <20170817131213.GG23648@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817131213.GG23648-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 17, 2017 at 6:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

>> Fixes: d41861942fc5 (Add generic function to extract IB speed from netdev)
>
> There is need to put quotes (" or ')over commit title;
> Fixes: d41861942fc5 ("Add generic function to extract IB speed from netdev")
>
>> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
> Please fix usnic too, it has the same issue.
>

Sure..  will post v2.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
