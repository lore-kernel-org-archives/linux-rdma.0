From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 02/30] IB/core: Add kref to IB devices
Date: Thu, 19 Feb 2015 12:57:51 +0200
Message-ID: <54E5C1AF.4010400@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <1b381c86-9f29-49a6-b7c5-9571d4490f5c@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1b381c86-9f29-49a6-b7c5-9571d4490f5c-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/02/2015 00:02, Somnath Kotur wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Previously. we used device_mutex lock in order to protect
> the device's list. That means that in order to guarantee a
> device isn't freed while we use it, we had to lock all
> devices.
> 
> Adding a kref per IB device. Before an IB device
> is unregistered, we wait before its not held anymore.

Maybe I'm missing something, but IB device already has a struct device
embedded in it, which has a kobject with a kref. Wouldn't it be better
to simply move the operations that need to wait to the ib_device_release
function?

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
