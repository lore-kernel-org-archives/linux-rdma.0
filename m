From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Wed, 22 Oct 2014 07:01:46 +0300
Message-ID: <54472C2A.7060407@mellanox.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>	<543CD5D6.1020506@mellanox.com>	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>	<5443DBCA.4000002@dev.mellanox.co.il>	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>	<CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>	<eaf7c875-e7e1-43eb-b27a-fbd068aa32f1@CMEXHTCAS1.ad.emulex.com>	<CAJ3xEMgnmZD8ONJcnor__eioMtfaO6MYMKfd6nbXncaWYXTG+g@mail.gmail.com> <CAJ3xEMi9uBB0fFqGj4nUOdYYezLzF135TLH-sswQ0G5hZQvAkA@mail.gmail.com> <54466C39.4070402@mellanox.com> <d89b8c11-5f4f-4a70-b2de-3342c6b628a8@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d89b8c11-5f4f-4a70-b2de-3342c6b628a8-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/22/2014 12:11 AM, Minh Duc Tran wrote:
> Hi Or,
>
>> So just to recaphere.
>> With your driver maximal attributes of 8K CQEs per CQ and 32 CQs per device, do/what we need to change s.t that the iser initiator functional with it's current code is functional on 3.18-rc1?
> Yes, I've just verified the patch with 3.18-rc1 on both ocrdma and mlx4 drivers.  They are working as expected.
>
>> Are you hitting an (inability) to create a CQ?
> Yes

So for 3.18 we should be OK with one liner patch that makes sure the 
size of the created CQ is maxed out against the quantity advertized in 
the device attributes, agree?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
