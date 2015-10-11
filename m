From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 2/2] IB/iser: Enable SG clustering
Date: Sun, 11 Oct 2015 18:38:35 +0300
Message-ID: <561A827B.6020508@dev.mellanox.co.il>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
 <1444577707-15778-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444577707-15778-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/11/2015 6:35 PM, Sagi Grimberg wrote:
> iser can handle it and it can dramatically reduce the
> number of SG elements. It doesn't make much of a difference at
> the moment, but with arbitrary SG list support it will benefit
> greatly.
>

Bahh, I updated the change-log in the previous revision :(

Doug would you mind updating the change-log on the fly to:

iser can handle it and it can dramatically reduce the
number of SG elements. It doesn't make much of a difference at
the moment, but with arbitrary SG list support it will benefit
greatly as it would reduce the size of the HW descriptors array.

Thanks and sorry...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
