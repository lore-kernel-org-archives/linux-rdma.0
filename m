From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 2/2] IB/iser: Enable SG clustering
Date: Sun, 11 Oct 2015 21:56:46 +0300
Message-ID: <CAJ3xEMhcQjiRUwD8Huk0i_9BWDN=PAeNCkNkN2W7hPvXwqECcQ@mail.gmail.com>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
	<1444577707-15778-3-git-send-email-sagig@mellanox.com>
	<561A827B.6020508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561A827B.6020508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 11, 2015 at 6:38 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 10/11/2015 6:35 PM, Sagi Grimberg wrote:
>>
>> iser can handle it and it can dramatically reduce the
>> number of SG elements. It doesn't make much of a difference at
>> the moment, but with arbitrary SG list support it will benefit
>> greatly.
>>
>
> Bahh, I updated the change-log in the previous revision :(
>
> Doug would you mind updating the change-log on the fly to:

Doug,  I sent Sagi a note asking to improve the change-log, lets get
this done prior to picking the patch.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
