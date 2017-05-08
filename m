From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma-core: define link speed and link width enums
Date: Mon, 8 May 2017 20:09:12 +0530
Message-ID: <CANjDDBip=n7QaxJiLtS9J5uAnzQn6emEFkGbuCF8GpwKZSrZxQ@mail.gmail.com>
References: <1494251057-1060-1-git-send-email-devesh.sharma@broadcom.com> <de4b2ea7-9613-80c6-b4a1-288f5c5bedcd@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <de4b2ea7-9613-80c6-b4a1-288f5c5bedcd-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 8, 2017 at 7:24 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 5/8/2017 9:44 AM, Devesh Sharma wrote:
>> Currently application either need to define its own enum
>> values for link-speed and link-width or use hard coded
>> values. This patch inharits the enums from kernel space
>> ib_verbs.h and puts into verbs.h for ease of programming.
>>
>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  libibverbs/examples/devinfo.c | 22 ++++++++++++----------
>>  libibverbs/verbs.h            | 18 ++++++++++++++++++
>>  2 files changed, 30 insertions(+), 10 deletions(-)
>>
>> diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
>> index 2c1e3f1..42ed50c 100644
>> --- a/libibverbs/examples/devinfo.c
>> +++ b/libibverbs/examples/devinfo.c
>> @@ -124,10 +124,10 @@ static const char *mtu_str(enum ibv_mtu max_mtu)
>>  static const char *width_str(uint8_t width)
>>  {
>>       switch (width) {
>> -     case 1:  return "1";
>> -     case 2:  return "4";
>> -     case 4:  return "8";
>> -     case 8:  return "12";
>> +     case IBV_WIDTH_1X:  return "1";
>> +     case IBV_WIDTH_4X:  return "4";
>> +     case IBV_WIDTH_8X:  return "8";
>> +     case IBV_WIDTH_12X:  return "12";
>>       default: return "invalid width";
>>       }
>>  }
>> @@ -135,14 +135,16 @@ static const char *width_str(uint8_t width)
>>  static const char *speed_str(uint8_t speed)
>>  {
>>       switch (speed) {
>> -     case 1:  return "2.5 Gbps";
>> -     case 2:  return "5.0 Gbps";
>> +     case IBV_SPEED_SDR:  return "2.5 Gbps";
>> +     case IBV_SPEED_DDR:  return "5.0 Gbps";
>>
>> -     case 4:  /* fall through */
>> -     case 8:  return "10.0 Gbps";
>> +     case IBV_SPEED_QDR:  /* fall through */
>> +     case IBV_SPEED_FDR10:  return "10.0 Gbps";
>>
>> -     case 16: return "14.0 Gbps";
>> -     case 32: return "25.0 Gbps";
>> +     case IBV_SPEED_FDR: return "14.0 Gbps";
>> +     case IBV_SPEED_EDR: return "25.0 Gbps";
>> +     case IBV_SPEED_HDR: return "50.0 Gbps";
>> +     case IBV_SPEE_NDR: return "100.0 Gbps";
>
> typo
[DS]: I fixed this specifically, my bad while sending out. Will fix.
>
>>       default: return "invalid speed";
>>       }
>>  }
>> diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
>> index b27dfd1..39a65fe 100644
>> --- a/libibverbs/verbs.h
>> +++ b/libibverbs/verbs.h
>> @@ -290,6 +290,24 @@ enum ibv_port_state {
>>       IBV_PORT_ACTIVE_DEFER   = 5
>>  };
>>
>> +enum ibv_port_speed {
>> +     IBV_SPEED_SDR    = 1,
>> +     IBV_SPEED_DDR    = 2,
>> +     IBV_SPEED_QDR    = 4,
>> +     IBV_SPEED_FDR10  = 8,
>> +     IBV_SPEED_FDR    = 16,
>> +     IBV_SPEED_EDR    = 32,
>> +     IBV_SPEED_HDR    = 64,
>> +     IBV_SPEED_NDR    = 128
>
> HDR is almost defined now but NDR is not. Is it premature to put in NDR
> now ?
[DS]: Okay, will remove NDR for now. I saw HDR was added into kernel
ib_verbs.h but not NDR,
it makes perfect sense to remove it.
>
> Also, if either of these are being added, should 2x also be added ?
>
> -- Hal
>
>> +};
>> +
>> +enum ibv_port_width {
>> +     IBV_WIDTH_1X     = 1,
>> +     IBV_WIDTH_4X     = 2,
>> +     IBV_WIDTH_8X     = 4,
>> +     IBV_WIDTH_12X    = 8
>> +};
>> +
>>  enum {
>>       IBV_LINK_LAYER_UNSPECIFIED,
>>       IBV_LINK_LAYER_INFINIBAND,
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
