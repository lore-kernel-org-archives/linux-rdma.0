From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/mlx4: Fix extended counters support
Date: Thu, 11 Feb 2016 18:49:51 +0200
Message-ID: <CAAKD3BDQ7x2JzeWrPz+bzG_otRzWmhEmh8cMJ_DXkYGH+SqAzw@mail.gmail.com>
References: <1455179084-4778-1-git-send-email-matanb@mellanox.com>
	<56BCB215.4050802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCB215.4050802-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 11, 2016 at 6:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/11/2016 03:24 AM, Matan Barak wrote:
>> From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Hi Doug,
>>
>> This series fixes an issue introduced in 4.5 after applying Christoph Lameter's
>> "IB 64 bit counter support" series.  Christoph used a mad in order to query the
>> vendor driver for extended counters support, however this mad wasn't handled in
>> mlx4 when link layer is Ethernet.  Thus, extended counters support was broken.
>> In addition, this series fixes a bug in IB/core sysfs which was also introduced
>> in "IB 64 bit counter support" series.
>>
>> Patch 0001 fixes wrong handling of port info capability mask, which caused
>> setting of extended counters sysfs even if underlying device doesn't support
>> it.
>> Patch 0002-0003 align mlx4 counters sysfs for extended counters scheme in case
>> link layer is Ethernet.
>>
>> Thanks,
>> Eran and Matan.
>>
>> Eran Ben Elisha (3):
>>   IB/core: Fix reading capability mask of the port info class
>>   IB/mlx4: Add support for extended counters over RoCE ports
>>   IB/mlx4: Add support for the port info class for RoCE ports
>>
>>  drivers/infiniband/core/sysfs.c  |  5 ++--
>>  drivers/infiniband/hw/mlx4/mad.c | 63 +++++++++++++++++++++++++++++++---------
>>  2 files changed, 52 insertions(+), 16 deletions(-)
>>
>
> Hi Matan,
>
> The first patch is a true bug fix while the next two add the feature to
> RoCE mode.  Based upon the code patches, the RoCE code should work fine
> for 4.5 without the new support, there isn't a bug there (they simply
> won't respond to the ext counters port request).  So I took the first
> patch for-rc and the next two I'll put in for-next.
>

Hi Doug,

I think it's partially correct. In RoCE, mlx4_ib_process_mad calls
iboe_process_mad directly.
iboe_process_mad assumes that we should always fill counters in the MAD's
response buffer (without checking it). Therefore, when IB_PMA_CLASS_PORT_INFO
is sent, we'll actually fill counters data. If the sysfs parses this data as
"extended counters are supported", it'll call the mlx4 driver
expecting to get these
counters. However, this functionality won't exist.

If you don't want to merge these two mlx4 patches, we could send a
patch that catches
IB_PMA_CLASS_PORT_INFO MAD and returns that only basic counters are supported.

Thanks for applying these patches,
Matan

> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
