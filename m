From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: libibverbs-1.2.0-rc1 release
Date: Thu, 24 Sep 2015 17:27:48 +0300
Message-ID: <56040864.6090308@dev.mellanox.co.il>
References: <5602DB41.5070700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5602DB41.5070700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/23/2015 8:02 PM, Doug Ledford wrote:
> I have done a pre-release of the upcoming libibverbs-1.2.0 release.  The
> code has been pushed to the official git repo and also an -rc1 tarball
> uploaded to the https://ww.openfabrics.org/downloads/verbs download
> area.  From the tag message:
>
> tag libibverbs-1.2.0-rc1
> Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Sep 23 12:47:04 2015 -0400
>
> Ininitial roundup of 1.2.0 release items
>
> - Add support for RoCE
> - Add support for On Demand Paging
> - No longer assume that no driver for a verbs device should be considered
>    an error condition (usnic devices in particular are moving to libfabric
>    drivers only, so we will emit a useless warning/error in the presence
>    of usnic enabled machines)
> - Harden some of the argument processing in example programs
> - Add support for s390x
> - Fix the broken create/destroy flow API
> - First release under new management (hence the decision to update to
>    version 1.2.0 instead of 1.1.9)
>

An updated libmlx4 head was posted, changes match to above libibverbs 
items, specifically:
- Add RoCE IP based addressing support for UD QPs
- Add support for s390x
- Add support for TX/RX checksum offload
- Fixed the create/destroy flow API to match libibverbs
- Version was updated to match libibverbs - 1.2.0-rc1

The official git repo was updated on:
git://openfabrics.org/~yishaih/libmlx4.git






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
