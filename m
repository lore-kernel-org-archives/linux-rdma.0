From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/7] dev attr cleanup (less is more)
Date: Fri, 18 Dec 2015 15:06:37 +0100
Message-ID: <567412ED.9070200@sandisk.com>
References: <1450429190-5898-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450429190-5898-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/18/2015 09:59 AM, Or Gerlitz wrote:
> OK, Doug, this is my suggestion for the dev attr cleanup -- it
> has the advantages of leaving the attrs on a well defined location,
> a field in the IB device, the ability to  get that through smaller
> patches, avoid touching any of the HW drivers, etc.

Hello Or,

This version of the dev attr cleanup patches (just like the previous 
version) makes kernel code access the attrs member of struct ib_device 
while user space code keeps calling the query_device function. If there 
would be a bug in one of the query_device implementations, e.g. that the 
correct data is only returned some time after device initialization has 
finished, then user space code will see other attribute values than 
kernel code. I think we should avoid such subtle and hard to debug 
behavior. Hence my proposal to modify ib_uverbs_ex_query_device() such 
that it fetches attribute information from the ib_device structure 
instead of by calling query_device().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
