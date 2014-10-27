From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: re-adjust number of max_cqe and send_wr
 to hw supported number.
Date: Mon, 27 Oct 2014 11:35:48 +0200
Message-ID: <544E11F4.9030709@dev.mellanox.co.il>
References: <2cee0ee5-dd62-451a-a6a9-a237b59e8dd1@CMEXHTCAS1.ad.emulex.com> <544CDD66.3030303@dev.mellanox.co.il> <f3c8d326-54a7-4c61-b940-6e2ba4c80a25@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3c8d326-54a7-4c61-b940-6e2ba4c80a25-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/27/2014 7:01 AM, Minh Duc Tran wrote
> I like to follow up with all IB/iser changes and developments for 3.19.  Please keep me updated with these changes if they are not going to be in the RDMA mailing list.

We keep it all on the mailing list. Stay tuned... ;)

>
>> Can you try the patch attached with my bits modified?
>
>> Thanks,
>> Sagi
>
> Your modification to the patch looks good and ran as expected.

OK, so we will include it in our fixes for 3.18-rc2.

Thanks Minh!

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
