From: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is
 disabled
Date: Mon, 16 May 2016 19:31:13 +0300
Message-ID: <d6b3c895-6af0-33b7-79c5-f932243e7c48@mellanox.com>
References: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
 <f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16/05/2016 18:14, Doug Ledford wrote:
> On 05/15/2016 08:57 AM, Or Gerlitz wrote:
>> On some environments, such as certain SRIOV VF configurations, RoCE is
>> not supported for an Ethernet port. Currently, the driver will not
>> open IB device on that port.
>>
>> This is problematic, since we do want user-space RAW Ethernet (RAW_PACKET
>> QPs) functionality to remain in place. For that end, enhance the relevant
>> driver flows such that we do create a device instance in that case.
>>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> So this device is still going to present itself as a uverbs# device and
> libibverbs is still going to try and access it, but when it comes time
> for user applications to try and use it they will simply fail all QP
> types except for RAW?  Is there no way to distinguish between a device
> with RoCE enabled and without?
>
>

It's a bit broken, but you could query gid_tbl_len in ibv_port_attr.
If it's zero, RoCE can't be used anyway.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
