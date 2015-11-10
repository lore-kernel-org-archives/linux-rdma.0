From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] IB/mlx5: Add create_cq extended command
Date: Tue, 10 Nov 2015 10:30:36 +0200
Message-ID: <CAAKD3BCJqOqfv-Sv_XNdg2GiwAuNMUnAzegndM-Q7Kwcax6i+w@mail.gmail.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
	<1447086657-15358-2-git-send-email-matanb@mellanox.com>
	<20151109232400.GC20707@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109232400.GC20707-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 1:24 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Nov 09, 2015 at 06:30:54PM +0200, Matan Barak wrote:
>> @@ -1385,7 +1385,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
>>               (1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)         |
>>               (1ull << IB_USER_VERBS_CMD_OPEN_QP);
>>       dev->ib_dev.uverbs_ex_cmd_mask =
>> -             (1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
>> +             (1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)     |
>> +             (1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ);
>
> Eli posted a series that gets rid of this stuff, can you please
> coordinate?
>

It'll create a dependency between this series and Eli's series, but
I'll change that.

> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
