From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 3/5] IB/mlx5: Add support for hca_core_clock
 and timestamp_mask
Date: Wed, 16 Dec 2015 16:50:36 +0200
Message-ID: <CAAKD3BDx3+3QbbSWOj__bV5=a6AeZvNwbRh93nHwC7AUBE_Kog@mail.gmail.com>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
	<1450204213-5630-4-git-send-email-matanb@mellanox.com>
	<567178A6.7040700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567178A6.7040700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 4:43 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
>> Reporting the hca_core_clock (in kHZ) and the timestamp_mask in
>> query_device extended verb. timestamp_mask is used by users in order
>> to know what is the valid range of the raw timestamps, while
>> hca_core_clock reports the clock frequency that is used for
>> timestamps.
>
>
> Hi Matan,
>
> Shouldn't this patch come last?
>

Not necessarily. In order to support completion timestamping (that's
what defined in this query_device patch), we only need create_cq_ex in
mlx5_ib.
The down stream patches adds support for reading the HCA core clock
(via query_values).
One could have completion timestamping support without having
ibv_query_values support.

Thanks for taking a look.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
