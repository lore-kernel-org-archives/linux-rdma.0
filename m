From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Thu, 14 May 2015 14:28:10 +0300
Message-ID: <555486CA.8080409@dev.mellanox.co.il>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373A8FDA36D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDA36D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/13/2015 11:55 PM, Hefty, Sean wrote:
> Please look at ib_user_mad and how it handles device removal with active clients.  We should be able to follow the same model that doesn't require driving changes down into every driver.
>

The ib_uverbs code does follow the same model in the sense that the 
context (uverbs_device) associated with the fd remains open until the 
app closes it, while all references to the HW device are removed 
immediately. However, in contrast to the umad API, which does *not* 
expose direct HW access and thus can be managed in a device-independent 
manner, ib_uverbs does provide user-space direct HW access.
Therefore, detaching a ib_uverbs context from a HW device does require 
device-specific logic.
The amount of code depends on the specific driver. The proposed 
framework provides any driver a chance to do proper cleanup when devices 
are removed.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
