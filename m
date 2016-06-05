From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 26/29] IB/rxe: Interface to netdev stack
Date: Sun, 5 Jun 2016 12:42:43 +0300
Message-ID: <CAG9sBKNYgt+G7ck6-Z8MkZnn9TyHw+wTrcSxJzkrR1O9Z8H6Xg@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <1464886657-14258-27-git-send-email-monis@mellanox.com> <20160602173158.GA17320@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160602173158.GA17320-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 2, 2016 at 8:31 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Jun 02, 2016 at 07:57:34PM +0300, Moni Shoua wrote:
>> + * note: this table is a replacement for a protocol specific pointer
>> + * in struct net_device which exists for other ethertypes
>> + * this allows us to not have to patch that data structure
>> + * eventually we want to get our own when we're famous
>> + */
>> +struct rxe_net_info net_info[RXE_MAX_IF_INDEX];
>> +spinlock_t net_info_lock; /* spinlock for net_info array */
>> +struct rxe_recv_sockets recv_sockets;
>
> This sort of stuff probably isn't suitable for mainline.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Will fix in next submission

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
