From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Could use some help getting SIW compiling on latest kernels
Date: Thu, 12 May 2016 13:12:47 -0600
Message-ID: <CAANLjFo9hdb=6W6wdxkzMAP_XCbmg-TwUqU+dzVZFxTa-mf8TQ@mail.gmail.com>
References: <CAANLjFpmhtdfBsVCwAsLkmOx-mmTv9fb4u9VMM7ps3_c50s53Q@mail.gmail.com>
	<CAANLjFrhNathEQViOTePpjphWLqaXLTjPu=XrUiM3GAyD9yktA@mail.gmail.com>
	<76dbb62f-71f8-d348-2847-702a19ed32c7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <76dbb62f-71f8-d348-2847-702a19ed32c7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ahh, OK. Let me compile the user space libraries and hook that up.
That may be my missing link. I didn't realize that user space was
needed for this stage of getting the device up. I'll report back with
my results. Thanks for a direction to look at.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, May 12, 2016 at 1:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/10/2016 06:30 PM, Robert LeBlanc wrote:
>> I've figured out the error for the stack trace. Apparently iWARP
>> doesn't need/use MADs and removing
>>
>> immutable->max_mad_size = IB_MGMT_MAD_SIZE;
>>
>> fixes it. I still don't get a device to show up with ibv_devices so I
>> have some more digging to do. This is a minimal VM, so I could just be
>> missing some libraries or something.
>
> I wouldn't expect ibv_devices to show your device.  There is no user
> space library I assume.  Is there even a /dev/infiniband/uverbs0 file
> for the device?
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
